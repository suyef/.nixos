{ pkgs, inputs, ... }: {
  imports = [
    ./nixvim/nvim.nix
    ./fish.nix
    ./hyprland.nix
    ./vicinae.nix
    #./stylix.nix
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

  home.file."./.config/hypr" = {
     source = ./config/hypr;
     recursive = true;
     force = true;
  };

  home.file."./.config/niri" = {
    source = ./config/niri;
    recursive = true;
  };

  home.file."./.config/alacritty" = {
    source = ./config/alacritty;
    recursive = true;
  };

  #home.file."./.config/foot" = {
  #  source = ./config/foot;
  #  recursive = true;
  #};

  #home.file.".config/kitty" = {
  #  source = ./config/kitty;
  #  recursive = true;
  #};

  home.file."Pictures/wallpapers" = {
    source = ./config/wallpapers;
    recursive = true;
  };

  #programs.neovim.enable = true;
  home.packages = with pkgs; [
    opencode
    apple-cursor
    hyprcursor
    waybar
    eww
    #inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
  
  programs.home-manager.enable = true;
  programs.git.enable = true;

  home.sessionVariables = {
    TERMINAL = "alacritty";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.stateVersion = "26.05";
}
