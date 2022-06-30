# Heavily inspired on https://gitlab.com/rycee/nur-expressions/-/blob/master/doc/default.nix
{ pkgs }:
let
  lib = pkgs.lib;
  nmdSrc = pkgs.fetchFromGitLab {
    name = "nmd";
    owner = "rycee";
    repo = "nmd";
    rev = "2398aa79ab12aa7aba14bc3b08a6efd38ebabdc5";
    sha256 = "0yxb48afvccn8vvpkykzcr4q1rgv8jsijqncia7a5ffzshcrwrnh";
  };
  nmd = import nmdSrc { inherit pkgs; };
  setupModule = {
    imports = [{
      _module.args = {
        pkgs = lib.mkForce (nmd.scrubDerivations "pkgs" pkgs);
        pkgs_i686 = lib.mkForce { };
      };
      _module.check = false;
    }];
  };
  modulesDocs = nmd.buildModulesDocs {
    moduleRootPaths = [ ../modules ];
    modules = [
        # ../modules/dev.nix 
        setupModule
    ];
    mkModuleUrl = path: "https://github.com/haztecaso/nixos-configs/blob/master/${path}#blob-path";
    channelName = "nixos-configs";
    docBook.id = "nixos-configs-options";
  };
  docs = nmd.buildDocBookDocs {
    pathName = "nixos-configs";
    modulesDocs = [ modulesDocs ];
    documentsDirectory = ./.;
    documentType = "book";
    chunkToc = ''
      <toc>
        <d:tocentry xmlns:d="http://docbook.org/ns/docbook" linkend="book-nixos-configs-manual"><?dbhtml filename="index.html"?>
          <d:tocentry linkend="ch-options"><?dbhtml filename="options.html"?></d:tocentry>
        </d:tocentry>
      </toc>
    '';
  };
in {
  manPages = docs.manPages;
  manual = { inherit (docs) html htmlOpenTool; };
}
