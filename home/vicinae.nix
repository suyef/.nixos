{ pkgs, lib, config, inputs, ...}: {
  imports = [ inputs.vicinae.homeManagerModules.default ];
  services.vicinae = {
    enable = true;
    package = pkgs.vicinae;
    systemd = {
      enable = true;
      autoStart = true;
      environment = {
        USE_LAYER_SHELL = 1;
      };
    };
    extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
      it-tools
      nix
      player-pilot
      port-killer
      power-profile
      process-manager
      wifi-commander
    ];
  };

  # Vicinae base config (read-only, imported by user settings.json)
  home.file.".config/vicinae/base-config.json".text = builtins.toJSON {
    close_on_focus_loss = true;
    pop_to_root_on_close = true;
    favorites = [];
    font = {
      normal = {
        family = "FiraCode Nerd Font";
      };
    };
    providers = {
      "@Gelei/bluetooth-0" = {
        preferences.connectionToggleable = true;
      };
      "@gebeto/store.raycast.translate" = {
        preferences.autoInput = true;
        entrypoints = {
          instant-translate-copy.enabled = false;
          instant-translate-paste.enabled = false;
          instant-translate-view.enabled = false;
          quick-translate.enabled = true;
          translate.enabled = false;
          translate-form.enabled = false;
        };
      };
      "@knoopx/nix-0" = {
        entrypoints.flake-packages.enabled = true;
      };
        entrypoints = {
          appendTaskCommand.enabled = false;
          dailyNoteAppendCommand.enabled = false;
          dailyNoteCommand.enabled = false;
          openVaultCommand.enabled = false;
          openWorkspaceCommand.enabled = false;
          randomNoteCommand.enabled = false;
          searchMedia.enabled = false;
        }; 
      "@ratoru/store.raycast.google-maps-search" = {
        preferences = {
          preferredMode = "driving";
          preferredOrigin = "home";
          useSelected = true;
        };
        entrypoints = {
          find.enabled = false;
          quickSearchMaps.enabled = false;
          travelHome.enabled = false;
          travelTo.alias = "driveto";
        };
      };
      clipboard = {
        preferences.encryption = true;
        entrypoints.history.preferences.defaultAction = "copy";
      };
      core = {
        entrypoints = {
          about.enabled = false;
          documentation.enabled = false;
          keybind-settings.enabled = false;
          list-extensions.enabled = false;
	  open-config-file.enabled = false;
          open-default-config.enabled = false;
          report-bug.enabled = false;
          sponsor.enabled = false;
        };
      };
      files = {
        enabled = false;
        preferences.autoIndexing = true;
      };
      power = {
        entrypoints = {
          hibernate.enabled = false;
          sleep.enabled = false;
        };
      };
      theme.enabled = false;
    };
  };

  # Create settings.json with imports if it doesn't exist or doesn't have imports
  home.activation.vicinaSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    SETTINGS_FILE="$HOME/.config/vicinae/settings.json"
    if [ ! -f "$SETTINGS_FILE" ] || ! grep -q '"imports"' "$SETTINGS_FILE" 2>/dev/null; then
      mkdir -p "$(dirname "$SETTINGS_FILE")"
      echo '{"imports": ["base-config.json"]}' > "$SETTINGS_FILE"
    fi
  '';
}
