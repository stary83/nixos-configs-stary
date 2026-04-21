{ pkgs, ... }:

{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "~/.face";
        padding = {
	 left = 3;
        };
      };

      display = {
        size = {
          binaryPrefix = "si";
        };
        color = "blue";
        separator = ": ";
      };

      modules = [
        {
          type = "datetime";
          key = "Date";
          format = "{1}-{3}-{11}";
        }
        {
          type = "datetime";
          key = "Time";
          format = "{14}:{17}:{20}";
        }

        "os"
        "host"
        "kernel"
        "uptime"
        "packages"
        "shell"
        "terminal"
        "cpu"
        "gpu"
        "memory"
        "disk"
        "battery"
        "resolution"
        "de"
        "wm"
        "theme"
        "icons"
        "font"
        "locale"
        "player"
        "media"
      ];
    };
  };
}
