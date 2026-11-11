{ pkgs, inputs, ... }:

{
  imports = [ ./common.nix ];

  home.file.".config/hypr/hyprland.lua".source = ../hosts/lenovo/hyprland.lua;

  home.packages = with pkgs; [
    prismlauncher
  ];

  programs.kitty = {
    enable = true;
    settings.remember_window_size = "no";
  };

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
  };
}
