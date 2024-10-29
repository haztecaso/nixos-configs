# TODO
# separate nginx config
# package h5ai
# write nixos module

{ config, pkgs, lib, ... }: 
let 
  app = "h5ai"; 
in
{
  services = {
    nginx = {
      enable = true;
      additionalModules = [ pkgs.nginxModules.fancyindex ];
      enableReload = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      upstreams."php-h5ai" = {
        servers = {
          "unix:${config.services.phpfpm.pools.${app}.socket}" =  {};
        };
      };
      virtualHosts.h5ai = {
        serverName = "nas";
        root = "/var/www/${app}";
        locations = {
          # "/".index = "index.html  index.php  /_h5ai/public/index.php";
          # "~ \.php$".extraConfig = ''
          #   fastcgi_split_path_info ^(.+\.php)(/.+)$;
          #   fastcgi_intercept_errors on;
          #   fastcgi_pass php-${app};
          #   include ${pkgs.nginx}/conf/fastcgi_params;
          #   include ${pkgs.nginx}/conf/fastcgi.conf;
          #   fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
          # '';
          "/" = {
            index = "index.html .noindex noindex.html";
            extraConfig = ''
              fancyindex on;
              fancyindex_localtime on;
              fancyindex_exact_size off;
              fancyindex_header "/fancyindex/header.html";
              fancyindex_footer "/fancyindex/footer.html";
              fancyindex_ignore "_h5ai";
              fancyindex_ignore "fancyindex*";
              fancyindex_name_length 255; # Maximum file name length in bytes, change as you like.
            '';
          };
        };
      };
    };
    phpfpm.pools.${app} = {
      user = app;
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
      phpEnv."PATH" = lib.makeBinPath [ pkgs.php ];
    };
  };
  users.users.${app} = {
    isSystemUser = true;
    home = "/var/www/${app}";
    group  = app;
  };
  users.groups.${app} = {};
  users.extraGroups.syncthing.members = [ "nginx" ];
}
