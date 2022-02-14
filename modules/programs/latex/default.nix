{ lib, pkgs, config, ... }:
let
  cfg = config.custom.programs.latex;
in
{
  options.custom.programs.latex = with lib; {
    enable = mkEnableOption "Enable latex with packages";
  };

  config = lib.mkIf cfg.enable (let
    conf = {
      programs.texlive = {
        enable = true;
        extraPackages = tpkgs: {
          inherit (tpkgs) scheme-medium adjustbox babel-german background
          biblatex bidi blindtext cleveref collectbox csquotes easylist enumitem
          environ everypage filehook fixme fontawesome5 footmisc footnotebackref
          framed fvextra hanging hyphenat imakeidx ifmtarg leftidx letltxmacro
          ly1 marginnote mdframed mweights needspace pagecolor pdfpages sectsty
          sourcecodepro sourcesanspro standalone tabulary tcolorbox thmtools
          tikz-cd titlesec titling trimspaces ucharcat ulem unicode-math upquote
          xecjk xifthen xurl zref;
        };
      };
    };
  in {
    home-manager.users.skolem = { ... }: conf;
  });
}
