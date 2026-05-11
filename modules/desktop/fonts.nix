{pkgs, ...}: {
  fonts.packages = with pkgs; [
  nerd-fonts.iosevka
  noto-fonts-color-emoji
  cantarell-fonts
  nerd-fonts.fira-code
  ];
}
