{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-22.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = { url = "github:nix-community/home-manager/release-22.11"; inputs.nixpkgs.follows = "nixpkgs"; };
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    deploy-rs.url = "github:serokell/deploy-rs";
    snm = { url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-22.05"; inputs = { nixpkgs.follows = "unstable"; nixpkgs-22_05.follows = "nixpkgs"; }; };
    nixos-hardware = { url = "github:NixOS/nixos-hardware/master"; };
    agenix = { url = "github:ryantm/agenix"; inputs.nixpkgs.follows = "nixpkgs"; };
    neovim-flake = { url = "github:haztecaso/neovim-flake"; inputs.nixpkgs.follows = "nixpkgs"; };
    impo = { url = "github:haztecaso/impo"; inputs.nixpkgs.follows = "nixpkgs"; };
    jobo_bot = { url = "github:haztecaso/jobo_bot"; inputs.nixpkgs.follows = "nixpkgs"; };
    remadbot = { url = "github:haztecaso/remadbot"; inputs.nixpkgs.follows = "nixpkgs"; };
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
      inputs.remadbot.overlay
      inputs.mpdws.overlay
      inputs.deploy-rs.overlay
      (final: prev: { unstable = inputs.unstable.legacyPackages.${prev.system}; })
      self.overlays.default
    ];

    hostDefaults = {
      extraArgs = { inherit inputs; };
      modules = [
        ./modules
        inputs.agenix.nixosModule
        inputs.home-manager.nixosModule
        inputs.jobo_bot.nixosModule
        inputs.remadbot.nixosModule
        inputs.mpdws.nixosModule
        inputs.snm.nixosModule
      ];
    };

    hosts = {
      beta.modules = [ ./hosts/beta inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x270 ];
      elbrus.modules = [ ./hosts/elbrus ];
      # galois.modules = [ ./hosts/galois ];
      lambda.modules = [ ./hosts/lambda ];
      nas.modules = [ ./hosts/nas ];
    };

    deploy = let
      activate = inputs.deploy-rs.lib.x86_64-linux.activate.nixos;
      hosts = self.nixosConfigurations;
    in {
      user = "root";
      nodes = {
        nas = { hostname = "nas"; profiles.system.path = activate hosts.nas; };
        lambda = { hostname = "lambda"; profiles.system.path = activate hosts.lambda; };
      };
    };

    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;

    nixosModules.default = import ./modules;

    overlays.default = import ./overlay;

    outputsBuilder = channels: {
      packages = let
        docs = import ./docs { pkgs = channels.nixpkgs; };
      in {
        docs-manpages = docs.manPages;
        docs-html = docs.manual.html;
      };
    };
  };
}
