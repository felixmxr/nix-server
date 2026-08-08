{ pkgs, inputs, ... }:

let
  snapraid-btrfs = pkgs.writeShellApplication {
    name = "snapraid-btrfs";

    runtimeInputs = with pkgs; [
      snapraid
      snapper
      bash
      gawk
      gnused
      gnugrep
      coreutils
    ];

    text = builtins.readFile "${inputs.snapraid-btrfs}/snapraid-btrfs";
  };
in
{
  environment.systemPackages = [
    snapraid-btrfs
  ];

 services.snapraid = {
    enable = true;

    dataDisks = {
      d1 = "/mnt/data/data1";
      d2 = "/mnt/data/data2";
    };

    parityFiles = [
      "/mnt/parity/parity1/snapraid.parity"
    ];

    contentFiles = [
      "/mnt/content/data1/snapraid.content"
      "/mnt/content/data2/snapraid.content"
    ];

    exclude = [
      "*.unrecoverable"
      "/lost+found/"
      "/.Trash-*/"
      "/tmp/"
      "/Downloads/*"
    ];
  };

  services.snapper.configs = {
    data1 = {
      SUBVOLUME = "/mnt/data/data1";
      FSTYPE = "btrfs";

      TIMELINE_CREATE = false;
      TIMELINE_CLEANUP = false;
    };

    data2 = {
      SUBVOLUME = "/mnt/data/data2";
      FSTYPE = "btrfs";

      TIMELINE_CREATE = false;
      TIMELINE_CLEANUP = false;
    };
  };

}
