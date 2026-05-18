{ lib, config, pkgs, inputs, ... }: {
  imports = [
  # inputs.___.homeManagerModule
  # ./nvim.nix
  # ./mango.nix
  # etc
    inputs.vicinae.homeManagerModules.default
    inputs.stylix.homeModules.default
    inputs.ags.homeManagerModules.default
    ./fish.nix
    ./stylix.nix
    ./hyprland.nix
    ./vicinae.nix
    ./ags.nix
  ];

  home = {
    username = "suyef";
    homeDirectory = "/home/suyef";
    shell.enableShellIntegration = true;
  };

  services = {
    gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-qt;
      extraConfig = "pinentry-program ${pkgs.pinentry-qt}/bin/pinentry-qt";
    };
  };

# lua config ready to go
#
  home.file."./.config/hypr" = {
     source = ./config/hypr;
     recursive = true;
     force = true;
  };

  #home.file.".config/kitty" = {
  #  source = ./config/kitty;
  #  recursive = true;
  #};

  home.file.".config/matugen" = {
    source = ./config/matugen;
    recursive = true;
  };

  home.file."Pictures/wallpapers" = {
    source = ./config/wallpapers;
    recursive = true;
  };

  home.file.".config/wayle".source = ./config/wayle;


  #programs.neovim.enable = true;
  home.packages = with pkgs; [
    matugen
    opencode
    inputs.astal.packages.${pkgs.system}.notifd
    apple-cursor
    hyprcursor
    wayle
  ];
  
  programs.home-manager.enable = true;
  programs.git.enable = true;

  home.stateVersion = "25.11";
}
