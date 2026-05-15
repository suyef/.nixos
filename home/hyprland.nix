{ pkgs, lib, config, inputs, ... }:
{
  #imports = [ inputs.hyprland.homeModules.default ];
  # hint electron apps to use wayland
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      variables = ["--all"];
      enableXdgAutostart = true;
    };
    package = null;
    portalPackage = null;
    settings = {
      "$mod" = "SUPER";
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
	  natural_scroll = true;
        };
        tablet = {
          output = "current";
        };
      };
      general = {
        gaps_out = 0;
        gaps_in = 0;
      };
      dwindle = {
      	pseudotile = true;
	preserve_split = true;
	force_split = 2;
      };
      animations = {
        enabled = true;

        bezier = [
          "easeOutQuint, 0.23,1,0.32,1"
          "easeInOutCubic, 0.65,0.05,0.36,1"
          "linear, 0,0,1,1"
          "almostLinear, 0.5,0.5,0.75,1.0"
          "quick, 0.15,0,0.1,1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };
      gestures = {
	workspace_swipe_forever = true;
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

        "$mod, B, exec, zen"
        "$mod, Return, exec, kitty"
        ", Print, exec, ${pkgs.hyprshot}/bin/hyprshot -m active"
        "SHIFT, Print, exec, ${pkgs.hyprshot}/bin/hyprshot -m region"
        "$mod, X, exec, vicinae open"
        "$mod, Q, killactive"
        "$mod, S, exec, signal-desktop"
        "$mod, O, togglefloating"
	"$mod SHIFT, I, togglesplit"
	", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"
	", XF86MonBrightnessUp, exec, brightnessctl set 10%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
	", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
	", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
	", XF86WLAN, exec, nmcli radio wifi toggle"
	", XF86Refresh, exec, xdotool key F5"
        "$mod, C, exec, vicinae deeplink vicinae://extensions/vicinae/clipboard/history"
        "$mod SHIFT CTRL, L, exec, swaylock"
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

        "$mod SHIFT, right, resizeactive, 10 0"
        "$mod SHIFT, left, resizeactive, -10 0"
        "$mod SHIFT, up, resizeactive, 0 -10"
        "$mod SHIFT, down, resizeactive, 0 10"
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
                ws = "F${toString (i + 1)}";
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
    extraConfig = ''
      exec-once = ags run ~/nixos/home/config/ags/app.tsx
    '';
  };


  xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh"; # embrace systemd


  services.awww.enable = true;
  programs.swaylock.enable = true;

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
