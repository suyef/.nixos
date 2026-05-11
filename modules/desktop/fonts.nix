{pkgs, ...}: {
  fonts.packages = with pkgs; [
  nerd-fonts.iosevka
  noto-fonts-emoji
  cantarell-fonts
  nerd-fonts.fira-code
  ];
}
