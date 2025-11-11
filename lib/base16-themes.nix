# Base16 color scheme definitions for themes from themes/ directory
# These are custom base16 schemes created from the theme files

{ pkgs, lib }:

let
  # Helper to create a base16 color scheme
  createBase16Scheme = {
    base00,  # Background
    base01,  # Lighter background
    base02,  # Selection background
    base03,  # Comments
    base04,  # Dark foreground
    base05,  # Default foreground
    base06,  # Light foreground
    base07,  # Light background
    base08,  # Red
    base09,  # Orange
    base0A,  # Yellow
    base0B,  # Green
    base0C,  # Cyan
    base0D,  # Blue
    base0E,  # Magenta
    base0F,  # Brown/Red
  }:
    {
      slug = "";
      name = "";
      # Colors with # prefix (for nix-colors compatibility)
      colors = {
        base00 = "#${base00}";
        base01 = "#${base01}";
        base02 = "#${base02}";
        base03 = "#${base03}";
        base04 = "#${base04}";
        base05 = "#${base05}";
        base06 = "#${base06}";
        base07 = "#${base07}";
        base08 = "#${base08}";
        base09 = "#${base09}";
        base0A = "#${base0A}";
        base0B = "#${base0B}";
        base0C = "#${base0C}";
        base0D = "#${base0D}";
        base0E = "#${base0E}";
        base0F = "#${base0F}";
      };
      # Palette without # prefix (for template usage)
      palette = {
        inherit base00 base01 base02 base03 base04 base05 base06 base07;
        inherit base08 base09 base0A base0B base0C base0D base0E base0F;
      };
    };

  # Mars theme - Red planet inspired
  marsScheme = createBase16Scheme {
    base00 = "1e0e0e";  # ALAC_BG
    base01 = "2d1e1e";  # ALAC_BLACK
    base02 = "2d1e1e";  # ALAC_BLACK
    base03 = "4d2e2e";  # ALAC_BRIGHT_BLACK
    base04 = "4d2e2e";  # ALAC_BRIGHT_BLACK
    base05 = "ddc5b5";  # ALAC_FG
    base06 = "ddc5b5";  # ALAC_WHITE
    base07 = "fde5d5";  # ALAC_BRIGHT_WHITE
    base08 = "dd6b4f";  # ALAC_RED
    base09 = "d4a373";  # ALAC_YELLOW
    base0A = "d4a373";  # ALAC_YELLOW
    base0B = "8b9064";  # ALAC_GREEN
    base0C = "b5a5a5";  # ALAC_CYAN
    base0D = "8b7b7b";  # ALAC_BLUE
    base0E = "c99590";  # ALAC_MAGENTA
    base0F = "dd6b4f";  # ALAC_RED
  };

  # DotRB theme - Ruby inspired
  dotrbScheme = createBase16Scheme {
    base00 = "2a1a1a";  # ALAC_BG
    base01 = "3a2a2a";  # ALAC_BLACK
    base02 = "3a2a2a";  # ALAC_BLACK
    base03 = "5a4a4a";  # ALAC_BRIGHT_BLACK
    base04 = "5a4a4a";  # ALAC_BRIGHT_BLACK
    base05 = "ddcccc";  # ALAC_FG
    base06 = "ddcccc";  # ALAC_WHITE
    base07 = "fdeeee";  # ALAC_BRIGHT_WHITE
    base08 = "cc342b";  # ALAC_RED
    base09 = "d4a373";  # ALAC_YELLOW
    base0A = "d4a373";  # ALAC_YELLOW
    base0B = "8f9668";  # ALAC_GREEN
    base0C = "b58bad";  # ALAC_CYAN
    base0D = "8b7b9b";  # ALAC_BLUE
    base0E = "cc6b8d";  # ALAC_MAGENTA
    base0F = "cc342b";  # ALAC_RED
  };

  # Vesper theme - Orange flavored
  vesperScheme = createBase16Scheme {
    base00 = "1e1e2e";  # ALAC_BG
    base01 = "323232";  # ALAC_BLACK
    base02 = "323232";  # ALAC_BLACK
    base03 = "565656";  # ALAC_BRIGHT_BLACK
    base04 = "565656";  # ALAC_BRIGHT_BLACK
    base05 = "c5c5c5";  # ALAC_FG
    base06 = "c5c5c5";  # ALAC_WHITE
    base07 = "e5e5e5";  # ALAC_BRIGHT_WHITE
    base08 = "ff6e6e";  # ALAC_RED
    base09 = "ffff8a";  # ALAC_YELLOW
    base0A = "ffff8a";  # ALAC_YELLOW
    base0B = "a0f9a0";  # ALAC_GREEN
    base0C = "8cffff";  # ALAC_CYAN
    base0D = "8cafff";  # ALAC_BLUE
    base0E = "ff88ff";  # ALAC_MAGENTA
    base0F = "ff6e6e";  # ALAC_RED
  };

  # Blue Ridge theme
  blueRidgeScheme = createBase16Scheme {
    base00 = "2c3640";  # ALAC_BG
    base01 = "2c3640";  # ALAC_BLACK
    base02 = "2c3640";  # ALAC_BLACK
    base03 = "4a5568";  # ALAC_BRIGHT_BLACK
    base04 = "4a5568";  # ALAC_BRIGHT_BLACK
    base05 = "c4b5a0";  # ALAC_FG
    base06 = "c4b5a0";  # ALAC_WHITE
    base07 = "ffffff";  # ALAC_BRIGHT_WHITE
    base08 = "cd9575";  # ALAC_RED
    base09 = "d4af37";  # ALAC_YELLOW
    base0A = "d4af37";  # ALAC_YELLOW
    base0B = "7ea67c";  # ALAC_GREEN
    base0C = "7ec8c8";  # ALAC_CYAN
    base0D = "6b8cae";  # ALAC_BLUE
    base0E = "9b8aa0";  # ALAC_MAGENTA
    base0F = "cd9575";  # ALAC_RED
  };

  # Create nix-colors compatible color schemes
  # We need to create these as proper colorScheme objects
  createColorScheme = scheme:
    let
      colors = scheme.colors;
      palette = scheme.palette;
    in
    {
      inherit colors palette;
      # Make it compatible with nix-colors colorScheme structure
      kind = "base16";
    };

  # Store Hyprland-specific colors for each theme
  hyprlandColors = {
    mars = {
      borderActive = "rgba(dd6b4fee) rgba(ff8b42ee) 45deg";
      borderInactive = "rgba(4d1a1aaa)";
      shadow = "rgba(1e0e0eee)";
    };
    dotrb = {
      borderActive = "rgba(cc342bee) rgba(ff6b9dee) 45deg";
      borderInactive = "rgba(3a2a2aaa)";
      shadow = "rgba(1a0a0eee)";
    };
    vesper = {
      borderActive = "rgba(ff8c42ee) rgba(ffad33ee) 45deg";
      borderInactive = "rgba(4a4a4aaa)";
      shadow = "rgba(1e1e1eee)";
    };
    "blue-ridge" = {
      borderActive = "rgba(6b8caeee) rgba(7ec8c8ee) 45deg";
      borderInactive = "rgba(2c3640aa)";
      shadow = "rgba(1a1a1eee)";
    };
  };
in
{
  schemes = {
    mars = createColorScheme marsScheme;
    dotrb = createColorScheme dotrbScheme;
    vesper = createColorScheme vesperScheme;
    "blue-ridge" = createColorScheme blueRidgeScheme;
  };
  inherit hyprlandColors;
}

