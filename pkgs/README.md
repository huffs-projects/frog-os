# Custom Packages

This directory contains custom package definitions for programs not available in nixpkgs.

## Adding a Rust Package

### Method 1: Using Naersk (Recommended - Easiest)

Naersk automatically handles Cargo.lock, dependencies, and build configuration. This is the simplest method!

Create a file `pkgs/my-rust-program.nix`:

```nix
{ pkgs, naersk-lib }:

naersk-lib.buildPackage {
  pname = "my-rust-program";
  version = "0.1.0";
  
  # From Git repository
  root = pkgs.fetchFromGitHub {
    owner = "username";
    repo = "my-rust-program";
    rev = "v0.1.0";  # tag or commit hash
    sha256 = pkgs.lib.fakeSha256;  # Replace after first build
  };
  
  # Or from a local directory
  # root = ../path/to/your/rust/project;
  
  # Optional: Native build inputs (for C dependencies)
  # nativeBuildInputs = with pkgs; [ pkg-config ];
  
  # Optional: Build inputs (runtime dependencies)
  # buildInputs = with pkgs; [ openssl ];
  
  # Optional: Enable Cargo features
  # cargoBuildOptions = x: x ++ [ "--features" "feature1,feature2" ];
  
  # Optional: Meta information
  meta = with pkgs.lib; {
    description = "Description of your program";
    homepage = "https://github.com/username/my-rust-program";
    license = licenses.mit;
    maintainers = [ ];
  };
}
```

Then in `flake.nix`, add it to packages:

```nix
let
  naersk-lib = naersk.lib.${system}.override {
    cargo = pkgs.cargo;
    rustc = pkgs.rustc;
  };
in
{
  packages.${system} = {
    my-rust-program = pkgs.callPackage ./pkgs/my-rust-program.nix {
      inherit naersk-lib;
    };
  };
}
```

**Benefits of Naersk:**
- ✅ Automatically reads `Cargo.lock`
- ✅ No need to manually specify `cargoSha256`
- ✅ Handles dependencies automatically
- ✅ Works with workspaces
- ✅ Much simpler than `buildRustPackage`

### Method 2: Using buildRustPackage (More Manual)

Create a file `pkgs/my-rust-program.nix`:

```nix
{ pkgs }:

pkgs.rustPlatform.buildRustPackage {
  pname = "my-rust-program";
  version = "0.1.0";
  
  # From Git repository
  src = pkgs.fetchFromGitHub {
    owner = "username";
    repo = "my-rust-program";
    rev = "v0.1.0";  # tag or commit hash
    sha256 = pkgs.lib.fakeSha256;  # Replace after first build
  };
  
  # Or from a local directory
  # src = ./path/to/your/rust/project;
  
  cargoSha256 = pkgs.lib.fakeSha256;  # Replace after first build
  
  # Optional: Build features
  # buildFeatures = [ "feature1" "feature2" ];
  
  # Optional: Native build inputs (for C dependencies)
  # nativeBuildInputs = with pkgs; [ pkg-config ];
  
  # Optional: Build inputs (runtime dependencies)
  # buildInputs = with pkgs; [ openssl ];
  
  # Optional: Meta information
  meta = with pkgs.lib; {
    description = "Description of your program";
    homepage = "https://github.com/username/my-rust-program";
    license = licenses.mit;
    maintainers = [ ];
  };
}
```

Then in `flake.nix`, add it to packages:

```nix
packages.${system} = {
  my-rust-program = pkgs.callPackage ./pkgs/my-rust-program.nix { };
};
```

### Method 3: Using Crane (For Complex Projects)

For more complex Rust projects with workspaces or special build requirements:

1. Add crane to flake inputs:
```nix
inputs = {
  crane = {
    url = "github:ipetkov/crane";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};
```

2. Create package definition using crane in `pkgs/my-rust-program.nix`:
```nix
{ pkgs, crane }:

crane.lib.${pkgs.system}.buildPackage {
  src = pkgs.fetchFromGitHub {
    owner = "username";
    repo = "my-rust-program";
    rev = "v0.1.0";
    sha256 = pkgs.lib.fakeSha256;
  };
  
  # Crane automatically handles Cargo.lock, etc.
}
```

