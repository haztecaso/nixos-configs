{ config, lib, pkgs, ... }:
let
  cfg = config.custom.services;
in
{
  imports = [
    ./autofs.nix
    ./fava.nix
    ./moodle-dl.nix
    ./music-server.nix
    ./syncthing.nix
    ./tailscale.nix
  ];

  options.custom.services = with lib; {
    gitea.enable = mkEnableOption "Enable gitea code hosting.";
    netdata.enable = mkEnableOption "Enable netdata web panel.";
    radicale.enable = mkEnableOption "Enable radicale (Cal|Card)DAV server.";
  };

  config = with lib; mkMerge [
      (mkIf cfg.gitea.enable (let
        port = 8006;
        serverName = "dav.haztecaso.com";
      in {
        services = {
          radicale = {
            enable = true;
            settings = {
              server.hosts = [ "localhost:${toString port}"];
              auth = {
                type = "htpasswd";
                htpasswd_filename = "/var/lib/radicale/htpasswd";
                htpasswd_encryption = "bcrypt";
              };
            };
          };
          nginx.virtualHosts.radicale = {
            enableACME = true;
            forceSSL = true;
            serverName = serverName;
            locations."/".proxyPass = "http://127.0.0.1:${toString port}";
          };
        };
      }))
      # gitea config
      (mkIf cfg.gitea.enable (let
        cfg = config.custom.services.gitea;
        port = 8003;
        serverName = "git.haztecaso.com";
      in {
        services = {
          gitea = {
            enable = true;
            domain = serverName;
            appName = "Gitea";
            httpAddress = "127.0.0.1";
            httpPort = port;
            rootUrl = "https://${serverName}/";
            settings = {
              service = {
                DISABLE_REGISTRATION = true;
              };
              session = {
                COOKIE_SECURE = true;
              };
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
            serverName = serverName;
            locations."/".proxyPass = "http://127.0.0.1:${toString port}";
          };
        };
        mailserver.loginAccounts."gitea@haztecaso.com" = {
          hashedPassword = "$2y$05$YHivXvJqLKBlXuddFkGpiev087Ve0DsJwyvKJFUsEfB31ULkZPS5O";
          name = "Gitea";
          sendOnly = true;
        };
      }))

      # netdata config
      (mkIf cfg.netdata.enable (let
        cfg = config.custom.services.netdata;
        port = 8004;
        serverName = "netdata.lambda.lan";
      in {
        services = {
          netdata = {
            enable = true;
            config.web."default port" = port;
          };
       
          nginx.virtualHosts.netdata = {
            serverName = serverName;
            locations."/".proxyPass = "http://127.0.0.1:${toString port}";
          };
        };
      }))
  ];
}
