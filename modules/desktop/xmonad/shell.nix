{ nixpkgs }:
let
  inherit (nixpkgs) pkgs;
  inherit (pkgs) haskellPackages;

  haskellDeps = ps: with ps; [ base xmonad xmonad-contrib xmonad-extras ];
  ghc = haskellPackages.ghcWithPackages haskellDeps;

  nixPackages = [
    ghc
    pkgs.ghcid
    haskellPackages.haskell-language-server
  ];
in
pkgs.stdenv.mkDerivation {
  name = "xmonad-env";
  nativeBuildInputs = nixPackages;
}
