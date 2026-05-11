{ inputs, pkgs, ... }:
{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    polarity = "dark";
    
    #TODO write a script that automatically symlinks ~/.activewall to whatever wallpaper awww has set 
    image = ./config/wallpapers/Cat_at_Play.png;

    opacity = {
      applications = 0.8;
      terminal = 0.9;
      popups = 0.75;
    };
    targets = {
      #neovim.enable = false;
    };

    fonts = {
      serif = {
        name = "Cantarell";
        package = pkgs.cantarell-fonts;
      };

      sansSerif = {
        name = "Cantarell";
        package = pkgs.cantarell-fonts;
      };

      monospace = {
        name = "Fira Code";
        package = pkgs.fira-code;
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 11;
        desktop = 11;
      };
    };
    cursor = {
      name = "Bibata-Modern-Ice";
      size = 32;
    };
  };
}
