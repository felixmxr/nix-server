{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/base.nix
    ../../modules/storage.nix
    ../../modules/snapraid.nix
    ../../modules/plex.nix
    ../../modules/cloudflare.nix

    #../../modules/services/immich.nix
    #../../modules/services/nextcloud.nix
  ];

  networking.hostName = "nix-server";

  system.stateVersion = "26.05";
}
