{ config, pkgs, ... }:

{
  imports = [
    ../../common/configuration.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "lenovo";

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;

  programs.noctalia.enable = true;
  services.displayManager.noctalia-greeter.enable = true;
  programs.hyprland.enable = true;
  programs.hyprland.withUWSM = true;

  security.pam.services.greetd.enableGnomeKeyring = true;

  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "hyprland" ];
  };

  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
  };

  systemd.user.settings.Manager = {
    DefaultLimitNOFILE = 524288;
  };
}
