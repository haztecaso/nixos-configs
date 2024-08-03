{ config, lib, pkgs, ... }:
let
  cfg = config.services.custom.web.wordpress;
  # This utility function is needed to avoid mkMerge recursion
  # copied from https://gist.github.com/udf/4d9301bdc02ab38439fd64fbda06ea43
  mkMergeTopLevel = names: attrs: with lib; getAttrs names (
    mapAttrs (k: v: mkMerge v) (foldAttrs (n: a: [n] ++ a) [] attrs)
  );
  siteOptions = { lib, options, config, ... }: 
  let 
    cfg = config;
  in
  {
    options = with lib; {
      name = mkOption {
        type = types.str;
        # TODO: remove and use option attr name
      };
      appName = mkOption {
        type = types.str;
        example = "myweb";
        description = "Identifier used for naming services and databases.";
        # TODO: assertions: appName should be only alpha characters
      };
      domain = mkOption {
        type = types.str;
        example = "myweb.com";
        description = "Website domain";
      };
      subdomain = mkOption {
        type = types.nullOr types.str;
        example = "wp";
        description = "Subdomain where to install wordpress. Main domain if null.";
      };
      host = mkOption {
        type = types.str;
        readOnly = true;
        description = "Concatenation of subdomain with domain.";
      };
      root = mkOption {
        type = types.str;
        description = "Wordpress root folder. Default /var/www/wordpress/<site name>.";
      };
      ACMEHost = mkOption {
        type = types.str;
        description = "The ACME host to use for SSL.";
      };
    };
    config = {
      appName = lib.mkDefault "wp${cfg.name}";
      root = lib.mkDefault "/var/www/wordpress/${cfg.name}";
      host = if cfg.subdomain == null then cfg.domain else "${cfg.subdomain}.${cfg.domain}";
      ACMEHost = lib.mkDefault cfg.domain;
    };
  };
  mkSiteConfig = name: cfg: { 
    services = {
      nginx = {
      };
    };
    users = {
      users.${cfg.appName} = {
        isSystemUser = true;
        home = cfg.root;
        group = cfg.appName;
      };
      groups.${cfg.appName} = { };
    };
  };
  # mkSiteConfig = name: config:
  #   let
  #     cfg = config.services.custom.web.wordpress.sites.${name};
  #   in
  #   {
  #     services = {
  #       nginx = {
  #         upstreams."php-${appName}".servers."unix:${config.services.phpfpm.pools.${app}.socket}" = { };
  #         virtualHosts = {
  #           "${host}" = {
  #             inherit root;
  #             useACMEHost = ACMEHost;
  #             forceSSL = true;
  #             extraConfig = ''
  #               index index.php index.html;
  #               error_log syslog:server=unix:/dev/log debug;
  #               access_log syslog:server=unix:/dev/log,tag=${appName};
  #               client_max_body_size 20M;
  #             '';
  #             locations = {
  #               "/".extraConfig = ''
  #                 try_files $uri $uri/ /index.php?$args;
  #               '';
  #               "~ \.php$".extraConfig = ''
  #                 fastcgi_split_path_info ^(.+\.php)(/.+)$;
  #                 fastcgi_intercept_errors on;
  #                 fastcgi_pass php-${app};
  #                 include ${pkgs.nginx}/conf/fastcgi_params;
  #                 include ${pkgs.nginx}/conf/fastcgi.conf;
  #                 fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
  #               '';
  #               "~* \.(js|css|png|jpg|jpeg|gif|ico)$".extraConfig = ''
  #                 expires max;
  #                 log_not_found off;
  #               '';
  #               "/favicon.ico".extraConfig = ''
  #                 log_not_found off;
  #                 access_log off;
  #               '';
  #               "/robots.txt".extraConfig = ''
  #                 allow all;
  #                 log_not_found off;
  #                 access_log off;
  #               '';
  #             };
  #           };
  #         };
  #         phpfpm.pools.${appName} = {
  #           user = appName;
  #           settings = {
  #             "listen.owner" = config.services.nginx.user;
  #             "pm" = "dynamic";
  #             "pm.max_children" = 32;
  #             "pm.max_requests" = 500;
  #             "pm.start_servers" = 2;
  #             "pm.min_spare_servers" = 2;
  #             "pm.max_spare_servers" = 5;
  #             "php_admin_value[error_log]" = "stderr";
  #             "php_admin_flag[log_errors]" = true;
  #             "catch_workers_output" = true;
  #           };
  #           phpOptions = ''
  #             upload_max_filesize = 20M
  #             post_max_size = 25M
  #           '';
  #           phpEnv."PATH" = lib.makeBinPath [ pkgs.php ];
  #         };
  #         mysql = {
  #           enable = true;
  #           ensureDatabases = [ appName ];
  #           ensureUsers = [
  #             {
  #               name = appName;
  #               ensurePermissions = { "${appName}.*" = "ALL PRIVILEGES"; };
  #             }
  #           ];
  #         };
  #         mysqlBackup.databases = [ appName ];
  #       };
  #     };
  #     users = {
  #       users.${appName} = {
  #         isSystemUser = true;
  #         home = root;
  #         group = appName;
  #       };
  #       groups.${appName} = { };
  #     };
  #   };
