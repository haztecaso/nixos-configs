{
  inputs = {
    nixpkgs        = { url = "github:nixos/nixpkgs/release-21.11"; };
    home-manager   = { url = "github:nix-community/home-manager"; };
    www-haztecaso  = { flake = false; url = "path:/var/www/haztecaso.com"; };
    www-lagransala = { flake = false; url = "path:/var/www/lagransala.es"; };
  };

  outputs = inputs: {
    nixosConfigurations.lambda = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        inputs.home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users = {
            root = import ./home/root.nix;
          };
        }
      ];
      specialArgs = { inherit inputs; };
    };
  };
}
