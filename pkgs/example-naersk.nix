# Example: Building a Rust package with Naersk (Recommended)
# Naersk automatically handles Cargo.lock and dependencies - much easier!

{ pkgs, naersk-lib }:

naersk-lib.buildPackage {
  pname = "example-rust-program";
  version = "0.1.0";
  
  # Option 1: From Git repository
  root = pkgs.fetchFromGitHub {
    owner = "username";
    repo = "example-rust-program";
    rev = "v0.1.0";  # tag or commit hash
    sha256 = pkgs.lib.fakeSha256;  # Replace after first build
  };
  
  # Option 2: From a local directory (uncomment to use)
  # root = ../path/to/your/rust/project;
  
  # Optional: Native build inputs (for C dependencies like pkg-config)
  # nativeBuildInputs = with pkgs; [ pkg-config ];
  
  # Optional: Build inputs (runtime dependencies)
  # buildInputs = with pkgs; [ openssl ];
  
  # Optional: Enable specific Cargo features
  # cargoBuildOptions = x: x ++ [ "--features" "feature1,feature2" ];
  
  # Optional: Override the default build command
  # buildPhase = ''
  #   cargo build --release --bin my-binary
  # '';
  
  # Optional: Override the install phase
  # installPhase = ''
  #   install -Dm755 target/release/my-binary $out/bin/my-binary
  # '';
  
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

