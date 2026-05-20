{
  description = "flaked";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vicinae = {
      url = "github:vicinaehq/vicinae";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.astal.follows = "astal";
    };

    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    nixosModules = {
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

    nixosConfigurations = {
      tuna = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
	stylix.nixosModules.stylix
	./configuration.nix
	];
      };
    };
  
    homeConfigurations = {
      "suyef" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs;};
        modules = [./home/home.nix];
      };
    };
  };
}
