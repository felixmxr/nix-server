{
  description = "Home server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    snapraid-btrfs = {
      url = "github:automorphism88/snapraid-btrfs";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... } @ inputs: {
    nixosConfigurations.homeserver = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        inherit inputs;
      };

      modules = [
        ./hosts/homeserver
      ];
    };
  };
}
