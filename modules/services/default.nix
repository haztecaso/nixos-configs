{ config, lib, pkgs, ... }:
let
  cfg = config.custom.services;
in
{
  imports = [
    ./syncthing.nix
    ./tailscale.nix
    ./vaultwarden.nix
  ];

  options.custom.services = with lib; {
    code-server.enable = mkEnableOption "Enable vscode on the web.";
    gitea.enable = mkEnableOption "Enable gitea code hosting.";
    netdata.enable = mkEnableOption "Enable netdata web panel.";
  };

  config = with lib; mkMerge [

      # code server config
      (mkIf cfg.code-server.enable (let
        root = "/root/";
        port = "8002";
      in {
        virtualisation.docker.enable = true;
        virtualisation.oci-containers.containers."code-server" = {
          image = "codercom/code-server:latest";
          ports = [ "${port}:8080" ];
          volumes = [ "/var/lib/code/:${root}" ];
          user = "0:0";
          environment.DOCKER_USER="root";
        };
        services = {
          nginx.virtualHosts.code = {
            enableACME = true;
            forceSSL = true;
            serverName = "code.haztecaso.com";
            locations."/" = {
              proxyPass = "http://127.0.0.1:${port}";
              extraConfig = ''
                  proxy_set_header Upgrade $http_upgrade;
                  proxy_set_header Connection upgrade;
                  proxy_set_header Accept-Encoding gzip;
              '';
            };
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
            cookieSecure = true;
            disableRegistration = true;
            httpAddress = "127.0.0.1";
            httpPort = port;
            rootUrl = "https://${serverName}/";
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
