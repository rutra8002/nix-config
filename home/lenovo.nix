{ pkgs, inputs, ... }:

{
  imports = [ ./common.nix ];

  home.file.".config/hypr/hyprland.lua".source = ../hosts/lenovo/hyprland.lua;

  home.packages = with pkgs; [
    prismlauncher
    inputs.self.packages.${pkgs.system}.gowin-eda-education
  ];

  systemd.user.services.hyprpolkitagent = {
    Unit.Description = "Hyprland Polkit Authentication Agent";
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

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
