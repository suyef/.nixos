{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./modules/core/boot.nix
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
      ./modules/programs/packages.nix
      ./modules/programs/steam.nix
      ./modules/desktop/fonts.nix
      ./modules/desktop/wayland.nix
    ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs; };
  home-manager.backupFileExtension = "bak";
  home-manager.users.suyef = {
    imports = [ ./home/home.nix ];
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.flake-registry = "";
  
  # channels are dead and flakes have killed them
  nix.channel.enable = false;
  
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."luks-5f80f39f-ef67-4a02-a41b-c2db10b4a877".device = "/dev/disk/by-uuid/5f80f39f-ef67-4a02-a41b-c2db10b4a877";
  networking.hostName = "tuna";
  networking.networkmanager.enable = true;
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  services.printing.enable = false;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/suyef/.config/sops/age/keys.txt";

  security = {
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
  
  # enable to make swaylock work
  security.pam.services.swaylock = {};

  programs.fish.enable = true;

  users.users.suyef = {
    isNormalUser = true;
    description = "suyef";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };

  programs.firefox.enable = true;

  

  environment.systemPackages = with pkgs; [
    git
    vis
    wget
    kitty
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;



  system.stateVersion = "25.11"; # probably dont change

}
