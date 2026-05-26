{ pkgs, lib, config, inputs, ... }:
{
  imports = [ inputs.dms-plugin-registry.modules.default ];
  programs.dms-shell = {
    enable = true;
    systemd = {
      enable = true;
      restartIfChanged = true;
    };

    enableSystemMonitoring = true;
    enableVPN = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
    enableClipboardPaste = true;

    plugins = {
      dankpomodoro.enable = true;
    };
  };
