{
  config,
  pkgs,
  lib,
  nix-index-database,
  inputs,
  ...
}: let
  # Groups shared by all users
  commonGroups = [
    "networkmanager"
    "docker"
    "kvm"
    "adbusers"
    "input"
    "plugdev"
    "pipewire"
    "wireshark"
    "dialout"
    "flatpak"
    "nix"
  ];

  # Admin-only groups (sudo + libvirt system access)
  adminGroups = [
    "wheel"
    "libvirtd"
  ];
in {
  # Export groups for use in other modules 
  options.users.commonGroups = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = commonGroups;
    description = "Common groups shared by all users";
  };

  config = {
    # Ensure flatpak group exists even on systems without flatpak enabled
    users.groups.flatpak = {};
    # Group for non-admin users to access nix
    users.groups.nix = {};

    security = {
      # auto unlock kwallet on boot
      pam = {
        services = {
          "suyef" = {
            kwallet = {
              enable = true;
              package = pkgs.kdePackages.kwallet-pam;
            };
          };
        };
      };
    };

    users.users.suyef = {
      isNormalUser = true;
      description = "suyef";
      extraGroups = commonGroups ++ adminGroups;
      shell = pkgs.fish;
    };

    # Home Manager configuration
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.extraSpecialArgs = {inherit inputs;};
    home-manager.backupFileExtension = "bak";

    home-manager.users.suyef = {
      home.stateVersion = "26.05";

      imports = [
        nix-index-database.homeModules.nix-index
        ../../home/home.nix
      ];
    };
  };
}
