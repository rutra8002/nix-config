{ config, pkgs, lib, ... }:

{
  imports = [
    ../../common/configuration.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "surface";

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  hardware.microsoft-surface.ipts.enable = true;
  hardware.microsoft-surface.kernelVersion = "stable";
  hardware.microsoft-surface.surface-control.enable = true;
  users.users.ruter.extraGroups = [ "surface-control" ];

  hardware.sensor.iio.enable = true;

  services.thermald.enable = true;
}