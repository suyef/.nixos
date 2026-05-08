{ inputs, lib, config, pkgs, ... }: {
  imports = [
  # inputs.___.homeManagerModule
  # ./nvim.nix
  # ./mango.nix
  # etc
    ./fish.nix
  ];

  nixpkgs = {
    overlays = [

    ];
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "suyef";
    homeDirectory = "/home/suyef";
    shell.enableShellIntegration = true;
  };

  programs.neovim.enable = true;
  home.packages = with pkgs; [
  ];

  programs.home-manager.enable = true;
  programs.git.enable = true;

  home.stateVersion = "25.11";
}
