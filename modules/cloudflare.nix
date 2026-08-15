{ config, pkgs, ... }:

{
  services.cloudflared = {
    enable = true;
    tunnels = {
      "nixos-server" = {
        credentialsFile = "/home/felix/.cloudflared/18fa7566-5e9a-41ca-9f6a-0f509c34c24d.json";
        default = "http_status:404"; # fallback for unmatched routes
        ingress = {
          "plex.ethren.eu" = "https://localhost:32400";
        };
      };
    };
  };
}
