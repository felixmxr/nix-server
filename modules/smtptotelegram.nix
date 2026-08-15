{ config, pkgs, ... }:
{
  virtualisation.docker.enable = true;

  virtualisation.oci-containers.containers.smtptotelegram = {
    image = "kostyaesmukov/smtp_to_telegram:latest";
    autoStart = true;

    environment = {
        ST_SMTP_LISTEN = "0.0.0.0:2525";
        ST_TELEGRAM_MESSAGE_TEMPLATE="From: {from}\\nTo: {to}\\nSubject: {subject}\\n\\n{body}\\n\\n{attachments_details}";
      };

    environmentFiles = [
      "/mnt/cache/lib/secrets/smtptotelegram.env"
    ];

    # Only expose on localhost / internal interface — this service has
    ports = [
      "127.0.0.1:25:2525"
    ];

  };
}
