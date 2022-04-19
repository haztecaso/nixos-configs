{ config, lib, pkgs, ... }: {
  options.webserver.gitea = with lib; {
    enable = mkEnableOption "Enable gitea code hosting.";
  };
  config = lib.mkIf config.webserver.gitea.enable {
    services = {
      gitea = {
        enable = true;
        domain = "git.haztecaso.com";
        httpAddress = "127.0.0.1";
        httpPort = 8003;
        rootUrl = "https://git.haztecaso.com/";
        dump = {
          enable = true;
        };
      };
      nginx.virtualHosts.gitea = {
        enableACME = true;
        forceSSL = true;
        serverName = "git.haztecaso.com";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8003";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
    };
  };
}
