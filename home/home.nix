{ lib, config, pkgs, inputs, ... }: {
  imports = [
  # inputs.___.homeManagerModule
  # ./nvim.nix
  # ./mango.nix
  # etc
    inputs.vicinae.homeManagerModules.default
    ./fish.nix
  #  ./stylix.nix
    ./hyprland.nix
    ./vicinae.nix
  ];

  home = {
    username = "suyef";
    homeDirectory = "/home/suyef";
    shell.enableShellIntegration = true;
  };

# lua config ready to go
#
#  home.file."./.config/hypr" = {
#     source = ./config/hypr;
#     recursive = true;
#     force = true;
#  };

  #home.file.".config/kitty" = {
  #  source = ./config/kitty;
  #  recursive = true;
  #};

  home.file.".config/matugen" = {
    source = ./config/matugen;
    recursive = true;
  };

  #programs.neovim.enable = true;
  home.packages = with pkgs; [
    matugen
    opencode
  ];
  
  programs.home-manager.enable = true;
  programs.git.enable = true;

  home.stateVersion = "25.11";
}
