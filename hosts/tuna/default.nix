{
  pkgs,
  lib,
  config,
  ...
}:
{
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usb_storage"
    "usbhid"
    "thunderbolt"
    "sdhci_pci"
    "sd_mod"
  ];
  fileSystems."/" = {
    device = "/dev/mapper/luks-06b9a610-32df-4506-8f3c-ea15a6c11a3e";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/FB70-07B8";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };
  boot.initrd.luks.devices."luks-06b9a610-32df-4506-8f3c-ea15a6c11a3e".device = "/dev/disk/by-uuid/06b9a610-32df-4506-8f3c-ea15a6c11a3e";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  environment.systemPackages = with pkgs; [nrfutil];
  nixpkgs.config.segger-jlink.acceptLicense = true;

  # Enable rocm support for the iGPU on the laptop
  nixpkgs.config.rocmSupport = true;
  # Enable cuda support for the dGPU on the laptop
  nixpkgs.config.cudaSupport = true;

  # TODO: Remove this overlay once UCX 1.21.0 GDAKI build issue is fixed upstream
  # or patched in nixpkgs. See https://github.com/openucx/ucx/issues/11591
  # The issue: UCX's Makefile.am unconditionally adds gdaki to SUBDIRS even when
  # --without-gda is passed, causing a build failure due to missing DOCA gpunetio headers.
  nixpkgs.overlays = [
    (final: prev: {
      ucx = prev.ucx.overrideAttrs (old: {
        configureFlags = (old.configureFlags or []) ++ [
          "--without-gda"
        ];
        postPatch = (old.postPatch or "") + ''
          # Fix: UCX 1.21.0 unconditionally adds gdaki to SUBDIRS in the parent
          # Makefile.am, even when --without-gda is passed. This causes make to
          # enter gdaki/ where it fails on missing DOCA gpunetio headers.
          # See: https://github.com/openucx/ucx/issues/11591
          #
          # Strategy: Remove source files that reference missing DOCA headers,
          # but KEEP configure.m4 and Makefile.am so autoreconf doesn't fail.
          # Then replace Makefile.am with a no-op stub.
          rm -f src/uct/ib/mlx5/gdaki/*.c
          rm -f src/uct/ib/mlx5/gdaki/*.cuh
          rm -f src/uct/ib/mlx5/gdaki/*.h
          rm -rf src/uct/ib/mlx5/gdaki/gpunetio/
          cat > src/uct/ib/mlx5/gdaki/Makefile.am <<'MKEOF'
          # Intentionally empty - GDAKI disabled (missing DOCA gpunetio headers)
          EXTRA_DIST =
          MKEOF
        '';
      });
    })
  ];

  boot.kernelModules = ["kvm-amd"];
  # nvidia.NVreg_EnableGpuFirmware=0
  boot.kernelParams = [
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    # amd flicker fixes
    "amdgpu.dcdebugmask=0x410"
    "amdgpu.abmlevel=0"
    "amdgpu.dcfeaturemask=0x2"
  ];

  hardware.nvidia-container-toolkit.enable = true;

  ### Nvidia STUFF
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [
    "nvidia"
    "amdgpu"
  ];

  # asusctl
  services.asusd = {
    enable = true;
  };

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = true;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = false;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.keyboard.qmk.enable = true;
  services.udev.packages = with pkgs; [
    nrf-udev
    pkgs.keychron-udev-rules
  ];

  # Keychron Q6 Pro - grant hidraw access for VIA/QMK configurator
  # Keychron Q6 Pro udev rules
  services.udev.extraRules = ''
    # Keychron Q6 Pro - world read/write for WebHID browser access
    KERNEL=="hidraw*", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0660", MODE="0666", GROUP="plugdev", TAG+="uaccess"
    # Disable USB autosuspend for all HID input devices (keyboards, mice, etc.)
    # When an interface with HID class (03) is added, walk up to the parent usb_device and disable autosuspend
    ACTION=="add", SUBSYSTEM=="usb", ATTR{bInterfaceClass}=="03", RUN+="${pkgs.bash}/bin/bash -c 'echo on > /sys$devpath/../power/control 2>/dev/null || true'"
    # Saleae Logic analyzers
    SUBSYSTEM=="usb", ATTR{idVendor}=="0925", ATTR{idProduct}=="3881", MODE="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="21a9", MODE="0666"
  '';

  # Disable USB autosuspend for all HID input devices at boot (runs after powertop which enables autosuspend)
  # Re-disable USB autosuspend for HID input devices after powertop enables it globally
  systemd.services.powertop.serviceConfig.ExecStartPost = "${pkgs.bash}/bin/bash -c 'for intf in /sys/bus/usb/devices/*:*/bInterfaceClass; do if [ -f \"$intf\" ] && [ \"$(cat \"$intf\")\" = \"03\" ]; then devpath=\"$(dirname \"$intf\")\"; parent=\"$(readlink -f \"$devpath/..\")\"; if [ -f \"$parent/power/control\" ]; then echo on > \"$parent/power/control\"; fi; fi; done'";

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    nvidiaBusId = "PCI:1:0:0";
    amdgpuBusId = "PCI:4:0:0";
  };

  specialisation = let
    # Base specialisations (without open/proprietary split)
    baseSpecialisations = {
      performance = {
        system.nixos.tags = ["performance"];
        hardware.nvidia = {
          powerManagement.finegrained = lib.mkForce false;
          prime.offload.enable = lib.mkForce false;
          prime.offload.enableOffloadCmd = lib.mkForce false;
          prime.sync.enable = lib.mkForce true;
        };
      };

      reverse = {
        system.nixos.tags = ["reverse"];
        hardware.nvidia = {
          powerManagement.finegrained = lib.mkForce false;
          prime.offload.enable = lib.mkForce false;
          prime.offload.enableOffloadCmd = lib.mkForce false;
          prime.sync.enable = lib.mkForce false;
          prime.reverseSync.enable = lib.mkForce true;
        };
      };
    };

    # Function to generate open/proprietary variants
    mkVariants = name: cfg: {
      "${name}-open".configuration =
        cfg
        // {
          system.nixos.tags = cfg.system.nixos.tags ++ ["open"];
          hardware.nvidia.open = lib.mkForce true;
        };
    };

    # Merge all generated variants
    generated = lib.foldl' lib.recursiveUpdate {} (lib.mapAttrsToList mkVariants baseSpecialisations);
  in
    generated
    // {
      # Keep no-gpu as is (no variants)
      no-gpu.configuration = {
        system.nixos.tags = ["no-gpu"];
        boot.extraModprobeConfig = ''
          blacklist nouveau
          options nouveau modeset=0
        '';
        services.udev.extraRules = ''
          ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
          ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
          ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
          ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
        '';
        boot.blacklistedKernelModules = [
          "nouveau"
          "nvidia"
          "nvidia_drm"
          "nvidia_modeset"
        ];
      };
    };
}
