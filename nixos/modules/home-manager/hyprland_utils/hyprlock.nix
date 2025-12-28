{ pkgs, config, ... }:
{
  programs.hyprlock = {
    enable = true;
    settings.background.blur_passes = 3;
    settings.background.blur_size = 2;
    settings = {
      source = "colors.conf"; 
      label = [
        {
          monitor = "";
          text = "$TIME";
          # text_align = "center";
          font_family = "JetBrainsMono Nerd Font";
          # font_color = "#${config.lib.stylix.colors.base00}";
          # font_color = "${config.stylix.colors.base00}";
          font_size = 80;
          # font_color = "rgb(${config.lib.stylix.colors.base05})";
          position = "0,0";
          halign = "center";
          valign = "top";
          # accent = "#${colors.base0D}";
          # colors = config.lib.stylix.colors;
          # fg = "#${colors.base05}";
          # bg = "#${colors.base00}";
        }
        {
          monitor = "";
          text = "Uhhhhhhh <br/>";
          # text_align = "center";
          font_family = "JetBrainsMono Nerd Font";
          # font_color = "#${config.lib.stylix.colors.base05}";
          # font_color = config.lib.stylix.colors.base00;
          # font_color = "rgb(${config.lib.stylix.colors.base05})";
          font_size = 36;
          position = "0,50";
          halign = "center";
          valign = "bottom";
        }
      ];
      
      image = {
	path = "~/.face";
	size = 250;
	position = "0, 200";
	halign = "center";
	valign = "center";
      };

      general = {
        disable_loading_bar = true;
        grace = 0;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = {
        path = "${config.stylix.image}";
      };

      input-field = {
        # size = "180, 40";
        position = "0, 0";
        # monitor = "";
        dots_center = true;
        fade_on_empty = true;
        # font_color = "rgba(202, 211, 245, 1.0)";
        # inner_color = "rgba(91, 96, 120, 0.5)";
        #outer_color = "rgba(24, 25, 38, 0.5)";
        outline_thickness = 2;
        # shadow_passes = 1;
      };

    };
  };
  home.file.".face".source = ../../../resources/.face;
}
