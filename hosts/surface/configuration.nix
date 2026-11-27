{ config, pkgs, lib, ... }:

{
  imports = [
    ../../common/configuration.nix
    ./hardware-configuration.nix
  ];

  nix.settings = {
    extra-substituters = [ "http://141.144.237.90:8080" ];
    extra-trusted-public-keys = [
      (lib.removeSuffix "\n" (builtins.readFile ../../cache-pub.pem))
    ];
  };

  networking.hostName = "surface";

  virtualisation.virtualbox.host.enable = true;

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

  boot.kernelPatches = [{
    name = "trim-surface-pro-7";
    patch = null;
    structuredExtraConfig =
      let
        # set to "no" if the option exists, don't error if it doesn't
        off = lib.mkForce (lib.kernel.option lib.kernel.no);
        disable = names: lib.genAttrs names (_: off);
      in
      disable [
        # GPUs: keep i915 only
        "DRM_NOUVEAU" "DRM_AMDGPU" "DRM_RADEON" "DRM_XE" "DRM_GMA500"
        "DRM_VMWGFX" "DRM_QXL" "DRM_AST" "DRM_MGAG200" "DRM_VIRTIO_GPU"
        "DRM_BOCHS" "DRM_CIRRUS_QEMU"

        # Other CPU vendors
        "KVM_AMD" "CPU_SUP_AMD" "CPU_SUP_HYGON" "CPU_SUP_CENTAUR" "CPU_SUP_ZHAOXIN"

        # Server/legacy buses and protocols
        "INFINIBAND" "FIREWIRE" "PCCARD" "CAN" "NFC" "HAMRADIO" "ATM" "IEEE802154"

        # Filesystems: only rarely used legacy and cluster ones go.
        # Kept: ext4, btrfs, xfs, f2fs, vfat, exfat, ntfs, hfsplus, iso9660,
        # udf, squashfs, overlay, fuse, nfs, cifs.
        "JFS_FS" "HFS_FS" "UFS_FS" "QNX4FS_FS" "QNX6FS_FS" "MINIX_FS" "NILFS2_FS"
        "OCFS2_FS" "GFS2_FS" "ORANGEFS_FS" "AFFS_FS" "CEPH_FS" "AFS_FS" "CODA_FS"
        "OMFS_FS" "HPFS_FS" "SYSV_FS" "EFS_FS" "ADFS_FS" "BEFS_FS" "BFS_FS"
        "VXFS_FS" "ROMFS_FS"

        # Wi-Fi vendors other than Intel (iwlwifi is what the Pro 7 has)
        "WLAN_VENDOR_ATH" "WLAN_VENDOR_ATMEL" "WLAN_VENDOR_BROADCOM"
        "WLAN_VENDOR_CISCO" "WLAN_VENDOR_INTERSIL" "WLAN_VENDOR_MARVELL"
        "WLAN_VENDOR_MEDIATEK" "WLAN_VENDOR_MICROCHIP" "WLAN_VENDOR_PURELIFI"
        "WLAN_VENDOR_QUANTENNA" "WLAN_VENDOR_RALINK" "WLAN_VENDOR_REALTEK"
        "WLAN_VENDOR_RSI" "WLAN_VENDOR_SILABS" "WLAN_VENDOR_ST"
        "WLAN_VENDOR_TI" "WLAN_VENDOR_ZYDAS"

        # Serial Bluetooth transports (the Pro 7 uses USB via btusb)
        "BT_HCIUART" "BT_HCIBCM203X" "BT_HCIBPA10X" "BT_HCIBFUSB"
      ]
      // disable (map (v: "NET_VENDOR_${v}") [
        # PCI Ethernet cards (USB Ethernet and USB tethering are separate and stay)
        "3COM" "ADAPTEC" "AGERE" "ALACRITECH" "ALTEON" "AMAZON" "AMD" "AQUANTIA"
        "ARC" "ASIX" "ATHEROS" "BROADCOM" "BROCADE" "CADENCE" "CAVIUM" "CHELSIO"
        "CISCO" "CORTINA" "DAVICOM" "DEC" "DLINK" "EMULEX" "ENGLEDER" "EZCHIP"
        "FUNGIBLE" "GOOGLE" "HUAWEI" "MARVELL" "MELLANOX" "MICREL" "MICROCHIP"
        "MICROSEMI" "MYRI" "NATSEMI" "NETERION" "NETRONOME" "NI" "NVIDIA" "OKI"
        "PACKET_ENGINES" "PENSANDO" "QLOGIC" "QUALCOMM" "RDC" "REALTEK" "RENESAS"
        "ROCKER" "SAMSUNG" "SEEQ" "SILAN" "SIS" "SMSC" "SOCIONEXT" "SOLARFLARE"
        "STMICRO" "SUN" "SYNOPSYS" "TEHUTI" "TI" "VERTEXCOM" "VIA" "WIZNET"
        "XILINX"
      ]);
  }];
}