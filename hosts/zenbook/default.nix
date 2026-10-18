{ config, pkgs, lib, rust-overlay, ... }: {
  imports = [
    ../../modules/common.nix
    ../../modules/users.nix
    ../../modules/nix.nix
    ../../modules/desktop.nix
    ../../modules/services.nix
    ./hardware.nix
  ];

  nixpkgs.overlays = [ rust-overlay.overlays.default ];

  networking.hostName = "zenbook";
  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  powerManagement.enable = true;
}
