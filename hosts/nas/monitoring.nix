{ config, ... }: {
  age.secrets."grafanaCloudCredentials".file = 
    ../../secrets/grafana-cloud-prometheus-endpoint.age;
  services.prometheus = {
    enable = true;
    remoteWrite = [ 
      {
        url = "https://prometheus-prod-24-prod-eu-west-2.grafana.net/api/prom/push";
        basic_auth.username = "1852130";
        basic_auth.password_file = config.age.secrets."grafanaCloudCredentials".path;
      } 
    ];
    exporters = {
      node.enable = true;
      systemd.enable = true;
      # php-fpm.enable = true;
      nginxlog.enable = true;
    };
  };
}
