{ config, lib, pkgs, ... }:
{
  services.custom.web.wordpress.sites = {
    wplay = {
      appName = "wplay";
      domain = "haztecaso.com";
      subdomain = "wplay";
      root = "/var/www/wplay";
    };
    elvivero = {
      appName = "wpelvivero";
      domain = "elvivero.es";
      root = "/var/www/elvivero.es";
    };
    bicibufanda = {
      appName = "bicibufanda";
      domain = "bufanda.cc";
      subdomain = "bici";
      root = "/var/www/bici.bufanda.cc";
      max_upload_filesize = 200;
    };
    claudiogabis = {
      appName = "wpclau";
      domain = "claudiogabis.com";
      root = "/var/www/claudiogabis.com";
      max_upload_filesize = 400;
    };
    delunesadomingo = {
      appName = "wpleandro";
      domain = "delunesadomingo.es";
      root = "/var/www/wpleandro/";
    };
    colchonreview = {
      appName = "wpcolchon";
      domain = "colchon.review";
      max_upload_filesize = 1024;
    };
    equisoain = {
      appName = "wpequisoain";
      domain = "equisoain.com";
    };
    olaborathorio = {
      appName = "wpolaborathorio";
      domain = "elvivero.es";
      subdomain = "olaborathorio";
      root = "/var/www/olaborathorio";
    };
    zulmarecchini = {
      appName = "wpzulma";
      domain = "zulmarecchini.com";
      max_upload_filesize = 350;
    };
  };
}
