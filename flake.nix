{
  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/release-21.11"; };
    jobo_bot = { url = "github:haztecaso/jobo_bot"; };
  };

  outputs = inputs:
  let
    overlay = final: prev: {
      jobo_bot = inputs.jobo_bot.packages.${final.system}.jobo_bot;
    };
    overlays_module = { config, pkgs, ... } : {
      nixpkgs.overlays = [ overlay ];
    };
    commonModules = [
        overlays_module
        ./common.nix
        ./modules
    ];
  in 
  {
    nixosConfigurations.lambda = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = commonModules ++ [
        ./hosts/lambda
      ];
    };
    nixosConfigurations.nixpi = inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = commonModules ++ [
        ./hosts/nixpi
      ];
    };
  };
}
