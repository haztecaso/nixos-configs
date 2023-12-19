{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-23.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = { url = "github:nix-community/home-manager/release-23.11"; inputs.nixpkgs.follows = "nixpkgs"; };
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus/v1.4.0";
    # snm = { url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-22.05"; inputs = { nixpkgs.follows = "unstable"; nixpkgs-22_05.follows = "nixpkgs"; }; };
    nixos-hardware = { url = "github:NixOS/nixos-hardware/master"; };
    agenix = { url = "github:ryantm/agenix"; inputs.nixpkgs.follows = "nixpkgs"; inputs.home-manager.follows = "home-manager"; };
    neovim-flake = { url = "github:haztecaso/neovim-flake"; inputs.nixpkgs.follows = "nixpkgs"; };
    # bwmenu = { url = "github:haztecaso/bwmenu"; inputs.nixpkgs.follows = "nixpkgs"; };
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
        permittedInsecurePackages = [ "electron-25.9.0" ]; # TODO: remove this, necessary for logseq
      };

      sharedOverlays = [
        inputs.agenix.overlays.default
        inputs.neovim-flake.overlay
        inputs.jobo_bot.overlay
        inputs.remadbot.overlay
        inputs.mpdws.overlay
        inputs.tidal.overlays.default
        (final: prev: { unstable = inputs.unstable.legacyPackages.${prev.system}; })
        # (final: prev: { bwmenu = inputs.bwmenu.packages.${prev.system}.bwmenu; })
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
          # inputs.snm.nixosModule
        ];
      };

      hosts = {
        elbrus.modules = [ ./hosts/elbrus ];
        lambda.modules = [ ./hosts/lambda ];
        nas.modules = [ ./hosts/nas ];
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
