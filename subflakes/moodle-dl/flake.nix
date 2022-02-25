{
  inputs = {
    mach-nix.url = "mach-nix/3.4.0";
  };

  outputs = {self, nixpkgs, mach-nix }:
    let
      l = nixpkgs.lib // builtins;
      supportedSystems = [ "x86_64-linux" "aarch64-darwin" ];
      forAllSystems = f: l.genAttrs supportedSystems
        (system: f system (import nixpkgs {inherit system;}));
    in
    {
      defaultPackage = forAllSystems (system: pkgs: mach-nix.lib."${system}".mkPython {
        requirements = ''
          moodle-dl
        '';
      });
    };
}
