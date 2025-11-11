{
  description = "Frog OS - Base configuration flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    nix-colors.url = "github:misterio77/nix-colors";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      hyprland,
      nix-colors,
      home-manager,
      naersk,
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      # Initialize naersk with the Rust toolchain
      naersk-lib = naersk.lib.${system}.override {
        cargo = pkgs.cargo;
        rustc = pkgs.rustc;
      };
    in
    {
      formatter.${system} = pkgs.nixfmt-tree;

      # Custom packages built from source
      packages.${system} = {
        # Example: Building a Rust package with naersk (Recommended)
        # Uncomment and modify for your Rust program:
        #
        # my-rust-program = naersk-lib.buildPackage {
        #   pname = "my-rust-program";
        #   version = "0.1.0";
        #   root = pkgs.fetchFromGitHub {
        #     owner = "username";
        #     repo = "my-rust-program";
        #     rev = "v0.1.0";
        #     sha256 = pkgs.lib.fakeSha256;  # Replace after first build
        #   };
        #   # naersk automatically handles Cargo.lock and dependencies!
        # };
        #
        # Or using buildRustPackage (more manual):
        #
        # my-rust-program = pkgs.rustPlatform.buildRustPackage {
        #   pname = "my-rust-program";
        #   version = "0.1.0";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "username";
        #     repo = "my-rust-program";
        #     rev = "v0.1.0";
        #     sha256 = pkgs.lib.fakeSha256;
        #   };
        #   cargoSha256 = pkgs.lib.fakeSha256;
        # };
      };

      nixosModules = {
        default =
          {
            config,
            lib,
            pkgs,
            ...
          }:
          {
            imports = [
              (import ./modules/nixos/default.nix inputs)
            ];

            options.frogOs = (import ./config.nix lib).frogOsOptions;
            config = {
              nixpkgs.config.allowUnfree = true;
            };
          };
      };

      homeManagerModules = {
        default =
          {
            config,
            lib,
            pkgs,
            osConfig ? { },
            ...
          }:
          {
            imports = [
              nix-colors.homeManagerModules.default
              (import ./modules/home-manager/default.nix inputs)
            ];
            options.frogOs = (import ./config.nix lib).frogOsOptions;
            config = lib.mkIf (osConfig ? frogOs) {
              frogOs = osConfig.frogOs;
            };
          };
      };
    };
}
