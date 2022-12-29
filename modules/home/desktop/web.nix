{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.custom.desktop.enable {
    home.packages = with pkgs; [ buku keyutils chromium ];
    programs.qutebrowser = {
      enable = true;
      settings = {
        content = {
          headers.user_agent = "Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0";
          autoplay = false;
          pdfjs = true;
        };
      };
      searchEngines = {
        DEFAULT = "https://start.duckduckgo.com/?kae=d&kak=-1&kal=-1&kao=-1&kaq=-1&kp=-2&kz=1&kav=1&kn=-1&kk=-1&k1=-1&kaj=m&kay=b&kax=-1&kap=-1&kau=-1&ks=n&kw=w&ko=d&kg=g&k5=1&kt=v&km=l&q={}";
        a = "https://www.amazon.es/s?k={}";
        g = "https://duckduckgo.com/?q=g!%20{}";
        h = "https://hoogle.haskell.org/?hoogle={}";
        yt = "https://yewtu.be/search?q={}";
        ytt = "https://www.youtube.com/results?search_query={}";
        aw = "https://wiki.archlinux.org/index.php?search={}";
        w = "https://en.wikipedia.org/w/index.php?search={}";
        we = "https://es.wikipedia.org/w/index.php?search={}";
        wi = "https://it.wikipedia.org/w/index.php?search={}";
        nix = "https://search.nixos.org/packages?query={}";
        nixpkg = "https://search.nixos.org/packages?query={}";
        wikiloc = "https://es.wikiloc.com/wikiloc/map.do?q={}";
        map = "https://www.google.com/maps/search/{}";
        maps = "https://www.google.com/maps/search/{}";
        dockerhub = "https://hub.docker.com/search?q={}&type=image";
      };
      keyBindings = {
        normal = {
          J = "tab-prev";
          K = "tab-next";
          "<Alt-Shift-j>" = "tab-move -";
          "<Alt-Shift-k>" = "tab-move +";
          V = "hint links spawn --detach mpv {hint-url} --pause --ytdl-format=\"bestvideo[height<=720]+bestaudio/best[height<=720]\"";
          "<Ctrl-Shift-v>" = "hint links spawn --detach mpv {hint-url} --pause --x11-name=mpvWorkspace9";
          xs = "config-cycle statusbar.show always never";
          xt = "config-cycle tabs.show always never";
          xx = "config-cycle tabs.show always never;; config-cycle statusbar.show always never";
          ",p" = "spawn --userscript /home/skolem/.nix-profile/bin/bwmenu";
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
      "qutebrowser/greasemonkey/invidious-redirect.js".text = ''
        // ==UserScript==
        // @description Redirects Youtube URLs to Invidio.us
        // @name Invidious Redirect
        // @namespace Backend
        // @downloadURL https://gist.githubusercontent.com/m0n5t3r/b7c13265152bd8c997f2d22afb4932e7/raw/invidious-redirect.userscript.js
        // @include http://www.youtube.com/*
        // @include https://www.youtube.com/*
        // @include https://consent.youtube.com/*
        // @version 1.6
        // @run-at document-start
        // @grant none
        // ==/UserScript==
        
        // prevent youtube content from loading; used to be a simple document.write, but 
        // * at first, greasemonkey complained
        // * then google started redirecting everything to consent.youtube.com, which has CSP that requires trusted types
        var newDoc = document.implementation.createHTMLDocument (""),
            h1 = document.createElement("h1");
        
        h1.innerText = "Redirecting, please wait...";
        newDoc.body.appendChild(h1);
        
        document.replaceChild (document.importNode(newDoc.documentElement, true), document.documentElement);
        document.close();
        
        const blacklist = [
            "invidious.xyz",
            "invidious.site",
            "invidiou.site",
            "invidious.reallyancient.tech",
        ];
        
        function find_parameter(name) {
            var result = null,
                tmp = [];
            location.search
                .substr(1)
                .split("&")
                .forEach((item) => {
                  tmp = item.split("=");
                  if (tmp[0] === name) result = decodeURIComponent(tmp[1]);
                });
            return result;
        }
        
        // pick a random instance with a good health record
        fetch("https://api.invidious.io/instances.json?sort_by=type,health").then((response) => {
            response.json().then((instances) => {
                var filtered, domain, idx, a;
        
                filtered = instances.filter((i) => {
                    var monitor = i[1].monitor;
                    var type = i[1].type;
        
                    if(type != "https") {
                      return false;
                    }
        
                    if(blacklist.includes(i[0])) {
                        return false;
                    }
        
                    if (monitor) {
                      return monitor.dailyRatios[0].ratio == "100.00";
                    }
        
                    // no monitoring data, let it through; might change later to filter in 2 steps and only
                    // let unknown status instances through if no health info has been found
                    return true;
                }).map((i) => { return i[0] });
        
                idx = Math.floor(Math.random() * filtered.length);
                domain = filtered[idx];
        
                if (/watch\?|channel|embed|shorts/.test(window.location.href) && window.location.href.indexOf('list=WL') < 0) {
                    a = window.location.href.replace(/www\.youtube\.com/, domain).replace('/shorts/', '/watch?v=');
                    window.location.replace(a);
                }
        
                // youtu.be and youtube.com seem to force-redirect to the consent thing lately, handle it here
                if(/consent\.youtube\.com/.test(window.location.href)) {
                    a = find_parameter('continue').replace(/www.youtube.com/, domain).replace('/shorts/', '/watch?v=');
                    window.location.replace(a);
                }
            });
        });
      '';
    };
  };
}
