# Example: Building a C/C++ package
# Copy this file and modify for your specific C/C++ program

{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "example-c-program";
  version = "0.1.0";
  
  # Option 1: From Git repository
  src = pkgs.fetchFromGitHub {
    owner = "username";
    repo = "example-c-program";
    rev = "v0.1.0";  # tag or commit hash
    sha256 = pkgs.lib.fakeSha256;  # Replace after first build
  };
  
  # Option 2: From a local directory (uncomment to use)
  # src = ../path/to/your/c/project;
  
  # Build inputs (runtime dependencies)
  buildInputs = with pkgs; [
    # Add your dependencies here, e.g.:
    # openssl
    # zlib
    # libcurl
    # SDL2
  ];
  
  # Native build inputs (tools needed only during build)
  nativeBuildInputs = with pkgs; [
    pkg-config  # If the project uses pkg-config
    # cmake      # If using CMake
    # meson      # If using Meson
    # ninja      # If using Ninja
    # autoconf   # If using autotools
    # automake   # If using autotools
  ];
  
  # Optional: Pre-configure phase
  # preConfigure = ''
  #   ./autogen.sh  # For autotools projects
  # '';
  
  # Optional: Configure phase (for autotools)
  # configurePhase = ''
  #   ./configure --prefix=$out
  # '';
  
  # Optional: Build phase (if not using standard make)
  # buildPhase = ''
  #   make
  #   # Or for simple programs:
  #   # $CC -o myprogram main.c
  # '';
  
  # Optional: Install phase (if not using standard make install)
  # installPhase = ''
  #   mkdir -p $out/bin
  #   cp myprogram $out/bin/
  # '';
  
  # Optional: Environment variables during build
  # preBuild = ''
  #   export CFLAGS="-O2"
  #   export CXXFLAGS="-O2"
  # '';
  
  # Optional: Meta information
  meta = with pkgs.lib; {
    description = "Description of your C/C++ program";
    homepage = "https://github.com/username/example-c-program";
    license = licenses.mit;  # or licenses.gpl3, etc.
    maintainers = [ ];
    platforms = platforms.linux;
  };
}

