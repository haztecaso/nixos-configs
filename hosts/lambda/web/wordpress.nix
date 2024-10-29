{ config, lib, pkgs, ... }:
{
  services.custom.web.wordpress.sites = {
    bicibufanda = { 
      appName = "bicibufanda"; 
      host = "bici.bufanda.cc"; 
      ACMEHost = "bufanda.cc"; 
      max_upload_filesize = 200; 
    };
    claudiogabis = { 
      appName = "wpclau"; 
      host = "claudiogabis.com"; 
      max_upload_filesize = 400; 
    };
    colchonreview = { 
      appName = "wpcolchon"; 
      host = "colchon.review"; 
      root = "/var/www/colchon.review"; 
      max_upload_filesize = 1024; 
    };
    delunesadomingo = { 
      appName = "wpleandro"; 
      host = "delunesadomingo.es"; 
    };
    elvivero = { 
      appName = "wpelvivero"; 
      host = "elvivero.es"; 
    };
    equisoain = { 
      appName = "wpequisoain"; 
      host = "equisoain.com"; 
    };
    olaborathorio = { 
      appName = "wpolaborathorio"; 
      host = "olaborathorio.elvivero.es"; 
      ACMEHost = "elvivero.es"; 
    };
    wplay = { 
      appName = "wplay"; 
      host = "wplay.haztecaso.com"; 
      ACMEHost = "haztecaso.com"; 
    };
    zulmarecchini = { 
      appName = "wpzulma"; 
      host = "zulmarecchini.com"; 
      max_upload_filesize = 350; 
    };
  };
}
