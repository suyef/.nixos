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

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    git
    wget
    kitty
    neovim
    vis

    signal-desktop
    #nheko

    (discord.override {
      withOpenASAR = true;
    })

    sops
    tor-browser
    pinentry-qt
    gnupg
    btop
    xdg-desktop-portal

    wl-clipboard-rs
    wl-clip-persist

    brightnessctl
    prismlauncher
    gurk-rs
    ratty
    ghostty
    foot
    alacritty
    android-tools

    # sin
    stm32cubemx
    vscode 
    zed-editor

    yazi

    # the browser
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

    bun
    rustup
    nodejs # i HATE nodejs!!! 
    ffmpeg
    uv

    foot
    tmux
    mako
    zathura

  ];
}
