{ config, pkgs, ... }:

{
  services.vaultwarden = {
    enable = true;
    dbBackend = "sqlite"; # fine for personal/small-team use; postgresql if you want more robustness
    config = {
      DOMAIN = "https://vaultwarden.ethren.eu";
      DATA_FOLDER = "/mnt/cache/lib/vaultwarden";
      SIGNUPS_ALLOWED = false; # flip to true briefly to create your account, then disable
      SIGNUPS_VERIFY = true;          # if you ever re-enable, require email verify
      INVITATIONS_ALLOWED = true;
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8285;
      ROCKET_LOG = "critical";

      # Email (optional but recommended for invitations/2FA recovery)
      SMTP_HOST = "127.0.0.1";
      SMTP_PORT = 25;
      SMTP_SECURITY = "off";       # no STARTTLS, no implicit TLS
      SMTP_FROM = "vaultwarden@ethren.eu";
      SMTP_FROM_NAME = "Vaultwarden";
    
     # Disable things you don't need
      WEBSOCKET_ENABLED = true; # needed for live sync
      SENDS_ALLOWED = true;
      EMERGENCY_ACCESS_ALLOWED = true;
    };

    # Keep secrets (admin token, SMTP password) out of the Nix store
    #environmentFile = "/run/secrets/vaultwarden.env";
  };

  systemd.services.vaultwarden.serviceConfig = {
    ReadWritePaths = [ "/mnt/cache/lib/vaultwarden" ];
  };

  services.fail2ban = {
    enable = true;
    jails.vaultwarden = ''
      filter = vaultwarden
      action = iptables-allports
      logpath = /var/log/vaultwarden.log  # or journald backend
      maxretry = 5
      findtime = 300
      bantime = 3600
    '';
  };

  networking.firewall.allowedTCPPorts = [ 8285 ];
}
