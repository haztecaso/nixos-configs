{ lib, pkgs, config, ... }:
let
  cfg = config.custom.programs.git;
  defaults = {
    skolem = {
      enable = true;
      email    = "adrianlattes@disroot.org";
      username = "haztecaso";
    };
  };
in
{
  options.custom.programs.git = with lib; {
    enable = mkEnableOption "Wether to enable custom git module.";
    email = mkOption {
      type = types.str;
      description = "git userEmail";
    };
    username = mkOption {
      type = types.str;
      description = "git userName";
    };
    lfs = mkEnableOption "Wether to enable lfs support.";
  };

  config = lib.mkMerge ([
      (lib.mkIf cfg.enable {
        home.packages = with pkgs; [ git-crypt ];
          programs.git = {
            enable = true;
            userEmail = cfg.email;
            userName = cfg.username;
            lfs.enable = cfg.lfs;
          };
      })
  ] ++ lib.mapAttrsToList (name: conf:
    lib.mkIf (name == config.home.username) {
      custom.programs.git = lib.mkDefault conf;
    }) defaults);

}
