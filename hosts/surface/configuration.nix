{ config, pkgs, lib, ... }:

{
  imports = [
    ../../common/configuration.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "surface";

  boot.kernelParams = [
    "intel_pstate=hwp_dynamic_boost=0"
    "pcie_aspm=force"
  ];

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  hardware.microsoft-surface.kernelVersion = "stable";

  hardware.sensor.iio.enable = true;
  
  services.power-profiles-daemon.enable = true;
  services.thermald.enable = true;

  services.iptsd = {
    enable = true;
    config = {
      Touch.DisableOnPalm = true;
      Touch.DisableOnStylus = true;
    };
  };
}