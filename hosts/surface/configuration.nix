{ config, pkgs, lib, ... }:

{
  imports = [
    ../../common/configuration.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "surface";

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  hardware.microsoft-surface.kernelVersion = "stable";

  hardware.sensor.iio.enable = true;

  services.thermald.enable = true;
}