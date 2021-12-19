{
  inputs = {
    nixpkgs = { url= "github:nixos/nixpkgs/release-21.11"; };
  };
  outputs = { self, nixpkgs }: {
    nixosConfigurations.lambda = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
    };
  };
}
