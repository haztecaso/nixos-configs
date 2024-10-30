{ config, lib, pkgs, ... }: {
  config = lib.mkIf config.custom.desktop.enable {
    home.packages = with pkgs; [
      # buku 
      keyutils
      bitwarden-cli
    ];
    programs.qutebrowser = {
      enable = true;
      package = pkgs.qutebrowser;
      settings = {
        content = {
          # headers.user_agent = "Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0";
          autoplay = false;
          pdfjs = false;
        };
      };
      searchEngines = {
        DEFAULT =
          "https://start.duckduckgo.com/?kae=d&kak=-1&kal=-1&kao=-1&kaq=-1&kp=-2&kz=1&kav=1&kn=-1&kk=-1&k1=-1&kaj=m&kay=b&kax=-1&kap=-1&kau=-1&ks=n&kw=w&ko=d&kg=g&k5=1&kt=v&km=l&q={}";
        a = "https://www.amazon.es/s?k={}";
        g = "https://duckduckgo.com/?q=g!%20{}";
        h = "https://hoogle.haskell.org/?hoogle={}";
        yt = "https://yewtu.be/search?q={}";
        ytt = "https://www.youtube.com/results?search_query={}";
        aw = "https://wiki.archlinux.org/index.php?search={}";
        w = "https://en.wikipedia.org/w/index.php?search={}";
        we = "https://es.wikipedia.org/w/index.php?search={}";
        nw = "https://wiki.nixos.org/index.php?search={}";
        wi = "https://it.wikipedia.org/w/index.php?search={}";
        nix = "https://search.nixos.org/packages?query={}";
        nixpkg = "https://search.nixos.org/packages?query={}";
        wikiloc = "https://es.wikiloc.com/wikiloc/map.do?q={}";
        map = "https://www.google.com/maps/search/{}";
        maps = "https://www.google.com/maps/search/{}";
        dockerhub = "https://hub.docker.com/search?q={}&type=image";
        gh = "https://github.com/search?q={}&type=repositories";
      };
      keyBindings = {
        normal = {
          J = "tab-prev";
          K = "tab-next";
          "<Alt-Shift-j>" = "tab-move -";
          "<Alt-Shift-k>" = "tab-move +";
          v = "spawn --userscript view_in_mpv";
          V = ''
            hint links spawn --detach mpv {hint-url} --pause --ytdl-format="bestvideo[height<=720]+bestaudio/best[height<=720]"'';
          "<Ctrl-Shift-v>" =
            "hint links spawn --detach mpv {hint-url} --pause --title=mpvSame";
          xs = "config-cycle statusbar.show always never";
          xt = "config-cycle tabs.show always never";
          xx =
            "config-cycle tabs.show always never;; config-cycle statusbar.show always never";
        };
      };
    };
    xdg.dataFile = {
      "qutebrowser/greasemonkey/autologin.js".text = ''
        // ==UserScript==
        // @name     Ucm autologin
        // @version  1
        // @include https://cvmdp.ucm.es/moodle/*
        // ==/UserScript==
        let btn = document.querySelector("#page-wrapper > nav > ul.nav.navbar-nav.ml-auto > li.nav-item.d-flex.align-items-center > div > span > a");
        if (btn && btn.innerText == "Log in"){ btn.click(); }
        btn = document.querySelector(".potentialidp > a.btn[title=\"Acceso con cuenta UCM\"]")
        if (btn){ btn.click(); }
      '';
      "qutebrowser/greasemonkey/nixoswiki.js".text = ''
        // ==UserScript==
        // @name        Redirect to wiki.nixos.org
        // @namespace   Violentmonkey Scripts
        // @match       https://nixos.wiki/*
        // @grant       none
        // @version     1.0
        // @author      Artoria2e5
        // @description the nixos.org people have a new wiki
        // @license     CC0-1.0
        // ==/UserScript==
        unsafeWindow.document.location.href = 'https://wiki.nixos.org' +
        unsafeWindow.document.location.href.replace(/^http?s:\/\/nixos\.wiki/, "")
      '';

      "qutebrowser/greasemonkey/yt-adskipper.js".text = ''
        // ==UserScript==
        // @name               No more youtube ads! - UPDATED
        // @name:zh-CN         隐藏youtube google广告
        // @namespace          Grenade Vault
        // @version            1.1.7
        // @description        Automatically Skips all youtube ads! with no waiting time.
        // @description        Stop Stealing my code yes please
        // @description:zh-CN  BF5 : This skips all adds instantly. Youtube.com
        // @author             高梨フブキ
        // @match              *://www.youtube.com/*
        // ==/UserScript==

        (function() {
            'use strict';
            var closeAd=function (){
                var css = '.video-ads .ad-container .adDisplay,#player-ads,.ytp-ad-module,.ytp-ad-image-overlay{ display: none!important; }',
                    head = document.head || document.getElementsByTagName('head')[0],
                    style = document.createElement('style');

                style.type = 'text/css';
                if (style.styleSheet){
                    style.styleSheet.cssText = css;
                } else {
                    style.appendChild(document.createTextNode(css));
                }

                head.appendChild(style);
            };
            var skipInt;
            var log=function(msg){
                // unsafeWindow.console.log (msg);
            };
            var skipAd=function(){
                //ytp-ad-preview-text
                //ytp-ad-skip-button
                var skipbtn=document.querySelector(".ytp-ad-skip-button.ytp-button")||document.querySelector(".videoAdUiSkipButton ");
                //var skipbtn=document.querySelector(".ytp-ad-skip-button ")||document.querySelector(".videoAdUiSkipButton ");
                if(skipbtn){
                    skipbtn=document.querySelector(".ytp-ad-skip-button.ytp-button")||document.querySelector(".videoAdUiSkipButton ");
                    log("skip");
                    skipbtn.click();
                    if(skipInt) {clearTimeout(skipInt);}
                    skipInt=setTimeout(skipAd,488);
                }else{
                    log("checking...");
                    if(skipInt) {clearTimeout(skipInt);}
                    skipInt=setTimeout(skipAd,488);
                }
            };

            closeAd();
            skipAd();

        })();
      '';
    };
  };
}
