# Example: Building a CMake-based C/C++ package

{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "example-cmake-program";
  version = "0.1.0";
  
  src = pkgs.fetchFromGitHub {
    owner = "username";
    repo = "example-cmake-program";
    rev = "v0.1.0";
    sha256 = pkgs.lib.fakeSha256;  # Replace after first build
  };
  
  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config  # If needed
  ];
  
  buildInputs = with pkgs; [
    # Your dependencies
    # openssl
    # zlib
  ];
  
  # Optional: CMake configure flags
  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DBUILD_SHARED_LIBS=ON"
    # "-DENABLE_FEATURE=ON"
  ];
  
  # Optional: Meta information
  meta = with pkgs.lib; {
    description = "Description of your CMake program";
    homepage = "https://github.com/username/example-cmake-program";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}

# Alternative: Using cmake.buildPackage helper
# { pkgs }:
# 
# pkgs.cmake.buildPackage {
#   pname = "example-cmake-program";
#   version = "0.1.0";
#   
#   src = pkgs.fetchFromGitHub {
#     owner = "username";
#     repo = "example-cmake-program";
#     rev = "v0.1.0";
#     sha256 = pkgs.lib.fakeSha256;
#   };
#   
#   buildInputs = with pkgs; [
#     # Dependencies
#   ];
# }

