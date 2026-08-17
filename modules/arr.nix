{ config, pkgs, ... }:

{
  services.radarr = {
    enable = true;
    openFirewall = true; # or false + manual firewall rule if you don't want it exposed on LAN
    dataDir = "/mnt/cache/lib/radarr";
  };

  services.qbittorrent = {
    enable = true;
    openFirewall = true;
    webuiPort = 8080;
    # torrentingPort = 6881; # default, adjust if needed
  };

  users.groups.media = {};

  users.users.radarr.extraGroups = [ "media" ];
  users.users.qbittorrent.extraGroups = [ "media" ];  # if using the native module

}
