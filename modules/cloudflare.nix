{ config, pkgs, ... }:

{
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    virtualHosts."_" = {
      forceSSL = false;
      enableACME = false;
      root = "/var/www/html";
      locations."/" = { index = "index.html"; };
      listen = [
        { addr = "0.0.0.0"; port = 80; }
      ];
    };
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.cloudflared = {
    enable = true;
    tunnels = {
      "18fa7566-5e9a-41ca-9f6a-0f509c34c24d" = {
        credentialsFile = "/home/felix/.cloudflared/18fa7566-5e9a-41ca-9f6a-0f509c34c24d.json";
        default = "http_status:404"; # fallback for unmatched routes
        ingress = {
          "plex.ethren.eu" = "http://localhost:32400";
          "vaultwarden.ethren.eu" = "http://localhost:8285";
        };
      };
    };
  };
}
