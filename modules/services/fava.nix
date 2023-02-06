{ config, lib, pkgs, ... }: let
  cfg = config.custom.services.fava;
  script = pkgs.writeScriptBin "moodle-dl" ''
    #!${pkgs.runtimeShell}
    ${pkgs.fava}/bin/fava -H ${cfg.hostname} -p ${cfg.port} ${cfg.beancountFile}
  '';
in {
  options.custom.services.fava = with lib; {
    enable = mkEnableOption "Enable fava, a web ui for beancount";
    beancountFile = mkOption {
      type = types.str;
      example = "/var/lib/syncthing/default/money.beancount";
      description = "path of beancount ledger file";
    };
    port = mkOption {
      type = types.port;
      default = 5000;
      description = "Listen port for fava";
    };
    hostname = mkOption {
      type = types.str;
      example = "0.0.0.0";
      default = "127.0.0.1";
      description = "Listen hostname for fava";
    };
    openPort = mkEnableOption "Wether to open firewall.";
  };
  config = lib.mkIf cfg.enable {
    systemd.services.fava = {
      description = "Web interface for beancount";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
          ExecStart = ''
            ${pkgs.fava}/bin/fava ${cfg.beancountFile} -H ${cfg.hostname} -p ${toString cfg.port}
          '';
      };
    };
    networking.firewall.allowedTCPPorts = if cfg.openPort then [ cfg.port ] else [];
  };
}
