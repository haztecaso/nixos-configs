{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-22.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = { url = "github:nix-community/home-manager/release-22.05"; inputs.nixpkgs.follows = "nixpkgs"; };
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    snm = { url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-22.05"; inputs = { nixpkgs.follows = "unstable"; nixpkgs-22_05.follows = "nixpkgs"; }; };
    nixos-hardware = { url = "github:NixOS/nixos-hardware/master"; inputs.nixpkgs.follows = "nixpkgs"; };
    agenix = { url = "github:ryantm/agenix"; inputs.nixpkgs.follows = "nixpkgs"; };
    neovim-flake = { url = "github:haztecaso/neovim-flake"; inputs.nixpkgs.follows = "nixpkgs"; };
    impo = { url = "github:haztecaso/impo"; inputs.nixpkgs.follows = "nixpkgs"; };
    jobo_bot = { url = "github:haztecaso/jobo_bot"; inputs.nixpkgs.follows = "nixpkgs"; };
    moodle-dl = { url = "github:haztecaso/flakes?dir=moodle-dl"; inputs.nixpkgs.follows = "nixpkgs"; };
    mpdws = { url = "github:haztecaso/mpdws"; inputs = { nixpkgs.follows = "nixpkgs"; utils.follows = "utils"; }; };
    nnn = { url = "github:jarun/nnn"; flake = false; };
  };

  outputs = inputs@{ self, ... }: inputs.utils.lib.mkFlake {
    inherit self inputs;

    sharedOverlays = [
      inputs.agenix.overlay
      inputs.neovim-flake.overlay
      inputs.impo.overlay
      inputs.jobo_bot.overlay
      inputs.moodle-dl.overlay
      inputs.mpdws.overlay
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
        inputs.mpdws.nixosModule
        inputs.snm.nixosModule
      ];
    };

    hosts = {
      beta.modules = [ ./hosts/beta inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x270 ];
      galois.modules = [ ./hosts/galois ];
      lambda.modules = [ ./hosts/lambda ];
    };

    nixosModule = import ./modules;

    overlay = import ./overlay;

    # outputsBuilder = channels: {
    #   packages = let
    #     docs = import ./docs { pkgs = channels.nixpkgs; };
    #   in {
    #     # docs-manpages = docs.manPages;
    #     docs-html = docs.manual.html;
    #   };
    # };
  };
}
