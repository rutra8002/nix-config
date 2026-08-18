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
    userName = "ruternix";
    userEmail = "arturkummer08@gmail.com";
  };
  
  programs.vscode = {
    enable = true;
  };  

  # Rust development: RustRover IDE + the actual toolchain it drives.
  # rustc/cargo/rust-analyzer/etc are separate from the IDE itself.
  home.packages = with pkgs; [
    jetbrains.rust-rover
    rustc
    cargo
    rust-analyzer
    rustfmt
    clippy
    gcc
    obs-studio
    discord
  ];

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

  home.file.".config/hypr/hyprland.lua".source = ./hyprland.lua;
}
