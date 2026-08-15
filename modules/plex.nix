{ config, pkgs, ... }:

{
  services.plex = {
    enable = true;
    openFirewall = true;  # opens 32400 (and related discovery ports)
    user = "plex";        # default
    group = "plex";        # default
    dataDir = "/mnt/cache/lib/plex"; # default location for Plex's config/db
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver   # for newer Intel iGPUs (Broadwell+)
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  # give the plex user access to the render group
  users.users.plex.extraGroups = [ "render" "video" ];

  networking.nftables.enable = true;
  networking.firewall.enable = true;

  networking.firewall.extraInputRules = ''
    tcp dport 7539 accept
  '';

  networking.nftables.tables.plex-redirect = {
    family = "ip";
    content = ''
      chain prerouting {
        type nat hook prerouting priority -100;
        tcp dport 7539 redirect to :32400
      }
    '';
  };

}
