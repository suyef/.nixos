{ pkgs, lib, config, ... }:
{
  # hint electron apps to use wayland
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
    systemd = {
      enable = true;
      variables = ["--all"];
      enableXdgAutostart = true;
    };
    package = null;
    portalPackage = null;
    settings = {
      "$mod" = SUPER;
      device = [
        {
          name = "touchpad";
          sensitivity = 0.25;
        }
      ];
      input = {
        kb_layout = "us";
        touchpad = {
          tap-and-drag = true;
        };
        tablet = {
          output = "current";
        };
      };
      general = {
        gaps_out = 5;
        gaps_in = 5;
      };
      gesture = [
        "3, horizontal, workspace"
      ];
      windowrule = [
        "opacity 0.0 override, no_anim on, no_initial_focus on, max_size 1 1, no_blur on, no_focus on, match:class ^(xwaylandvideobridge)$"
        "stay_focused on, match:class expo-orbit"
      ];
      binds = {
        scroll_event_delay = 0;
      };
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };
      bind = [
        "$mod, mouse_down, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {val = $2 * 1.2; if (val < 1) val=1; print val}')"
        "$mod, mouse_up, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {val = $2 * 0.8; if (val < 1) val=1; print val}')"

        "$mod, B, exec, firefox"
        "$mod, Return, exec, kitty"
        "$, Print, exec, ${pkgs.hyprshot}/bin/hyprshot -m active"
        "SHIFT, Print, exec, ${pkgs.hyprshot}/bin/hyprshot -m region"
        "$mod, X, exec, vicinae, open"
        "$mod, Q, killactive"
        "$mod, S, exec, signal-desktop"
        "$mod, O, togglefloating"
        "$mod, C, exec vicinae deeplink vicinae://extensions/vicinae/clipboard/history"
        "$mod SHIFT, L, exec, swaylock"
        "$mod, F, fullscreen"
        # Move with hjkl
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, L, movewindow, r"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, J, movewindow, d"
      ]
      ++ (
        let
          numWorkspaces =
            builtins.genList (
              i: let
                ws =
                  if i == 9
                  then 10
                  else i + 1;
                key =
                if i == 9
                then "0"
                else toString (i + 1);
              in [
                "$mod, ${key}, workspace, ${toString ws}"
                "$mod SHIFT, ${key}, movetoworkspace, ${toString ws}"
              ]
            )
            10;
          fWorkspaces =
            builtins.genList (
              i: let
                ws = "F${toString (i = 1)}";
                key = "F${toString (i + 1)}";
              in [
                "$mod, ${key}, workspace, mane:${ws}"
                "$mod SHIFT, ${key}, movetoworkspace, mane:${ws}"
              ]
            )
            12;
        in
          builtins.concatLists (numWorkspaces ++ fWorkspaces)
      );
    };
  };

  services.awww.enable = true;
  services.swaylock.enable = true;
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "swaylock";
        before_sleep_cmd = "swaylock";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 180;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 300;
          on-timeout = "swaylock";
        }
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on && brightnessctl -r";
        }
        {
          timeout = 480;
            on-timeout = "systemctl suspend";
        }
      ];
    };
  };
  systemd.user.services.hypridle = {
    Unit = {
      PartOf = lib.mkForce ["hyprland-session.target"];
      After = lib.mkForce ["hyprland-session.target"];
    };
    Install.WantedBy = lib.mkForce ["hyprland-session.target"];
  };
  systemd.user.services.kwallet-pam = {
    Unit = {
      Description = "KWallet PAM Auto-unlock";
      PartOf = ["hyprland-session.target"];
      After = ["hyprland-session.target"];
    };
    Install = {
      WantedBy = ["hyprland-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init";
      Type = "oneshot";
    };
  };
  systemd.user.services.wl-clip-persist = {
    Unit = {
      Description = "Persistent clipboard for Wayland";
      PartOf = ["hyprland-session.target"];
      After = ["hyprland-session.target"];
    };
    Install = {
      WantedBy = ["hyprland-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard regular";
      Restart = "on-failure";
      Type = "simple";
    };
  };
}
