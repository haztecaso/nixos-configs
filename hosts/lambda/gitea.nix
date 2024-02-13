{ config, lib, pkgs, ... }: {
  services.gitea = {
    enable = true;
    appName = "Gitea";
    settings = {
      server = {
        DOMAIN = "git.bufanda.cc";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 8003;
        ROOT_URL = "https://git.bufanda.cc/";
      };
      service = {
        DISABLE_REGISTRATION = true;
      };
      session = {
        COOKIE_SECURE = true;
      };
      security = {
        LOGIN_REMEMBER_DAYS = 14;
        MIN_PASSWORD_LENGTH = 12;
        PASSWORD_COMPLEXITY = "lower,upper,digit,spec";
        PASSWORD_CHECK_PWN = true;
      };
        
      mailer.ENABLED = false; 
      other = {
        SHOW_FOOTER_VERSION = false;
        SHOW_FOOTER_TEMPLATE_LOAD_TIME = false;
      };
    };
  };
}
