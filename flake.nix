{
  description = "flaked";

  nixConfig = {
    substituters = [
      "https://install.determinate.systems?priority=20"
      "https://cache.nixos.org?priority=40"
      "https://nix-community.cachix.org?priority=41"
      "https://attic.xuyh0120.win/lantian?priority=42"
      "https://numtide.cachix.org?priority=43"
      "https://vicinae.cachix.org?priority=44"
      "https://noctalia.cachix.org?priority=45"
    ];
    extra-trusted-public-keys = [
      "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    vicinae = {
      url = "github:vicinaehq/vicinae";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-facter-modules.url = "github:nix-community/nixos-facter-modules";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #inputs.stm32cubeide.url = "git+https://git.sr.ht/~shelvacu/stm32cubeide-nix";
    nixvim = {
      url = "github:nix-community/nixvim";
    };
    neu-nix = {
      url = "github:ricardomaps/neu-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    driftwm.url = "github:malbiruk/driftwm";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    lib = import ./lib/mkHost.nix {inherit inputs;};
    #overlays = [ inputs.stm32cubeide.overlays.default ];
  in {
    nixosModules = {
      nix-file-overlay = ./modules/nix-file-overlay;
      dreamingoptimal = ./modules/dreamingoptimal;
      dreamingoptimal-ram = ./modules/dreamingoptimal/ram.nix;
      dreamingoptimal-tmp = ./modules/dreamingoptimal/tmp.nix;
      dreamingoptimal-swap-fallback = ./modules/dreamingoptimal/swap-fallback.nix;
      dreamingoptimal-process-tuning = ./modules/dreamingoptimal/process-tuning.nix;
      dreamingoptimal-sysctl = ./modules/dreamingoptimal/sysctl.nix;
      dreamingoptimal-bpftune = ./modules/dreamingoptimal/bpftune.nix;
      dreamingoptimal-cachykernel = ./modules/dreamingoptimal/cachykernel.nix;
      dreamingoptimal-fstrim = ./modules/dreamingoptimal/fstrim.nix;
      dreamingoptimal-envfs = ./modules/dreamingoptimal/envfs.nix;     
    };

    hmModules = {
      nix-file-overlay = ./modules/nix-file-overlay/hm-module.nix;
    };
    nixosConfigurations = {
      tuna = lib.mkHost {
        hostname = "tuna";
	hostPath = "tuna";
	extraModules = [
	    #./modules/programs/virtualization TODO fix
	];
      };
    };
  };
}
