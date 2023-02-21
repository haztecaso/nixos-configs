{ config, pkgs, ... }: {
  networking = {
    firewall = {
      allowedTCPPorts = [ 
        8888 
      ];
      allowedUDPPorts = [ 
        51820 # wireguard port
      ];
    };

    # nat = {
    #   enable = true;
    #   externalInterface = "ens18";
    #   internalInterfaces = [ "wg0" ];
    # };

    # wg-quick.interfaces = {
    #   # "wg0" is the network interface name. You can name the interface arbitrarily.
    #   wg0 = {
    #     # Determines the IP address and subnet of the server's end of the tunnel interface.
    #     address = [ "10.100.0.1/24" ];
    #     listenPort = 51820;

    #     privateKeyFile = "/etc/wireguard/privatekey";

    #     peers = [
    #       {
    #         publicKey = "HuqXOBQ+4oNaHpC+5f/hOGIXxKiEQhzIYFnmhSFnj3E=";
    #         allowedIPs = [ "10.100.0.2/32" ];
    #       }
    #       {
    #         publicKey = "SylcrvoHc/U34+j5E+bMs7dDHX9sgBS1tkywTObHGDQ=";
    #         allowedIPs = [ "10.100.0.3/32" ];
    #       }
    #     ];
    #   };
    # };
  };
}
