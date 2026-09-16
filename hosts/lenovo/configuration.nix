{ config, pkgs, ... }:

{
  imports = [
    ../../common/configuration.nix
    ./hardware-configuration.nix
  ];

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/f2112494-a3e8-49d1-b8b5-32114736ee9b";
    fsType = "ext4";
    options = [ "defaults" "nofail" ];
  };

  networking.hostName = "lenovo";

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.powerManagement.enable = true;
  hardware.graphics.enable = true;

  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  boot.kernelParams = [
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "nvidia_drm.modeset=1"
    "nvidia_drm.fbdev=1"
  ];

  programs.noctalia.enable = true;
  services.displayManager.noctalia-greeter.enable = true;
  programs.hyprland.enable = true;
  programs.hyprland.withUWSM = true;

  environment.systemPackages = with pkgs; [
    kitty
  ];

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
