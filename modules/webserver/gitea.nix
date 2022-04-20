{ config, lib, pkgs, ... }: {
  options.webserver.gitea = with lib; {
    enable = mkEnableOption "Enable gitea code hosting.";
  };
  config = lib.mkIf config.webserver.gitea.enable {
    services = {
      gitea = {
        enable = true;
        domain = "git.haztecaso.com";
        appName = "Gitea";
        cookieSecure = true;
        disableRegistration = true;
        httpAddress = "127.0.0.1";
        httpPort = 8003;
        rootUrl = "https://git.haztecaso.com/";
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
            SENDMAIL_PATH = "${pkgs.system-sendmail}/bin/sendmail";
          };
          other = {
            SHOW_FOOTER_VERSION = false;
          };
        };
      };
      nginx.virtualHosts.gitea = {
        enableACME = true;
        forceSSL = true;
        serverName = "git.haztecaso.com";
        locations."/".proxyPass = "http://127.0.0.1:8003";
      };
    };
    mailserver.loginAccounts."gitea@haztecaso.com" = {
      hashedPassword = "$2y$05$YHivXvJqLKBlXuddFkGpiev087Ve0DsJwyvKJFUsEfB31ULkZPS5O";
      name = "Gitea";
      sendOnly = true;
    };
  };
}
