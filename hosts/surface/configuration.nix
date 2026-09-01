{ config, pkgs, lib, ... }:

{
  imports = [
    ../../common/configuration.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "surface";

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  microsoft-surface.ipts.enable = true;
  microsoft-surface.kernelVersion = "stable";
  microsoft-surface.surface-control.enable = true;
  users.users.ruter.extraGroups = [ "surface-control" ];

  hardware.sensor.iio.enable = true;

  services.thermald.enable = true;
}