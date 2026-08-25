{pkgs, ...}: {
  services.printing = {
    enable = false;
    drivers = [
      pkgs.hplipWithPlugin
    ];
  };
}
