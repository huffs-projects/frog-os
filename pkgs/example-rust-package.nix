# Example: How to build a Rust package from source
# Copy this file and modify for your specific Rust program

{ pkgs }:

pkgs.rustPlatform.buildRustPackage {
  pname = "example-rust-program";
  version = "0.1.0";
  
  # Option 1: From Git repository
  src = pkgs.fetchFromGitHub {
    owner = "username";
    repo = "example-rust-program";
    rev = "v0.1.0";  # tag or commit hash
    sha256 = pkgs.lib.fakeSha256;  # Replace after first build
  };
  
  # Option 2: From a local directory (uncomment to use)
  # src = ../path/to/your/rust/project;
  
  # Cargo lock file hash (Nix will tell you the real hash on first build)
  cargoSha256 = pkgs.lib.fakeSha256;
  
  # Optional: Enable specific Cargo features
  # buildFeatures = [ "feature1" "feature2" ];
  
  # Optional: Native build inputs (for C dependencies like pkg-config)
  # nativeBuildInputs = with pkgs; [ pkg-config ];
  
  # Optional: Build inputs (runtime dependencies)
  # buildInputs = with pkgs; [ openssl ];
  
  # Optional: Environment variables during build
  # preBuild = ''
  #   export SOME_VAR=value
  # '';
  
  # Optional: Meta information
  meta = with pkgs.lib; {
    description = "Description of your Rust program";
    homepage = "https://github.com/username/example-rust-program";
    license = licenses.mit;  # or licenses.gpl3, etc.
    maintainers = [ ];
    platforms = platforms.linux;
  };
}

