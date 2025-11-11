{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.frogOs;
in
{
  imports = [
    ./autostart.nix
    ./bindings.nix
    ./envs.nix
    ./input.nix
    ./looknfeel.nix
    ./windows.nix
  ];
  wayland.windowManager.hyprland.settings = {
    # Default applications
    "$terminal" = lib.mkDefault "alacritty";
    "$fileManager" = lib.mkDefault "yazi";
    "$browser" = lib.mkDefault "firefox";
    "$music" = lib.mkDefault "spotify";
    "$passwordManager" = lib.mkDefault "keepassxc";
    "$messenger" = lib.mkDefault "signal-desktop";
    "$webapp" = lib.mkDefault "$browser --new-window";

    monitor = cfg.monitors;
  };
}
