{ 
pkgs, 
inputs, 
lib,
... 
}:
{
 # System-wide MIME associations to ensure consistency with portal usage

  xdg.mime = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "text/html" = "zen.desktop";
    };
  };

  xdg.portal = {
    xdgOpenUsePortal = true;
    enable = true;

    config = {
      hyprland = {
        default = [
          "hyprland"
          "gtk"
          "kde"
        ];
        "org.freedesktop.impl.portal.FileChooser" = "kde";
        "org.freedesktop.impl.portal.OpenURI" = "kde";
      };
      niri = lib.mkForce {
        default = [
          "gnome"
          "gtk"
          "kde"
        ];
        "org.freedesktop.impl.portal.Access" = "gtk";
        "org.freedesktop.impl.portal.FileChooser" = "kde";
        "org.freedesktop.impl.portal.Notification" = "gtk";
        "org.freedesktop.impl.portal.OpenURI" = "kde";
        "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
      };
      plasma = {
        default = [
          "kde"
          "gtk"
        ];
        "org.freedesktop.impl.portal.FileChooser" = "kde";
        "org.freedesktop.impl.portal.OpenURI" = "kde";
      };
    };

    extraPortals = with pkgs; [
      #xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      kdePackages.xdg-desktop-portal-kde
      #kdePackages.kwallet
      xdg-desktop-portal-gnome
    ];
  };


  services.envfs.enable = true;

  services.xserver.enable = true;

  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "niri";
    configHome = "/home/suyef";
  };

  services.displayManager.defaultSession = "niri";

  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    konsole
    kate
    elisa
    krdp
    plasma-browser-integration
  ];

  # Set the menu prefix so kbuildsycoca6 knows to look for plasma-applications.menu
  environment.sessionVariables = {
    XDG_MENU_PREFIX = "plasma-";
  };

  # This fixes the unpopulated MIME menus in kde applications
  environment.etc."/xdg/menus/plasma-applications.menu".text =
    builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  environment.systemPackages = with pkgs; [
    niri
    niriswitcher
    xwayland-satellite
  ];

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Centralized storage for coredumps (coredumpctl list)
  systemd.coredump.enable = true;

  # dconf needed for GTK apps and virt-manager
  programs.dconf.enable = true;

  environment.etc = {
    # https://github.com/Scrut1ny/Hypervisor-Phantom
    "ovmf" = {
      source = ../../home/config/ovmf;
    };
  };
}
