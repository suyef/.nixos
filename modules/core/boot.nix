{ pkgs, ... }: {
  boot = {
    loader.limine.enable = true;
    loader.efi.canTouchEfiVariables = true;
    consoleLogLevel = 0;
    initrd = {
      systemd.enable = true;
      verbose = false;
      # Don't show the LUKS prompt until GPU drivers (amdgpu) are loaded,
      # otherwise the simpledrm -> amdgpu handoff blanks and redraws it mid-typing.
      systemd.services.systemd-ask-password-console = {
        wants = ["systemd-modules-load.service"];
        after = ["systemd-modules-load.service"];
      };
    };
    kernelParams = [
      "acpi_call"
    ];
  };
}
