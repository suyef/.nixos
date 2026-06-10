{ config, lib, pkgs, ... }:

let
  matugenColors = builtins.fromJSON (builtins.readFile (builtins.getEnv "HOME" + "/.cache/matugen/colors.json"));

  c = matugenColors.colors.dark; 

in {
  programs.nixvim.highlight = {
    Normal = { fg = c.on_background; bg = c.background; };
    Cursor = { fg = c.background; bg = c.primary; };
  };
  
  programs.nixvim.extraConfigLua = ''
    _G.matugen_colors = {
      primary = "${c.primary}",
      secondary = "${c.secondary}",
      background = "${c.background}",
    }
  '';
}