### Building and Getting Hashes

1. First build will fail with fake hashes
2. Nix will show you the correct hashes
3. Replace `fakeSha256` with the actual hashes
4. Rebuild - it should work now

### Adding to Your Configuration

After defining the package in `flake.nix`, you need to make it available to your modules.

**Option 1: Pass self through modules (Recommended)**

Update `modules/nixos/default.nix` to pass `self`:

```nix
inputs:
{
  config,
  pkgs,
  ...
}:
let
  cfg = config.frogOs;
  self = inputs.self or null;  # Access self from inputs
  packages = import ../packages.nix { 
    inherit pkgs; 
    self = self;  # Pass self to packages.nix
  };
in
{
  # ...
}
```

Then update `modules/packages.nix` to accept and use `self`:

```nix
{
  pkgs,
  lib,
  self ? null,  # Add self parameter
  exclude_packages ? [ ],
}:
let
  # Custom packages from flake
  customPackages = if self != null then [
    self.packages.${pkgs.system}.my-rust-program
  ] else [];
in
{
  systemPackages = allSystemPackages ++ customPackages;
  # or add to discretionaryPackages
}
```

**Option 2: Add directly in system.nix**

In `modules/nixos/system.nix`, you can access custom packages if you pass `self`:

```nix
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.frogOs;
  self = config._module.args.self or null;  # If passed through
  packages = import ../packages.nix {
    inherit pkgs lib;
    exclude_packages = cfg.exclude_packages;
  };
in
{
  environment.systemPackages = packages.systemPackages 
    ++ lib.optionals (self != null) [
      self.packages.${pkgs.system}.my-rust-program
    ];
}
```

**Option 3: Add to homePackages**

For Home Manager packages, update `modules/home-manager/default.nix`:

```nix
let
  self = inputs.self or null;
  packages = import ../packages.nix {
    inherit pkgs lib;
    exclude_packages = config.frogOs.exclude_packages;
    self = self;
  };
in
{
  home.packages = packages.homePackages
    ++ lib.optionals (self != null) [
      self.packages.${pkgs.system}.my-rust-program
    ];
}
```

## Example: Building from Local Source

If you have a Rust project locally:

```nix
{ pkgs, naersk-lib }:

naersk-lib.buildPackage {
  pname = "my-local-program";
  version = "0.1.0";
  root = ../path/to/your/rust/project;  # Relative to this file
}
```

Or with buildRustPackage:

```nix
{ pkgs }:

pkgs.rustPlatform.buildRustPackage {
  pname = "my-local-program";
  version = "0.1.0";
  src = ../path/to/your/rust/project;  # Relative to this file
  cargoSha256 = pkgs.lib.fakeSha256;
}
```

## Adding a C or C++ Package

For C and C++ programs, Nix uses `stdenv.mkDerivation` or build system-specific helpers. There isn't a tool like naersk that auto-detects everything, but the patterns are straightforward.

### Method 1: Using stdenv.mkDerivation (Manual Build)

For simple Makefile-based projects:

```nix
{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "my-c-program";
  version = "0.1.0";
  
  # From Git repository
  src = pkgs.fetchFromGitHub {
    owner = "username";
    repo = "my-c-program";
    rev = "v0.1.0";
    sha256 = pkgs.lib.fakeSha256;  # Replace after first build
  };
  
  # Or from a local directory
  # src = ../path/to/your/c/project;
  
  # Build inputs (dependencies)
  buildInputs = with pkgs; [
    # Add your dependencies here, e.g.:
    # openssl
    # zlib
    # libcurl
  ];
  
  # Native build inputs (tools needed only during build)
  nativeBuildInputs = with pkgs; [
    pkg-config  # If the project uses pkg-config
    # gnumake    # Usually included in stdenv
  ];
  
  # Optional: Configure phase (for autotools)
  # configurePhase = ''
  #   ./configure --prefix=$out
  # '';
  
  # Optional: Build phase (if not using standard make)
  # buildPhase = ''
  #   make
  # '';
  
  # Optional: Install phase (if not using standard make install)
  # installPhase = ''
  #   mkdir -p $out/bin
  #   cp my-program $out/bin/
  # '';
  
  # Optional: Meta information
  meta = with pkgs.lib; {
    description = "Description of your program";
    homepage = "https://github.com/username/my-c-program";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
```

