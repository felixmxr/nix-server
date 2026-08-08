{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mergerfs
  ];

  fileSystems."/mnt/data/data1" = {
    device = "/dev/disk/by-label/data1";
    fsType = "btrfs";
    options = [
      "subvol=data"
    ];
  };

  fileSystems."/mnt/data/data2" = {
    device = "/dev/disk/by-label/data2";
    fsType = "btrfs";
    options = [
      "subvol=data"
    ];
  };

  fileSystems."/mnt/content/data1" = {
    device = "/dev/disk/by-label/data1";
    fsType = "btrfs";
    options = [
      "subvol=/content"
    ];
  };

  fileSystems."/mnt/content/data2" = {
    device = "/dev/disk/by-label/data2";
    fsType = "btrfs";
    options = [
      "subvol=/content"
    ];
  };

  fileSystems."/mnt/parity/parity1" = {
    device = "/dev/disk/by-label/parity1";
    fsType = "ext4";
  };

  fileSystems."/mnt/pool" = {
    device = "/mnt/data/data1:/mnt/data/data2";
    fsType = "fuse.mergerfs";

    options = [
      "cache.files=off"
      "dropcacheonclose=true"
      "defaults"
      "allow_other"
      "moveonenospc=1"
      "use_ino"
      "minfreespace=50G"
      "uid=1000"
      "gid=1000"
    ];
  };
}
