{ pkgs, inputs, ... }:

{
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  home.username = "ruter";
  home.homeDirectory = "/home/ruter";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings.user.name = "ruternix";
    settings.user.email = "arturkummer08@gmail.com";
  };
  
  programs.vscode = {
    enable = true;
  };  

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  gtk = {
    enable = true;

    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
  };

  home.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
    HYPRCURSOR_SIZE = "24";
  };

  home.packages = with pkgs; [
    jetbrains.rust-rover
    rustc
    cargo
    rust-analyzer
    rustfmt
    clippy
    gcc
    obs-studio
    vesktop
    cutechess
    yazi
    fastfetch
    termius
    obsidian
    jetbrains.pycharm
    jetbrains.webstorm
    python3
    python3Packages.pip
    python3Packages.virtualenv
    nautilus
    nodejs_22
    gimp
    godot_4
    (heroic.override {
      extraPkgs = pkgs': with pkgs'; [ gamescope gamemode ];
    })
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "org.gnome.Nautilus.desktop";
    };
  };

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;

    policies = {
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "normal_installed";
        };
      };
    };
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";

    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };

  services.ssh-agent.enable = true;
}
