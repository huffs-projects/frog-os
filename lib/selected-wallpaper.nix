config:
let
  cfg = config.frogOs;
  wallpapers = {
    "tokyo-night" = [
      "1-Pawel-Czerwinski-Abstract-Purple-Blue.jpg"
    ];
    "kanagawa" = [
      "kanagawa-1.png"
    ];
    "everforest" = [
      "1-everforest.jpg"
    ];
    "nord" = [
      "nord-1.png"
    ];
    "gruvbox" = [
      "gruvbox-1.jpg"
    ];
    "gruvbox-light" = [
      "gruvbox-1.jpg"
    ];
  };

  # Handle wallpaper path - prioritize wallpaperPath, then generated themes, then defaults
  # For custom wallpaperPath, use the filename in home directory
  # For generated themes, use the provided path (will be in nix store or home)
  # For default themes, use the filename in home directory
  wallpaper_path =
    if cfg.wallpaperPath != null then
      # Custom wallpaper will be copied to Pictures/Wallpapers/
      let
        filename = builtins.baseNameOf (toString cfg.wallpaperPath);
      in
      "$HOME/Pictures/Wallpapers/${filename}"
    else if (cfg.theme == "generated_light" || cfg.theme == "generated_dark") then
      if cfg.theme_overrides.wallpaper_path != null then
        toString cfg.theme_overrides.wallpaper_path
      else
        throw "wallpaperPath or theme_overrides.wallpaper_path must be set for generated themes"
    else if wallpapers ? ${cfg.theme} then
      let
        selected_wallpaper = builtins.elemAt (wallpapers.${cfg.theme}) 0;
      in
      "$HOME/Pictures/Wallpapers/${selected_wallpaper}"
    else
      # Fallback for themes without predefined wallpapers (like catppuccin)
      # Use the first available wallpaper as fallback
      let
        fallback_wallpaper = builtins.elemAt (wallpapers.tokyo-night) 0;
      in
      "$HOME/Pictures/Wallpapers/${fallback_wallpaper}";
in
{
  inherit wallpaper_path;
}
