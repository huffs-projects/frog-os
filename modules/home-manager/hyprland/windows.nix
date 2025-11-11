{
  config,
  pkgs,
  ...
}:
{
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      "suppressevent maximize, class:.*"

      # Force firefox into a tile
      "tile, class:^(firefox)$"

      # Settings management
      "float, class:^(org.pulseaudio.pavucontrol|blueberry.py)$"

      # Float Steam, fullscreen RetroArch
      "float, class:^(steam)$"
      "fullscreen, class:^(com.libretro.RetroArch)$"

      # Just dash of transparency
      "opacity 0.97 0.9, class:.*"
      # Normal firefox Youtube tabs
      "opacity 1 1, class:^(firefox)$, title:.*Youtube.*"
      "opacity 1 0.97, class:^(firefox)$"
      "opacity 1 1, class:^(zoom|vlc|org.kde.kdenlive|com.obsproject.Studio)$"
      "opacity 1 1, class:^(com.libretro.RetroArch|steam)$"

      # Fix some dragging issues with XWayland
      "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

      # Float in the middle for clipse clipboard manager
      "float, class:(clipse)"
      "size 622 652, class:(clipse)"
      "stayfocused, class:(clipse)"
    ];

    layerrule = [
      # Proper background blur for wofi
      "blur,wofi"
      "blur,waybar"
    ];
  };
}
