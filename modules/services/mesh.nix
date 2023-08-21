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
      hostSettings = { 
        lambda = {
          addresses = [ ];
          subnets = [ { address = "10.0.0.1"; } ];
          rsaPublicKey = ''
            -----BEGIN RSA PUBLIC KEY-----
            MIICCgKCAgEA1jd6FRtcohz95Gk5Iceh6l7fbFDYgN445CT/+RbVl2TgQu4nK/HJ
            +dQIOtcrxG99yfyQPg5zksar4gJXpteupJ1KmHs0RyD/0ZyUOcGHrU2C0dVSHX6w
            ktOEoaZRO7C0pqR1OSsZsYwUmrO+XavV8PMoh0slcIWEVcVDZ22Xfe9wVvrI/1gB
            z8uX4zv8kh9HSpmrSnUlaQvIAOZ/A60WxYHhPweCpvwWZNjKYQ026ssE/bwXXBET
            uOlim+0DtRYJY04Z3qERoWq/VwVYB5BagqDdFduiE+jPXHT/4Q/VD9NCivPtAPRk
            +oY5USoVb8axiy65OIpAnsi86d3dZgUHfIFcM8PHxKz/PhPeTCeUmxybgDa+L2WF
            ZI/hj8MYUdSOOoF2DT04Ua8HYOVDqDUFRZTGPP9Sk/Q5zJN9iBeUlhzjZ/jheE1C
            eCyo3YhK9hvOy1aEeaRGgG9zKxO3cuSaAJdgwi+05biSViAniyGeYg+y6gAIOob3
            Qh7orW+wADuy9g9b6bAGW8HLa5rWUchyuqk/j6V0db5rwNTVkJOBcl2B7Ol4CnJB
            jqi6SAThFQM1jJy7NZe4H9Do701cfCO6vpB7KyKksrxQfFJBB45n0dxFt/V6Z4pI
            uj36F4x2VjVj8nhmlxJMMO6hDtuiPsOLJUC8kY5C0eU9vIaBbxgGlqkCAwEAAQ==
            -----END RSA PUBLIC KEY-----
          '';
          settings.Ed25519PublicKey = "nNqnvCbJyny153B7P3sW108RrnJ0rpOXDuttYIqfb+M";
        };
        nas = {
          addresses = [ ];
          subnets = [ { address = "10.0.0.2"; } ];
          rsaPublicKey = ''
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
          settings.Ed25519PublicKey = "6+O8yM8bm6UK+/BvZ/67DBr1Fw0hn+mm++Dh3aFxYoK";
        };
      };
    };
  };
}
