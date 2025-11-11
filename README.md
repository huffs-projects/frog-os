# Frog OS

Frog OS is an opinionated NixOS flake that provides a complete, production-ready desktop environment built on Hyprland. It offers a modern, themeable, and highly customizable setup for development and daily computing.

Inspired by [DHH's Omarchy](https://github.com/basecamp/omarchy), Frog OS brings a similar philosophy to NixOS with a focus on developer productivity, beautiful aesthetics, and reproducible configurations.

## What's Included

### Core Desktop Environment

- **Hyprland** - Modern Wayland compositor with theme-based window borders and animations
- **Waybar** - Status bar with theme-based styling
- **Wofi** - Application launcher and menu
- **Hyprlock** - Screen locker with FROG OS branding
- **Mako** - Notification daemon

### Terminal & Shell

- **Alacritty** - GPU-accelerated terminal emulator with theme-based colors
- **Yazi** - Terminal file manager with preview support
- **Starship** - Fast, customizable prompt with theme-based styling
- **Zsh** - Shell with useful defaults
- **Zoxide** - Smart directory navigation

### Applications

- **Firefox** - Web browser
- **Thunderbird** - Email client
- **Obsidian** - Note-taking and knowledge management
- **Signal Desktop** - Secure messaging
- **KeePassXC** - Password manager
- **MPD + ncmpcpp** - Music player daemon and TUI client
- **MPV** - Media player
- **Zathura** - PDF viewer

### Development Tools

- **Rust Toolchain** - Pre-configured Rust development environment (rustc, cargo, rustfmt, clippy, rust-analyzer)
- **Git** - Version control with sensible defaults
- **GitHub CLI** - Command-line interface for GitHub
- **Docker Compose** - Container orchestration
- **Custom Package Building** - Support for building Rust and C/C++ packages from source

### Utilities

- **btop** - System monitor
- **lazygit** - Git TUI
- **lazydocker** - Docker TUI
- **ripgrep** - Fast text search
- **fd** - Fast file finder
- **eza** - Modern ls replacement
- **bat** - Cat with syntax highlighting

## Quick Start

To get started you'll first need to set up a fresh [NixOS](https://nixos.org/) install. Just download and create a bootable USB and you should be good to go.

Once ready, add this flake to your system configuration, you'll also need [home-manager](https://github.com/nix-community/home-manager) as well:

(You can find my personal nix setup [here](https://github.com/henrysipp/nix-setup) too if you need a reference.)
```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    frog-os = {
        url = "github:henrysipp/frog-os";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.home-manager.follows = "home-manager";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, frog-os, home-manager, ... }: {
    nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
      modules = [
        frog-os.nixosModules.default
        home-manager.nixosModules.home-manager #Add this import
        {
          # Configure Frog OS
          frogOs = {
            full_name = "Your Name";
            email_address = "your.email@example.com";
            theme = "tokyo-night";
          };
          
          home-manager = {
            users.your-username = {
              imports = [ frog-os.homeManagerModules.default ]; # And this one
            };
          };
        }
      ];
    };
  };
}
```

## Configuration Options

Frog OS provides a comprehensive set of configuration options to customize your desktop environment. All themes, applications, and system settings are centrally managed through the `frogOs` configuration block.

Refer to [the root configuration](https://github.com/henrysipp/frog-os/blob/main/config.nix) file for detailed information on all available options, including:

- User information (name, email)
- Theme selection and wallpaper customization
- Display settings (monitors, scale factor)
- Quick application keybindings
- Package exclusions

### Themes

Frog OS includes several predefined themes:

- `tokyo-night` (default)
- `kanagawa`
- `everforest`
- `catppuccin`
- `nord`
- `gruvbox`
- `gruvbox-light`

Custom Base16 themes:

- `mars` - Red planet inspired dark theme
- `dotrb` - Ruby inspired dark theme
- `vesper` - Orange flavored dark theme
- `blue-ridge` - Blue Ridge dark theme

You can also generate themes from wallpaper images using:

- `generated_light` - generates a light color scheme from wallpaper
- `generated_dark` - generates a dark color scheme from wallpaper

#### Custom Wallpapers

Any theme can be customized with a custom wallpaper using the `wallpaperPath` option:

```nix
{
  frogOs = {
    theme = "tokyo-night"; # or any other predefined theme
    wallpaperPath = ./path/to/your/wallpaper.png;
  };
}
```

For generated themes, you can use either `wallpaperPath` or `theme_overrides.wallpaper_path`:

```nix
{
  frogOs = {
    theme = "generated_dark"; # or "generated_light"
    wallpaperPath = ./path/to/your/wallpaper.png;
    # OR
    # theme_overrides = {
    #   wallpaper_path = ./path/to/your/wallpaper.png;
    # };
  };
}
```

Generated themes automatically extract colors from the wallpaper and create a matching color scheme for all Frog OS applications (terminal, editor, launcher, etc.).

### Custom Packages

This flake supports building custom Rust and C/C++ packages from source. See [`pkgs/README.md`](./pkgs/README.md) for detailed instructions on:

- Building Rust packages with **Naersk** (recommended) or `buildRustPackage`
- Building C/C++ packages with CMake, Meson, Autotools, or manual builds
- Adding custom packages to your configuration

The flake includes **Naersk** for easy Rust package building and a complete Rust toolchain for development. See [`pkgs/README.md`](./pkgs/README.md) for comprehensive examples and documentation.

## Features

- **Unified Theming** - All applications automatically use your selected theme colors
- **Wallpaper-Based Theme Generation** - Automatically extract color schemes from your wallpapers
- **Reproducible Builds** - Everything is defined in Nix for complete reproducibility
- **Custom Package Support** - Build and include Rust and C/C++ packages from source
- **Developer-Focused** - Pre-configured tools for modern development workflows
- **Highly Customizable** - Easy to extend and modify to fit your needs

## License

This project is licensed under the GNU General Public License version 2.0 (GPL-2.0).
