{ config, ... }:
let
  cloudflareCert = extraDomainNames: {
    dnsProvider = "cloudflare";
    credentialsFile = config.age.secrets."cloudflare".path;
    group = "nginx";
    inherit extraDomainNames;
  };
in
{
  age.secrets."cloudflare".file = ../../../secrets/cloudflare.age;
  security.acme.certs = {
    "bufanda.cc" = cloudflareCert [ "*.bufanda.cc" "*.dev.bufanda.cc" ];
    "claudiogabis.com" = cloudflareCert [ "*.claudiogabis.com" ];
    "colchon.review" = cloudflareCert [ "*.colchon.review" ];
    "delunesadomingo.es" = cloudflareCert [ "*.delunesadomingo.es" ];
    "elvivero.es" = cloudflareCert [ "*.elvivero.es" ];
    "enelpetirrojo.com" = cloudflareCert [ "*.enelpetirrojo.com" ];
    "equisoain.com" = cloudflareCert [ "*.equisoain.com" ];
    "haztecaso.com" = cloudflareCert [ "*.haztecaso.com" ];
    "paseourbano.com" = cloudflareCert [ "*.paseourbano.com" ];
    "twozeroeightthree.com" = cloudflareCert [ "*.twozeroeightthree.com" ];
    "zulmarecchini.com" = cloudflareCert [ "*.zulmarecchini.com" ];
  };
  services.nginx.virtualHosts = builtins.listToAttrs (map (domain: { 
    name = "www.${domain}"; 
    value = {
      useACMEHost = domain;
      forceSSL = true;
      locations."/".return = "301 https://${domain}$request_uri";
    }; 
  }) [ 
    "bufanda.cc"
    "claudiogabis.com"
    "colchon.review"
    "delunesadomingo.es"
    "elvivero.es"
    "enelpetirrojo.com"
    "equisoain.com"
    "haztecaso.com"
    "paseourbano.com"
    "twozeroeightthree.com"
    "zulmarecchini.com"
  ]);
}
