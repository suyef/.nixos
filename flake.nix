{
  description = "flaked";

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
    stylix = {
      url = "github:nix-community/stylix";
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
    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    lib = import ./lib/mkHost.nix {inherit inputs;};
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
	  # ./modules/programs/virtualization
	];
      };
    };
  };
}
