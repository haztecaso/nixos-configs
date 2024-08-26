{ config, lib, pkgs, ... }:
{
  services.custom.web.wordpress.sites = {
    bicibufanda = { appName = "bicibufanda"; domain = "bufanda.cc"; subdomain = "bici"; max_upload_filesize = 200; };
    claudiogabis = { appName = "wpclau"; domain = "claudiogabis.com"; max_upload_filesize = 400; };
    colchonreview = { appName = "wpcolchon"; domain = "colchon.review"; max_upload_filesize = 1024; };
    delunesadomingo = { appName = "wpleandro"; domain = "delunesadomingo.es"; };
    elvivero = { appName = "wpelvivero"; domain = "elvivero.es"; };
    equisoain = { appName = "wpequisoain"; domain = "equisoain.com"; };
    olaborathorio = { appName = "wpolaborathorio"; domain = "elvivero.es"; subdomain = "olaborathorio"; };
    wplay = { appName = "wplay"; domain = "haztecaso.com"; subdomain = "wplay"; };
    zulmarecchini = { appName = "wpzulma"; domain = "zulmarecchini.com"; max_upload_filesize = 350; };
  };
}
