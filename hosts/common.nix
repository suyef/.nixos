{pkgs, ...}: {
  imports = [
    ../modules/core/boot.nix
    ../modules/core/networking.nix
    ../modules/core/nix.nix
    ../modules/core/security.nix
    #../modules/core/sops.nix
    ../modules/hardware/audio.nix
    #../modules/hardware/bluetooth.nix
    ../modules/hardware/graphics.nix
    ../modules/desktop/fonts.nix
    ../modules/desktop/wayland.nix
    ../modules/services/docker.nix
    ../modules/services/printing.nix
    ../modules/services/samba.nix
    ../modules/services/flatpak.nix
    ../modules/services/auto-update.nix
    ../modules/programs/steam.nix
    ../modules/programs/packages.nix
    ../modules/users/suyef.nix
    ../modules/desktop/dms.nix
   # ../modules/desktop/neu.nix
  ];

  # Timezone and locale (common to all hosts)
  services.automatic-timezoned.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";

  # Use Cloudflare-based geolocation service
  services.geoclue2 = {
    enable = true;
    geoProviderUrl = "https://cloudflare-location-service.dreamingcodes.workers.dev/";
  };

  dreamingoptimal.optimization.enable = true;

  nix-file-overlay = {
    enable = true;
    systemRepoPath = "/home/suyef/.nixos";
    users = ["suyef"];
  };

  # Ensure geoclue starts after wpa_supplicant to reduce WiFi scan race condition
  systemd.services.geoclue.after = ["wpa_supplicant.service"];
  systemd.services.geoclue.wants = ["wpa_supplicant.service"];

  # State version
  system.stateVersion = "26.05";

  # Disable NixOS options documentation to avoid builtins.toFile warnings from NUR
  documentation.nixos.enable = false;
  documentation.doc.enable = false;
}
