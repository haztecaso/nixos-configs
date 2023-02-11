{ config, pkgs, ... }: {
  networking = {
    firewall = {
      allowedTCPPorts = [];
      allowedUDPPorts = [ 
        51820 # wireguard port
      ];
    };

    wireguard.interfaces = {
      wg0 = {
        # Determines the IP address and subnet of the client's end of the tunnel interface.
        ips = [ "10.100.0.2/24" ];
        listenPort = 51820;
       
        # Path to the private key file.
        privateKeyFile = "/etc/wireguard/privatekey";
       
        peers = [
          {
            publicKey = "DMKv3Fn1gXvjPGWp4Ahls7ILi990e1VaMkb76b6KKyk=";
            # Forward all the traffic via VPN.
            allowedIPs = [ "0.0.0.0/0" ];
            # Or forward only particular subnets
            #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];
       
            # Set this to the server IP and port.
            endpoint = "{server ip}:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577
       
            # Send keepalives every 25 seconds. Important to keep NAT tables alive.
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };
}
