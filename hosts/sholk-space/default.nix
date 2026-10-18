{ config, pkgs, rust-overlay, ... }: {
  nixpkgs.overlays = [ (import rust-overlay) ];
  imports = [
    ../../modules/common.nix
    ../../modules/users.nix
    ../../modules/nix.nix
    ../../modules/desktop.nix
    ../../modules/services.nix
    ./disks.nix
    ./nvidia.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "sholk-space";
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 53317 44609 23000 27036 27037 ];
    allowedUDPPorts = [ 53317 23000 24454 10400 10401 27031 27036 ];
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  powerManagement.enable = true;

  # Zapret — только для хоста
  systemd.services.zapret = {
    description = "Zapret for Discord and YouTube";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      WorkingDirectory = "/opt/zapret";
      ExecStart = "/run/current-system/sw/bin/bash /opt/zapret/service.sh daemon";
      ExecStop = "/run/current-system/sw/bin/bash /opt/zapret/service.sh kill";
      Restart = "on-failure";
      RestartSec = 10;
      User = "root";
      Environment = "PATH=/run/current-system/sw/bin:/usr/bin:/bin";
    };
  };
}
