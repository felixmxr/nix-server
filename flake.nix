{
  description = "Home server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    snapraid-btrfs = {
      url = "github:D34DC3N73R/snapraid-btrfs";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... } @ inputs: {
    nixosConfigurations.nix-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        inherit inputs;
      };

      modules = [
        ./hosts/nix-server
      ];
    };
  };
}
