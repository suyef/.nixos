{ inputs, lib, config, pkgs, ... }: {
  imports = [
  # inputs.___.homeManagerModule
  # ./nvim.nix
  # ./mango.nix
  # etc
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
  };

  programs.neovim.enable = true;
  home.packages = with pkgs; [
    

  ];

  programs.home-manager.enable = true;
  programs.git.enable = true;

  home.stateVersion = "25.11";
}
