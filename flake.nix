{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = { url = "github:nix-community/home-manager/release-24.05"; inputs.nixpkgs.follows = "nixpkgs"; };
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus/v1.4.0";
    nixos-hardware = { url = "github:NixOS/nixos-hardware/master"; };
    agenix = { url = "github:ryantm/agenix"; inputs.nixpkgs.follows = "nixpkgs"; inputs.home-manager.follows = "home-manager"; };
    neovim-flake = {
      url = "github:haztecaso/neovim-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jobo_bot = { url = "github:haztecaso/jobo_bot"; inputs.nixpkgs.follows = "nixpkgs"; };
    remadbot = { url = "github:haztecaso/remadbot"; inputs.nixpkgs.follows = "nixpkgs"; };
    mpdws = { url = "github:haztecaso/mpdws"; inputs = { nixpkgs.follows = "nixpkgs"; utils.follows = "utils"; }; };
    nnn = { url = "github:jarun/nnn"; flake = false; };
    tidal = { url = "github:mitchmindtree/tidalcycles.nix"; };
  };

  outputs = inputs@{ self, ... }: inputs.utils.lib.mkFlake
    {
      inherit self inputs;

      channelsConfig = {
        allowUnfree = true;
        permittedInsecurePackages = [ "electron-27.3.11" ]; # necessary for logseq
      };

      sharedOverlays = [
        inputs.agenix.overlays.default
        inputs.neovim-flake.overlays.default
        inputs.jobo_bot.overlay
        inputs.remadbot.overlay
        inputs.mpdws.overlay
        inputs.tidal.overlays.default
        (final: prev: { unstable = inputs.unstable.legacyPackages.${prev.system}; })
        self.overlays.default
      ];

      hostDefaults = {
        extraArgs = { inherit inputs; };
        modules = [
          ./meshNodes.nix
          ./modules
          inputs.agenix.nixosModules.default
          inputs.home-manager.nixosModule
          inputs.jobo_bot.nixosModule
          inputs.remadbot.nixosModule
          inputs.mpdws.nixosModule
        ];
      };

      hosts = {
        deambulante.modules = [ ./hosts/deambulante ];
        elbrus.modules = [ ./hosts/elbrus ];
        lambda.modules = [ ./hosts/lambda ];
        nas.modules = [ ./hosts/nas ];
        posets.modules = [ ./hosts/posets ];
      };

      nixosModules.default = import ./modules;

      overlays.default = import ./overlay;

    } // {
    # TODO
    # hydraJobs = {
    #   elbrus = self.nixosConfigurations.elbrus.config.system.build.vm;
    #   lambda = self.nixosConfigurations.lambda.config.system.build.vm;
    #   nas = self.nixosConfigurations.nas.config.system.build.vm;
    # };
  };
}
