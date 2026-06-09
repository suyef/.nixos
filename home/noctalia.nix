{ inputs, ... }:
{
  home-manager.users.suyef = {
    imports = [
    inputs.noctalia.homeModules.default
    ];

    programs.noctalia = {
      enable = true;

      settings = {
	theme = {
	  mode = "dark";
	  source = "builtin";
	};
      };
    };
  };
}
