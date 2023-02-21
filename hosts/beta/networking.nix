{ config, pkgs, ... }: {
  networking = {
    firewall = {
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };

    # wg-quick.interfaces = {
    #   wg0 = {
    #     address = [ "10.0.0.2/24" ];
       
    #     privateKeyFile = "/etc/wireguard/privatekey";
       
    #     peers = [
    #       {
    #         publicKey = "DMKv3Fn1gXvjPGWp4Ahls7ILi990e1VaMkb76b6KKyk=";
    #         allowedIPs = [ "10.100.0.1" ];
    #         endpoint = "185.215.164.95:51820"; 
    #         persistentKeepalive = 25;
    #       }
    #     ];
    #   };
    # };
  };
}
