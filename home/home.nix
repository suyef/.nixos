{ lib, config, pkgs, inputs, ... }: {
  imports = [
  # inputs.___.homeManagerModule
  # ./nvim.nix
  # ./mango.nix
  # etc
    inputs.vicinae.homeManagerModules.default
    ./fish.nix
    ./hypr/hyprland.nix
    ./vicinae.nix
  ];

  home = {
    username = "suyef";
    homeDirectory = "/home/suyef";
    shell.enableShellIntegration = true;
  };
  
  home.file.".config/hypr" = {
     source = ./config/hypr;
     recursive = true;
     forceLink = true;
  };

  #home.file.".config/kitty" = {
  #  source = ./config/kitty;
  #  recursive = true;
  #};

  #programs.neovim.enable = true;
  #home.packages = with pkgs; [
  #  neovim
  #];
  
  programs.home-manager.enable = true;
  programs.git.enable = true;

  home.stateVersion = "25.11";
}
