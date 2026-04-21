{ ... }: {
  wayland.windowManager.hyprland.settings = {
    exec = [
    ];

    general = {
      gaps_in = 3;
      gaps_out = 6;
      border_size = 0;
      layout = "dwindle";
    };
    decoration = {
      rounding = 5;
      active_opacity = 1;
      inactive_opacity = 1;
      dim_inactive = true;
      dim_strength = 0.1;
      blur = {
        enabled = true;
        size = 6;
        passes = 2;
        new_optimizations = true;
        ignore_opacity = true; 
      };
      shadow = { 
        enabled = true;
        range = 5;
        render_power = 3;
	offset = "0, 0";
	color = "rgba(17, 17, 27, 1.0)";
	color_inactive = "rgba(17, 17, 27, 0.0)";
      };

    };
    dwindle = {
      pseudotile = true;
      preserve_split = true;
      force_split = 2;
      default_split_ratio = 1.2;
    };
  };
}

