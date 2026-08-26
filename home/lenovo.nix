{ pkgs, inputs, ... }:

{
  imports = [ ./common.nix ];

  home.file.".config/hypr/hyprland.lua".source = ../hosts/lenovo/hyprland.lua;
}
