{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/base.nix
    ../../modules/storage.nix
    ../../modules/snapraid.nix

    #../../modules/services/plex.nix
    #../../modules/services/immich.nix
    #../../modules/services/nextcloud.nix
  ];

  networking.hostName = "homeserver";

  system.stateVersion = "26.05";
}
