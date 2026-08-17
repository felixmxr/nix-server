{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mergerfs
    hdparm
  ];

  fileSystems."/mnt/data/data1" = {
    device = "/dev/disk/by-label/data1";
    fsType = "btrfs";
    options = [ "subvol=data" ];
  };
  fileSystems."/mnt/data/data2" = {
    device = "/dev/disk/by-label/data2";
    fsType = "btrfs";
    options = [ "subvol=data" ];
  };

  fileSystems."/mnt/content/data1" = {
    device = "/dev/disk/by-label/data1";
    fsType = "btrfs";
    options = [ "subvol=/content" ];
  };
  fileSystems."/mnt/content/data2" = {
    device = "/dev/disk/by-label/data2";
    fsType = "btrfs";
    options = [ "subvol=/content" ];
  };

  fileSystems."/mnt/parity/parity1" = {
    device = "/dev/disk/by-label/parity1";
    fsType = "ext4";
  };

  fileSystems."/mnt/cache" = {
    device = "/dev/disk/by-label/nvmecache";
    fsType = "btrfs";
  };

  fileSystems."/mnt/oldcache" = {
    device = "/dev/disk/by-label/cache";
    fsType = "btrfs";
  };
  fileSystems."/mnt/olddrive" = {
    device = "/dev/disk/by-uuid/f1b4ee78-b80f-48b3-8d78-d9605e7d88c3";
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
    ];
  };

  fileSystems."/mnt/storage" = {
    device = "/mnt/cache:/mnt/pool";
    fsType = "fuse.mergerfs";

    options = [
      "category.create=ff"
      "cache.files=partial"
      "dropcacheonclose=true"
      "defaults"
      "allow_other"
      "moveonenospc=1"
      "use_ino"
      "minfreespace=250G"
    ];
  };

  systemd.services.hdd-spindown = {
    description = "Configure HDD spindown";
    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      ${pkgs.hdparm}/bin/hdparm -S 60 /dev/sdb
      ${pkgs.hdparm}/bin/hdparm -S 60 /dev/sdc
      ${pkgs.hdparm}/bin/hdparm -S 60 /dev/sdd
    '';
  };

  services.smartd = {
    enable = true;
    extraOptions = [ "-n" "standby" ];
  };

}
