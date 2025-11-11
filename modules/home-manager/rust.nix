{
  config,
  pkgs,
  ...
}:
{
  programs.rust = {
    enable = true;
    # Install the default stable toolchain
    defaultToolchain = {
      channel = "stable";
      components = [ "rustc" "cargo" "rustfmt" "clippy" "rust-analyzer" ];
    };
  };
}

