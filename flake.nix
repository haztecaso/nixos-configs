{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-21.11";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jobo_bot = {
      url = "github:haztecaso/jobo_bot";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, agenix, utils, jobo_bot }:
  let
    jobo_bot_overlay = final: prev: {
      jobo_bot = jobo_bot.packages.${final.system}.jobo_bot;
    };
  in utils.lib.mkFlake
  {
    inherit self inputs;

    sharedOverlays = [ jobo_bot_overlay self.overlay ];

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

    overlay = import ./overlay;

  };
}
