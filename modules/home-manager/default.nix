inputs:
{
  config,
  pkgs,
  lib,
  ...
}:
let
  packages = import ../packages.nix {
    inherit pkgs lib;
    exclude_packages = config.frogOs.exclude_packages;
  };

  themes = import ../themes.nix;
  base16Themes = (import ../../lib/base16-themes.nix { inherit pkgs lib; });

  # Handle theme selection - either predefined or generated
  selectedTheme =
    if (config.frogOs.theme == "generated_light" || config.frogOs.theme == "generated_dark") then
      null
    else if themes ? ${config.frogOs.theme} then
      themes.${config.frogOs.theme}
    else
      null;
  
  # Check if this is a custom base16 theme (from themes/ directory)
  isCustomBase16Theme = selectedTheme != null && selectedTheme ? base16-theme && base16Themes.schemes ? ${selectedTheme.base16-theme};
  customBase16Scheme = if isCustomBase16Theme then
    base16Themes.schemes.${selectedTheme.base16-theme}
  else
    null;

  # Generate color scheme from wallpaper for generated themes
  # Use wallpaperPath if provided, otherwise use theme_overrides.wallpaper_path
  wallpaperForGeneration = 
    if config.frogOs.wallpaperPath != null then
      config.frogOs.wallpaperPath
    else
      config.frogOs.theme_overrides.wallpaper_path;
  
  generatedColorScheme =
    if (config.frogOs.theme == "generated_light" || config.frogOs.theme == "generated_dark") then
      if wallpaperForGeneration != null then
        (inputs.nix-colors.lib.contrib { inherit pkgs; }).colorSchemeFromPicture {
          path = wallpaperForGeneration;
          variant = if config.frogOs.theme == "generated_light" then "light" else "dark";
        }
      else
        throw "wallpaperPath or theme_overrides.wallpaper_path must be set for generated themes"
    else
      null;
in
{
  imports = [
    (import ./hyprland.nix inputs)
    (import ./hyprlock.nix inputs)
    (import ./hyprpaper.nix)
    (import ./hypridle.nix)
    (import ./alacritty.nix)
    (import ./btop.nix)
    (import ./mpd.nix)
    (import ./yazi.nix)
    (import ./direnv.nix)
    (import ./git.nix)
    (import ./mako.nix)
    (import ./rust.nix)
    (import ./starship.nix)
    (import ./waybar.nix inputs)
    (import ./wofi.nix)
    (import ./zoxide.nix)
    (import ./zsh.nix)
  ];

  home.file = {
    ".local/share/frog-os/bin" = {
      source = ../../bin;
      recursive = true;
    };
  };
  home.packages = packages.homePackages;

  # Store Hyprland-specific colors for custom base16 themes
  hyprlandThemeColors = if isCustomBase16Theme && base16Themes.hyprlandColors ? ${config.frogOs.theme} then
    base16Themes.hyprlandColors.${config.frogOs.theme}
  else
    null;
  
  colorScheme =
    if (config.frogOs.theme == "generated_light" || config.frogOs.theme == "generated_dark") then
      generatedColorScheme
    else if customBase16Scheme != null then
      # Use our custom base16 scheme
      {
        palette = customBase16Scheme.palette;
        colors = customBase16Scheme.colors;
        # Store Hyprland colors for use in looknfeel.nix
        _hyprlandColors = hyprlandThemeColors;
      }
    else if selectedTheme != null && selectedTheme ? base16-theme then
      # Use standard nix-colors base16 scheme
      if inputs.nix-colors.colorSchemes ? ${selectedTheme.base16-theme} then
        inputs.nix-colors.colorSchemes.${selectedTheme.base16-theme}
      else
        throw "Base16 theme '${selectedTheme.base16-theme}' not found in nix-colors. Check themes.nix for '${config.frogOs.theme}'"
    else
      throw "Theme '${config.frogOs.theme}' not found in themes.nix or missing base16-theme";

  gtk = {
    enable = true;
    theme = {
      name = if config.frogOs.theme == "generated_light" then "Adwaita" else "Adwaita:dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  # TODO: Add an actual nvim config
  programs.neovim.enable = true;
}
