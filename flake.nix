{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-21.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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

  outputs = inputs@{ self, nixpkgs, home-manager, utils, agenix, ... }:
  let
    overlay = final: prev: {
      jobo_bot = inputs.jobo_bot.packages.${final.system}.jobo_bot;
    };
  in utils.lib.mkFlake
  {
    inherit self inputs;

    sharedOverlays = [ overlay ];

    hostDefaults = {
      modules = [
        ./modules
        agenix.nixosModules.age
        home-manager.nixosModules.home-manager
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
