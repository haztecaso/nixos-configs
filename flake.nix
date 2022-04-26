{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-21.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = { url = "github:nix-community/home-manager/release-21.11"; inputs.nixpkgs.follows = "nixpkgs"; };
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    snm = { url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-21.11"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixos-hardware = { url = "github:NixOS/nixos-hardware/master"; inputs.nixpkgs.follows = "nixpkgs"; };
    agenix = { url = "github:ryantm/agenix"; inputs.nixpkgs.follows = "nixpkgs"; };
    neovim-flake = { url = "github:haztecaso/neovim-flake"; inputs.nixpkgs.follows = "nixpkgs"; };
    impo = { url = "github:haztecaso/impo"; inputs.nixpkgs.follows = "nixpkgs"; };
    jobo_bot = { url = "github:haztecaso/jobo_bot"; inputs.nixpkgs.follows = "nixpkgs"; };
    moodle-dl = { url = "github:haztecaso/flakes?dir=moodle-dl"; inputs.nixpkgs.follows = "nixpkgs"; };
    web-elvivero = { url = "github:elvivero/elvivero.es"; inputs = { nixpkgs.follows = "nixpkgs"; utils.follows = "utils"; }; };
    web-elvivero-frutas = { url = "github:elvivero/frutas"; inputs = { nixpkgs.follows = "nixpkgs"; utils.follows = "utils"; }; };
    nnn = { url = "github:jarun/nnn"; flake = false; };
  };

  outputs = inputs@{ self, ... }: inputs.utils.lib.mkFlake {
    inherit self inputs;

    sharedOverlays = [
      inputs.neovim-flake.overlay
      inputs.impo.overlay
      inputs.jobo_bot.overlay
      inputs.moodle-dl.overlay
      inputs.web-elvivero-frutas.overlay
      inputs.web-elvivero.overlay
      (final: prev: { unstable = inputs.unstable.legacyPackages.${prev.system}; })
      self.overlay
    ];

    hostDefaults = {
      extraArgs = { inherit inputs; };
      modules = [
        ./modules
        inputs.agenix.nixosModule
        inputs.home-manager.nixosModule
        inputs.jobo_bot.nixosModule
        inputs.moodle-dl.nixosModule
        inputs.snm.nixosModule
        "${inputs.unstable}/nixos/modules/services/networking/headscale.nix"
      ];
    };

    hosts = {
      beta.modules = [ ./hosts/beta inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x270 ];
      galois.modules = [ ./hosts/galois ];
      lambda.modules = [ ./hosts/lambda ];
    };

    nixosModule = import ./modules;

    overlay = import ./overlay;

  };
}
