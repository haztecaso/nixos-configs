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
  security.acme.certs = {
    "bufanda.cc" = cloudflareCert [ "*.bufanda.cc" "*.dev.bufanda.cc" ];
    "claudiogabis.com" = cloudflareCert [ "*.claudiogabis.com" ];
    "colchon.review" = cloudflareCert [ "*.colchon.review" ];
    "delunesadomingo.es" = cloudflareCert [ "*.delunesadomingo.es" ];
    "elvivero.es" = cloudflareCert [ "*.elvivero.es" ];
    "enelpetirrojo.com" = cloudflareCert [ "*.enelpetirrojo.com" ];
    "haztecaso.com" = cloudflareCert [ "*.haztecaso.com" ];
    "paseourbano.com" = cloudflareCert [ "*.paseourbano.com" ];
    "twozeroeightthree.com" = cloudflareCert [ "*.twozeroeightthree.com" ];
    "zulmarecchini.com" = cloudflareCert [ "*.zulmarecchini.com" ];
  };
}