in
{
  options = {
    services.custom.web.wordpress = with lib; {
      sites = mkOption {
        type = types.attrsOf (types.submodule siteOptions);
        default = { };
        description = "Wordpress sites configurations";
      };
    };
  };
  config.services.nginx = lib.mkMerge (lib.mapAttrsToList (name: cfg: {
    upstreams."php-${cfg.appName}".servers."unix:${config.services.phpfpm.pools.${cfg.appName}.socket}" = { };
    virtualHosts."${cfg.host}" = {
      root = cfg.root;
      useACMEHost = cfg.ACMEHost;
      forceSSL = true;
      extraConfig = ''
        index index.php index.html;
        error_log syslog:server=unix:/dev/log debug;
        access_log syslog:server=unix:/dev/log,tag=${cfg.appName};
        client_max_body_size 20M;
      '';
      locations = {
        "/".extraConfig = ''
          try_files $uri $uri/ /index.php?$args;
        '';
        "~ \.php$".extraConfig = ''
          fastcgi_split_path_info ^(.+\.php)(/.+)$;
          fastcgi_intercept_errors on;
          fastcgi_pass php-${cfg.appName};
          include ${pkgs.nginx}/conf/fastcgi_params;
          include ${pkgs.nginx}/conf/fastcgi.conf;
          fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
        '';
        "~* \.(js|css|png|jpg|jpeg|gif|ico)$".extraConfig = ''
          expires max;
          log_not_found off;
        '';
        "/favicon.ico".extraConfig = ''
          log_not_found off;
          access_log off;
        '';
        "/robots.txt".extraConfig = ''
          allow all;
          log_not_found off;
          access_log off;
        '';
      };
    };
  }) cfg.sites);
  config.services.phpfpm = lib.mkMerge (lib.mapAttrsToList (name: cfg: {
    pools.${cfg.appName} = {
      user = cfg.appName;
      settings = {
        "listen.owner" = config.services.nginx.user;
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.max_requests" = 500;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 5;
        "php_admin_value[error_log]" = "stderr";
        "php_admin_flag[log_errors]" = true;
        "catch_workers_output" = true;
        };
        phpOptions = ''
        upload_max_filesize = 20M
        post_max_size = 25M
        '';
        phpEnv."PATH" = lib.makeBinPath [ pkgs.php ];
    };
  }) cfg.sites);
  config.services.mysql = lib.mkMerge (lib.mapAttrsToList (name: cfg: {
    enable = true;
    ensureDatabases = [ cfg.appName ];
    ensureUsers = [ {
      name = cfg.appName;
      ensurePermissions = { 
        "${cfg.appName}.*" = "ALL PRIVILEGES"; 
      };
    } ];
  }) cfg.sites);
  config.services.mysqlBackup = lib.mkMerge (lib.mapAttrsToList (name: cfg: {
    databases = [ cfg.appName ];
  }) cfg.sites);
  config.users = lib.mkMerge (lib.mapAttrsToList (name: cfg: {
    users.${cfg.appName} = {
      isSystemUser = true;
      createHome = true;
      home = cfg.root;
      group = cfg.appName;
    };
    groups.${cfg.appName} = { };
  }) cfg.sites);
}
