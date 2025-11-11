{
  config,
  pkgs,
  ...
}:
let
  cfg = config.frogOs;
  palette = config.colorScheme.palette;
  
  # All themes now use base16 palette, so we can use it directly
  alacColors = {
    primary = {
      background = "#${palette.base00}";
      foreground = "#${palette.base05}";
    };
    cursor = {
      text = "#${palette.base00}";
      cursor = "#${palette.base05}";
    };
    selection = {
      text = "#${palette.base00}";
      background = "#${palette.base02}";
    };
    normal = {
      black = "#${palette.base00}";
      red = "#${palette.base08}";
      green = "#${palette.base0B}";
      yellow = "#${palette.base0A}";
      blue = "#${palette.base0D}";
      magenta = "#${palette.base0E}";
      cyan = "#${palette.base0C}";
      white = "#${palette.base05}";
    };
    bright = {
      black = "#${palette.base03}";
      red = "#${palette.base08}";
      green = "#${palette.base0B}";
      yellow = "#${palette.base0A}";
      blue = "#${palette.base0D}";
      magenta = "#${palette.base0E}";
      cyan = "#${palette.base0C}";
      white = "#${palette.base07}";
    };
  };
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      # Window settings
      window = {
        padding = {
          x = 14;
          y = 14;
        };
        opacity = 0.95;
        decorations = "none";
      };

      font = {
        normal = {
          family = cfg.primary_font;
        };
        size = 12;
      };

      # Colors - using base16 color scheme
      colors = alacColors;

      # Key bindings
      key_bindings = [
        {
          key = "K";
          mods = "Control";
          action = "ClearHistory";
        }
      ];
    };
  };
}

