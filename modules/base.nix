{ pkgs, ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  time.timeZone = "Europe/Vienna";

  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    htop
    btop
    tmux
    curl
    wget
    smartmontools
    tree
  ];

  programs.bash.loginShellInit = ''
    if [ "$USER" = "felix" ]; then
      cd /home/felix/nix-server
    fi
  '';

  programs.bash.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake ~/nix-server#nix-server";
    rebuild-test = "sudo nixos-rebuild test --flake ~/nix-server#nix-server";
  };

  services.smartd.enable = true;
  
  users.groups.storage = {};
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."felix" = {
    isNormalUser = true;
    description = "Felix Meixner";
    extraGroups = [ 
      "networkmanager"
      "wheel"
      "storage"];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAk0nxGBv2QCIhb5UbxeX/UMNG2Vrobpm1oJwe/yypwkCBCzBmU1jXsNLA08+pGAbS/v838nr8dwaKu91eCE7ZQSxEQmLI2sNETzhFuj2wjUIAcxraswoeNJesJURjXHB0n9o7T73vb43xnbWon/hOjBrde69jeT7EpkntjwuaOYhuK5Mg05cBb7xmO8sHcrOPHuhQGbsSc00QRJVJyDUAxgfm+0jDVXPDWR4UNaTPXQkQbyu4DO/SHFhzwD6qBeR+B86I3rTlf0nGxnv9cE8R8HNRI+Q/75GmziuQyRGwjJVHmd7phkbq7jqCdGNVtaRgKF71FW9slp8vHFs3qks3yQ==" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };


  security.sudo.extraRules = [
    {
      users = [ "felix" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

}
