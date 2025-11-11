{
  config,
  pkgs,
  ...
}:
let
  cfg = config.frogOs;
  selected_wallpaper_path = (import ../../lib/selected-wallpaper.nix config).wallpaper_path;
  
  # If a custom wallpaperPath is provided, copy it to home directory
  # Otherwise use the default wallpapers directory
  wallpaperFiles = 
    if cfg.wallpaperPath != null then
{
        "Pictures/Wallpapers/${builtins.baseNameOf (toString cfg.wallpaperPath)}" = {
          source = cfg.wallpaperPath;
        };
      }
    else
      {
    "Pictures/Wallpapers" = {
      source = ../../config/themes/wallpapers;
      recursive = true;
    };
  };
in
{
  home.file = wallpaperFiles;
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        selected_wallpaper_path
      ];
      wallpaper = [
        ",${selected_wallpaper_path}"
      ];
    };
  };
}
