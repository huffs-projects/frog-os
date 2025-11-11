{
  config,
  pkgs,
  ...
}:
let
  cfg = config.frogOs;
in
{
  wayland.windowManager.hyprland.settings = {
    bind = [
      # Window Management
      "SUPER, space, exec, wofi --show drun --sort-order=alphabetical"
      "SUPER, W, killactive,"
      "SUPER, ESCAPE, exec, wlogout"
      "SUPER, L, exec, hyprlock"
      "CTRL ALT, Delete, killactive,"
      "SUPER, T, togglefloating,"
      "SUPER, F, fullscreen,"
      "SUPER ALT, F, resizeactive, exact 100% 0"

      # Workspaces
      "SUPER, 1, workspace, 1"
      "SUPER, 2, workspace, 2"
      "SUPER, 3, workspace, 3"
      "SUPER, 4, workspace, 4"
      "SUPER, Tab, workspace, +1"
      "SUPER SHIFT, Tab, workspace, -1"
      "SUPER CTRL, Tab, workspace, previous"
      "SHIFT SUPER, 1, movetoworkspace, 1"
      "SHIFT SUPER, 2, movetoworkspace, 2"
      "SHIFT SUPER, 3, movetoworkspace, 3"
      "SHIFT SUPER, 4, movetoworkspace, 4"
      "SUPER, S, togglespecialworkspace, magic"
      "SUPER ALT, S, movetoworkspace, special:magic"

      # Window Navigation
      "SUPER, equal, resizeactive, -100 0"
      "SUPER, minus, resizeactive, 100 0"
      "SUPER SHIFT, equal, resizeactive, 0 100"
      "SUPER SHIFT, minus, resizeactive, 0 -100"

      # Window Grouping
      "SUPER, G, togglegroup,"
      "SUPER ALT, G, moveoutofgroup,"
      "SUPER ALT, Tab, changegroupactive,"
      "SUPER ALT, 1, moveintogroup, 1"
      "SUPER ALT, 2, moveintogroup, 2"
      "SUPER ALT, 3, moveintogroup, 3"
      "SUPER ALT, 4, moveintogroup, 4"
      "SUPER ALT, left, moveintogroup, l"
      "SUPER ALT, right, moveintogroup, r"
      "SUPER ALT, up, moveintogroup, u"
      "SUPER ALT, down, moveintogroup, d"

      # Application Shortcuts
      "SUPER, return, exec, $terminal"
      "SUPER SHIFT, B, exec, $browser"
      "SUPER SHIFT ALT, B, exec, $browser --private-window"
      "SUPER SHIFT, F, exec, $fileManager"
      "SUPER SHIFT, T, exec, $terminal -e btop"
      "SUPER SHIFT, M, exec, $music"
      "SUPER SHIFT ALT, M, exec, $terminal -e ncmpcpp"
      "SUPER SHIFT, slash, exec, $passwordManager"
      "SUPER SHIFT, N, exec, $terminal -e nvim"
      "SUPER SHIFT, C, exec, $terminal -e calcurse"
      "SUPER SHIFT, E, exec, thunderbird"
      "SUPER SHIFT, G, exec, $messenger"
      "SUPER SHIFT, D, exec, $terminal -e lazydocker"
      "SUPER SHIFT, W, exec, $terminal -e impala"
      "SUPER SHIFT, O, exec, obsidian"
      "SUPER SHIFT, A, exec, $browser --new-window https://chatgpt.com"
      "SUPER SHIFT ALT, A, exec, $browser --new-window https://gemini.google.com"
      "CTRL SUPER, S, exec, localsend"

      # Screenshots & Recording
      ", PRINT, exec, grim -g \"$(slurp)\" - | swappy -f -"
      "SHIFT, PRINT, exec, grim -g \"$(slurp)\" - | wl-copy"
      "ALT, PRINT, exec, grim -g \"$(slurp)\" - | wl-copy"
      "SUPER, PRINT, exec, hyprpicker -a"

      # Clipse
      "CTRL SUPER, V, exec, alacritty --class clipse -e clipse"
    ];

    bindm = [
      # Move/resize windows with mainMod + LMB/RMB and dragging
      "SUPER, mouse:272, movewindow"
      "SUPER, mouse:273, resizewindow"
    ];

    bindel = [
      # Laptop multimedia keys for volume and LCD brightness
      ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
      ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
    ];

    bindl = [
      # Requires playerctl
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
    ];
  };
}
