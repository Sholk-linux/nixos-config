{ config, pkgs, rust-overlay, ... }: {
  nixpkgs.overlays = [ (import rust-overlay) ];
  imports = [
    ../../modules/common.nix
    ../../modules/users.nix
    ../../modules/nix.nix
    ../../modules/desktop.nix
    ../../modules/services.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "vm";
  networking.networkmanager.enable = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  services.xserver.videoDrivers = [ "modesetting" ];

  powerManagement.enable = false;
}
