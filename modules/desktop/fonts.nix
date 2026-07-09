{pkgs, ...}: {
  fonts.packages = with pkgs; [

    (pkgs.iosevka.override {
      set = "custom";
      privateBuildPlan = {
	family = "Iosevka Custom";
	spacing = "term";
	serifs = "sans";
	noCvSs = true;
	exportGlyphNames = false;

	variants = {
	  inherits = "ss15";
	  design = {
	    six = "closed-contour";
	    nine = "closed-contour";
	    zero = "long-dotted";
	    l = "serifed";
	    t = "flat-hook";
	    v = "straight-motion-serifed";
	    partial-derivative = "closed-contour";
	    asterisk = "hex-high";
	  };
	};
	ligations = {
	  inherits = "dlig";
	};
	weights = {
	  Regular = { shape = 400; menu = 400; css = 400; };
	  Bold = { shape = 700; menu = 700; css = 700; };
	};
	widths = {
	  Condensed = { shape = 500; menu = 3; css = "condensed"; };
	  Normal = { shape = 600; menu = 5; css = "normal"; };
	};
	slopes = {
	  Upright = { angle = 0; shape = "upright"; menu = "upright"; css = "normal";};
	  Italic = { angle = 9.4; shape = "italic"; menu = "italic"; css = "italic"; };
	};
      };
    })

    noto-fonts-color-emoji
    tamzen
    cantarell-fonts
    nerd-fonts.fira-code
  ];
}
