{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-21.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    moodle-dl = {
      url = "github:haztecaso/flakes?dir=moodle-dl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impo = {
      url = "github:haztecaso/impo";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jobo_bot = {
      url = "github:haztecaso/jobo_bot";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nnn = {
      url = "github:jarun/nnn";
      flake = false;
    };
  };

  outputs = inputs@{
    self,
    nixpkgs,
    nixpkgs-unstable,
    utils,
    ...
  }:
  let
    flake_overlay = final: prev: {
      jobo_bot  = inputs.jobo_bot.packages.${final.system}.jobo_bot;
      moodle-dl = inputs.moodle-dl.defaultPackage.${final.system};
    };
    overlay_unstable = final: prev: {
      unstable = nixpkgs-unstable.legacyPackages.${prev.system};
    };
  in utils.lib.mkFlake {
    inherit self inputs;

    sharedOverlays = [
      flake_overlay
      overlay_unstable
      self.overlay
      inputs.impo.overlay
    ];

    hostDefaults = {
      extraArgs = { inherit inputs; };
      modules = [
        ./modules
        inputs.agenix.nixosModule
        inputs.home-manager.nixosModule
      ];
    };

    hosts = {
      lambda.modules = [ ./hosts/lambda ];
      beta.modules = [
        ./hosts/beta
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x270
      ];
    };

    overlay = import ./overlay;

  };
}
