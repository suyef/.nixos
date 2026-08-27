{inputs, ...}: let
  commonModules = [
    inputs.nixos-facter-modules.nixosModules.facter
    inputs.nur.modules.nixos.default
    inputs.home-manager.nixosModules.home-manager
    inputs.determinate.nixosModules.default
    inputs.sops-nix.nixosModules.sops
    inputs.stylix.nixosModules.stylix
    inputs.driftwm.nixosModules.default
    ../modules/dreamingoptimal
    ../modules/nix-file-overlay
  ];
in {
  mkHost = {
    hostname,
    hostPath,
    extraModules ? [],
  }:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        inherit
          (inputs)
          home-manager
          nix-index-database
          vicinae
          ;
      };
      modules =
        commonModules
        ++ [
          ../hosts/common.nix
          ../hosts/${hostPath}
          {
            facter.reportPath = ../hosts/${hostPath}/facter.json;
            networking.hostName = hostname;
          }
        ]
        ++ extraModules;
    };
}
