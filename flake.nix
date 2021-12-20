{
  inputs = {
    nixpkgs        = { url = "github:nixos/nixpkgs/release-21.11"; };
    www-haztecaso  = { flake = false; url = "path:/var/www/haztecaso.com"; };
    www-lagransala = { flake = false; url = "path:/var/www/lagransala.es"; };
  };
  outputs = inputs: {
    nixosConfigurations.lambda = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
      specialArgs = { inherit inputs; };
    };
  };
}
