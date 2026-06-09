{ config, pkgs, ... }:
{
  services.xserver.windowManager.bspwm = {
    enable = true;
    configFile = ~/.config/bspwm/bspwmrc;
    sxhkd.configFile = ~/.config/sxhkd/sxhkdrc;
  };
}
