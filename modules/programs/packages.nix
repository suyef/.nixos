{
  pkgs,
  inputs,
  lib,
  ...
}: let
  rsworktree = pkgs.rustPlatform.buildRustPackage rec {
    pname = "rsworktree";
    version = "0.7.1";

    src = pkgs.fetchCrate {
      inherit pname version;
      hash = "sha256-tvgvbOlZvg24WoiC4EPgvqaPizNd/Ir68QQpYjWQZgk=";
    };

    cargoHash = "sha256-PJrl8JghJ69+FbtSVKibiJYFaQQ3PV9+eU7N9nX/TxA=";

    # Tests require git and network access
    doCheck = false;

    nativeBuildInputs = [pkgs.pkg-config];
    buildInputs = [pkgs.openssl];
  };
in {
  programs = {};

  environment.systemPackages = with pkgs; [
    signal-desktop
    sops
    tor-browser
    kwalletcli
    gnupg
    btop
    xdg-desktop-portal

    # the browser
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

  ];
}
