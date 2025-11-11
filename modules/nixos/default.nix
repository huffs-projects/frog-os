inputs:
{
  config,
  pkgs,
  ...
}:
let
  cfg = config.frogOs;
  packages = import ../packages.nix { inherit pkgs; };
in
{
  imports = [
    (import ./hyprland.nix inputs)
    (import ./system.nix)
    (import ./containers.nix)
  ];
}
