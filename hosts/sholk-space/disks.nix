{ ... }: {
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9717-1D6F";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/4c096fe3-2a6d-4bb1-9a02-955d856b51ee";
    fsType = "btrfs";
    options = [ "subvol=@root" "compress=zstd" "noatime" ];
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/4c096fe3-2a6d-4bb1-9a02-955d856b51ee";
    fsType = "btrfs";
    options = [ "subvol=@home" "compress=zstd" "noatime" ];
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/4c096fe3-2a6d-4bb1-9a02-955d856b51ee";
    fsType = "btrfs";
    options = [ "subvol=@nix" "compress=zstd" "noatime" ];
  };
  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/4c096fe3-2a6d-4bb1-9a02-955d856b51ee";
    fsType = "btrfs";
    options = [ "subvol=@swap" "noatime" ];
  };
  swapDevices = [
    { device = "/swap/swapfile"; size = 32 * 1024; }
  ];
}
