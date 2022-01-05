{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-21.11";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    deploy-rs.url = "github:serokell/deploy-rs";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jobo_bot = {
      url = "github:haztecaso/jobo_bot";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, agenix, utils, jobo_bot, deploy-rs }:
  let
    overlay = final: prev: {
      jobo_bot = jobo_bot.packages.${final.system}.jobo_bot;
    };
  in utils.lib.mkFlake
  {
    inherit self inputs;

    sharedOverlays = [ overlay ];

    hostDefaults = {
      modules = [
        ./modules
        ./common.nix
        agenix.nixosModules.age
      ];
      extraArgs = { inherit utils inputs; };
    };

    hosts = {
      lambda.modules = [ ./hosts/lambda ];
      nixpi = {
        system = "aarch64-linux";
        modules = [ ./hosts/nixpi ];
      };
    };

    deploy.nodes = {
      lambda = {
        hostname = "lambda";
        profiles.system = {
          sshUser = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.lambda;
        };
      };
      nixpi = {
        hostname = "nixpi";
        profiles.system = {
          sshUser = "root";
          path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.nixpi;
        };
      };
    };

    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

  };
}
