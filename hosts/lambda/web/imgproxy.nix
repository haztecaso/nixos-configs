# TODO
# - Finish configuring
# - Consider using only nginx with some module and cache enabled:
#   - https://charlesleifer.com/blog/nginx-a-caching-thumbnailing-reverse-proxying-image-server-/
#   - https://github.com/cubicdaiya/ngx_small_light
{ config, lib, pkgs, ... }: let
  port = 8007;
in
{
  # From https://github.com/wunderwerkio/nix-imgproxy
  systemd.services.imgproxy = {
    wantedBy = ["multi-user.target"];
      after = ["network.target"];
      environment = {
        IMGPROXY_BIND = "127.0.0.1:${toString port}";
      };
      serviceConfig = {
        ExecStart = "${pkgs.imgproxy}/bin/imgproxy";
        Restart = "always";
        RestartSec = "10s";
        DynamicUser = true;
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = ["AF_UNIX" "AF_INET" "AF_INET6"];
        RestrictNamespaces = true;
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        PrivateMounts = true;
        # System Call Filtering
        SystemCallArchitectures = "native";
        SystemCallFilter = ["~@cpu-emulation @debug @keyring @mount @obsolete @privileged @setuid"];
      };
  };
  services.nginx = {
    appendHttpConfig = ''
      proxy_cache_path /tmp/imgproxy-cache levels=1:2 keys_zone=imgproxy_cache:16M inactive=30d max_size=1000M;
    '';
    virtualHosts.imgproxy = {
      useACMEHost = "haztecaso.com";
      forceSSL = true;
      serverName = "img.haztecaso.com";
      extraConfig = ''
        error_log /var/log/nginx/thumbor-error.log warn;
        access_log /var/log/nginx/thumbor-access.log;
      '';
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";
        extraConfig = ''
          proxy_cache imgproxy_cache;
          proxy_cache_key $host$document_uri$is_args$args;
          proxy_cache_lock on;
          proxy_cache_valid 30d;
          proxy_cache_use_stale error timeout updating;
          proxy_http_version 1.1;
          expires 30d;
        '';
      };
    };
  };
}
