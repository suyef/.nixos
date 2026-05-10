{ pkgs, lib, config, ... }: {
  programs = {
    fish = {
      enable = true;
      generateCompletions = false;
      interactiveShellInit = ''
        set fish_greeting
      '';
      shellAliases = {
        shutdown = "systemctl poweroff";
        reboot = "systemctl reboot";
	build = "nixos-rebuild switch --flake .#tuna";
      };
    };
    starship = {
      enable = true;
      settings = {
      aws.symbol = "  ";
      buf.symbol = " ";
      c.symbol = " ";
      cmd_duration = {
        disabled = false;
        format = "took [$duration]($style)";
        min_time = 1;
      };
      conda.symbol = " ";
      crystal.symbol = " ";
      dart.symbol = " ";
      directory = {
        read_only = " 󰌾";
        style = "purple";
        truncate_to_repo = true;
        truncation_length = 0;
        truncation_symbol = "repo: ";
      };
      docker_context.symbol = " ";
      elixir.symbol = " ";
      elm.symbol = " ";
      fennel.symbol = " ";
      fossil_branch.symbol = " ";
      git_branch.symbol = " ";
      golang.symbol = " ";
      guix_shell.symbol = " ";
      haskell.symbol = " ";
      haxe.symbol = " ";
      hg_branch.symbol = " ";
      hostname = {
        disabled = false;
        format = "[$hostname]($style) in ";
        ssh_only = true;
        ssh_symbol = " ";
        style = "bold dimmed red";
      };
      java.symbol = " ";
      julia.symbol = " ";
      kotlin.symbol = " ";
      lua.symbol = " ";
      memory_usage.symbol = "󰍛 ";
      meson.symbol = "󰔷 ";
      nim.symbol = "󰆥 ";
      nix_shell.symbol = " ";
      nodejs.symbol = " ";
      ocaml.symbol = " ";
      package.symbol = "󰏗 ";
      perl.symbol = " ";
      php.symbol = " ";
      pijul_channel.symbol = " ";
      python.symbol = " ";
      rlang.symbol = "󰟔 ";
      ruby.symbol = " ";
      rust.symbol = " ";
      scala.symbol = " ";
      scan_timeout = 10;
      status = {
        disabled = false;
        map_symbol = true;
      };
      sudo.disabled = false;
      swift.symbol = " ";
      username = {
        format = " [$user]($style)@";
        show_always = false;
        style_root = "bold red";
        style_user = "bold red";
      };
      zig.symbol = " ";
      };
    };

    eza = {
      enable = true;
      enableFishIntegration = true;
      extraOptions = [
        "-al"
        "--icons"
      ];
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = ["--cmd cd"];
    };
    fzf = {
      enable = true;
      enableFishIntegration = true;
    };
    ripgrep = {
      enable = true;
    };
    nix-your-shell = {
      enable = true;
      enableFishIntegration = true;
    };
    kitty.enable = true;
    neovim.enable = true;
  };
}