### Method 2: Using CMake (For CMake Projects)

For CMake-based projects:

```nix
{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "my-cmake-program";
  version = "0.1.0";
  
  src = pkgs.fetchFromGitHub {
    owner = "username";
    repo = "my-cmake-program";
    rev = "v0.1.0";
    sha256 = pkgs.lib.fakeSha256;
  };
  
  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
  ];
  
  buildInputs = with pkgs; [
    # Your dependencies
    # openssl
  ];
  
  # Optional: CMake configure flags
  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DBUILD_SHARED_LIBS=ON"
  ];
}
```

Or use the `cmake` helper:

```nix
{ pkgs }:

pkgs.cmake.buildPackage {
  pname = "my-cmake-program";
  version = "0.1.0";
  
  src = pkgs.fetchFromGitHub {
    owner = "username";
    repo = "my-cmake-program";
    rev = "v0.1.0";
    sha256 = pkgs.lib.fakeSha256;
  };
  
  buildInputs = with pkgs; [
    # Dependencies
  ];
}
```

### Method 3: Using Meson (For Meson Projects)

For Meson build system:

```nix
{ pkgs }:

pkgs.meson.buildPackage {
  pname = "my-meson-program";
  version = "0.1.0";
  
  src = pkgs.fetchFromGitHub {
    owner = "username";
    repo = "my-meson-program";
    rev = "v0.1.0";
    sha256 = pkgs.lib.fakeSha256;
  };
  
  buildInputs = with pkgs; [
    # Dependencies
  ];
  
  # Optional: Meson options
  mesonFlags = [
    "-Dbuildtype=release"
  ];
}
```

### Method 4: Using Autotools (For configure/make Projects)

For autotools (autoconf/automake):

```nix
{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "my-autotools-program";
  version = "0.1.0";
  
  src = pkgs.fetchFromGitHub {
    owner = "username";
    repo = "my-autotools-program";
    rev = "v0.1.0";
    sha256 = pkgs.lib.fakeSha256;
  };
  
  nativeBuildInputs = with pkgs; [
    autoconf
    automake
    libtool
    pkg-config
  ];
  
  buildInputs = with pkgs; [
    # Dependencies
  ];
  
  # Autotools projects usually need this
  preConfigure = ''
    ./autogen.sh  # If needed
  '';
}
```

### Adding C/C++ Packages to flake.nix

```nix
packages.${system} = {
  my-c-program = pkgs.callPackage ./pkgs/my-c-program.nix { };
  my-cmake-program = pkgs.callPackage ./pkgs/my-cmake-program.nix { };
};
```

### Common C/C++ Dependencies

Here are some common dependencies you might need:

```nix
buildInputs = with pkgs; [
  # System libraries
  glib
  zlib
  openssl
  libcurl
  
  # Graphics
  SDL2
  SDL2_image
  cairo
  pango
  
  # Audio
  alsa-lib
  pulseaudio
  
  # Database
  sqlite
  postgresql
  
  # JSON/XML
  json-c
  libxml2
  
  # Networking
  libuv
  libevent
];
```

### Tips for C/C++ Packages

1. **Finding dependencies**: Check the project's README, `configure.ac`, `CMakeLists.txt`, or `meson.build` for dependencies
2. **pkg-config**: Many projects use `pkg-config` - add it to `nativeBuildInputs`
3. **Header-only libraries**: Some C++ libraries are header-only and don't need to be in `buildInputs`
4. **Static vs Dynamic**: By default, Nix builds dynamic libraries. For static, you may need to override the build
5. **Cross-compilation**: Nix handles cross-compilation automatically if you set the system

### Example: Simple C Program

```nix
{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "simple-c-program";
  version = "1.0.0";
  
  src = ../path/to/simple-c-program;
  
  buildPhase = ''
    $CC -o myprogram main.c
  '';
  
  installPhase = ''
    mkdir -p $out/bin
    cp myprogram $out/bin/
  '';
}
```

