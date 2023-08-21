{ config, lib, pkgs, ... }: 
{
  config = {
    networking = {
      firewall = {
        allowedTCPPorts = [ 655 ];
        allowedUDPPorts = [ 655 ];
      };
      interfaces."tinc.mesh".ipv4 = {
        addresses = [ { address = "10.0.0.0";    prefixLength = 24; } ];
        routes    = [ { address = "192.168.0.0"; prefixLength = 24; via = "10.0.0.2"; } ];
      };
    };
    services.tinc.networks.mesh = {
      name = config.networking.hostName;
      hosts = { 
        elbrus = ''
          Ed25519PublicKey = 6+O8yM8bm6UK+/BvZ/67DBr1Fw0hn+mm++Dh3aFxYoK
          -----BEGIN RSA PUBLIC KEY-----
          MIICCgKCAgEApNowJQQb5WekH09RK/jkNDTza9vbjyFJ5b2mTz2/hKXVYY1ZDK5H
          WWrdsY3fvf7iUAe1VrWGv6NSJ/rP/iclGPdRaDJoGaJppUDpw8uDHET5tkV1DC72
          SybJqvInqXljSxo0qyVgj2d1DVmdNnGNSj/h/KeDZXpJOezSoNgGvtnOuBytkdZZ
          35Jfy9AGuph7PFxFU28dZ/OXjP9psqmRXZ/DrCpF4NNj6FwkFl52dfJ9dP8Pwfkq
          LQ8kWITwVePCMUFXygi7bKjJkIYh6po+nsYb0vIPCswAlvGSfukRcH1wvd3YlZDL
          At0FnwEfakN6ICveWxUlsPLip4pw5tc4cp4gPGasISKMJqMTjSrk8x6jE/IU+Zom
          ynOFFfTZI9Fh+okP84kKSG51cj9Y9IrtKrYCq0VPWqy4r3UPQFlg7062rsWBcs1l
          4P/VWILIFLAq7XMm1jiGgdmfFqgo6n+KUX5C5RWy3QkO7JeoqX8YT7V57UwwdgSO
          h4baYUf+EHn5ve1GWymd4hNCmomWhliozN9058/IbcG3qfAMhXtaDoPLPpOV6MPA
          a1z2pUX804Uao/eKvkbFt5/3i5uGK53OPcV0dsB/inydqOWwtr8Av7cci76yldfj
          3qMSiUBbCmVXF1vD++goAkjO9rqreeHDOGCMYksL+alXYkftq3jDfMMCAwEAAQ==
          -----END RSA PUBLIC KEY-----
        '';
        lambda = ''
        '';
      };
    };
  };
}
