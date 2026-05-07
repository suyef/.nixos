{
  description = "flaked";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
  in {
    nixosConfigurations = {
      tuna = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [./configuration.nix];
      };
    };
  
    homeConfigurations = {
      "suyef@tuna" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs;};
        modules = [./home.nix];
      };
    };
  };
}
