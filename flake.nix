{
  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/release-21.11"; };
  };

  outputs = inputs: {
    nixosConfigurations.lambda = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./common.nix
        ./modules
        ./hosts/lambda/configuration.nix
      ];
    };
  };
}
