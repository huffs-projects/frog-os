{
  pkgs,
  lib,
  exclude_packages ? [ ],
}:
let
  # Essential Hyprland packages - cannot be excluded
  hyprlandPackages = with pkgs; [
    hyprpicker
    hyprsunset
    brightnessctl
    playerctl
    gnome-themes-extra
    pavucontrol
    # Screenshot tools
    grim
    slurp
    swappy
    wl-clipboard
    cliphist
    # Power menu
    wlogout
  ];

  # Essential system packages - cannot be excluded
  systemPackages = with pkgs; [
    git
    vim
    libnotify
    alejandra
    blueberry
    clipse
    fzf
    zoxide
    ripgrep
    eza
    fd
    curl
    unzip
    wget
    gnumake
    bat
    # Bluetooth
    bluez
    # Fonts
    (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    dejavu_fonts
  ];

  # Discretionary packages - can be excluded by user
  discretionaryPackages =
    with pkgs;
    [
      # Terminal & Shell
      alacritty
      yazi

      # TUIs
      lazygit
      lazydocker
      btop
      powertop
      fastfetch
      keepmenu
      tui-journal
      calcurse
      impala

      # GUIs
      firefox
      thunderbird
      obsidian
      signal-desktop

      # Security
      keepassxc

      # Media & Viewers
      zathura
      mpv
      imv

      # Music
      mpd
      ncmpcpp

      # Productivity
      nano
      wordgrinder

      # Development tools
      github-desktop
      gh

      # File sharing
      localsend

      # Containers
      docker-compose
      ffmpeg

      # Fun & Terminal Tools
      pokete
      balatro
      pipes

      # Gaming
      retroarch
      steam
    ]
    ++ lib.optionals (pkgs.system == "x86_64-linux") [
      spotify
    ];

  # Only allow excluding discretionary packages to prevent breaking the system
  filteredDiscretionaryPackages = lib.lists.subtractLists exclude_packages discretionaryPackages;
  allSystemPackages = hyprlandPackages ++ systemPackages ++ filteredDiscretionaryPackages;
in
{
  # Regular packages
  systemPackages = allSystemPackages;

  homePackages = with pkgs; [
    # Custom Rust packages from flake can be added here:
    # Example: self.packages.${pkgs.system}.my-rust-program
    # To access self, you'll need to pass it through from the module that imports this
  ];
}
