{ inputs, pkgs, ... }:
{
  programs.ags = {
    enable = true;
    configDir = ./config/ags;
    extraPackages = with pkgs; [
      inputs.astal.packages.${pkgs.system}.battery
    ];
  };
}
