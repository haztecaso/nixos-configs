{ config, lib, pkgs, ... }: let
  cfg = config.services.custom.gitea;
in
{
  options.services.custom.gitea = with lib; {
    enable = mkEnableOption "Enable gitea code hosting.";
    port = mkOption {
      type = types.port;
      description = "Gitea internal listen port.";
    };
    serverName = mkOption {
      type = types.str;
      description = "Gitea nginx server name.";
    };
  };
  config = lib.mkIf cfg.enable {
    services = {
      gitea = {
        enable = true;
        domain = cfg.serverName;
        appName = "Gitea";
        cookieSecure = true;
        disableRegistration = true;
        httpAddress = "127.0.0.1";
        httpPort = cfg.port;
        rootUrl = "https://${cfg.serverName}/";
        dump.enable = true;
        settings = {
          security = {
            LOGIN_REMEMBER_DAYS = 14;
            MIN_PASSWORD_LENGTH = 12;
            PASSWORD_COMPLEXITY = "lower,upper,digit,spec";
            PASSWORD_CHECK_PWN = true;
          };
          mailer = {
            ENABLED = true;
            MAILER_TYPE = "sendmail";
            FROM = "gitea@haztecaso.com";
            SENDMAIL_PATH = "${pkgs.postfix}/bin/sendmail";
          };
          other = {
            SHOW_FOOTER_VERSION = false;
            SHOW_FOOTER_TEMPLATE_LOAD_TIME = false;
          };
        };
      };
      nginx.virtualHosts.gitea = {
        enableACME = true;
        forceSSL = true;
        serverName = cfg.serverName;
        locations."/".proxyPass = "http://127.0.0.1:${toString cfg.port}";
      };
    };
    mailserver.loginAccounts."gitea@haztecaso.com" = {
      hashedPassword = "$2y$05$YHivXvJqLKBlXuddFkGpiev087Ve0DsJwyvKJFUsEfB31ULkZPS5O";
      name = "Gitea";
      sendOnly = true;
    };
  };
}
