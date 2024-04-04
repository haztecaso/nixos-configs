{ config, lib, pkgs, ... }:
{
  custom.mesh.nodes = {
    lambda = {
      publicIp = "185.215.164.95";
      ip = "10.0.0.1";
      Ed25519PublicKey = "nNqnvCbJyny153B7P3sW108RrnJ0rpOXDuttYIqfb+M";
      rsaPublicKey = ''
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
      '';
    };
    nas = {
      ip = "10.0.0.2";
      connectTo = "lambda";
      Ed25519PublicKey = "6+O8yM8bm6UK+/BvZ/67DBr1Fw0hn+mm++Dh3aFxYoK";
      rsaPublicKey = ''
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
      '';
    };
    # deambulante = { # TODO
    #    ip = "10.0.0.4";
    #    connectTo = "lambda";
    #    Ed25519PublicKey = "";
    #    rsaPublicKey = ''
    #    '';
    #  };
    elbrus = {
      ip = "10.0.0.3";
      connectTo = "lambda";
      Ed25519PublicKey = "wl8bacoiy20G1QVhaUP16An2vcDVdUZ5Fa8CZ9TxfPN";
      rsaPublicKey = ''
        MIICCgKCAgEAl9WCDrUCUvAnQPfeGmfcgXRiAUgX8APK0jrvdTTuOm+WrIlH6X0h
        dBRk0eFQs4daaXw5chuPabDZZWe3yaINiMJmUm+R1rMA9QrsnrlqBY/k+iX0cYl+
        0tWXO+OktDlfTczct+cFQaQ1EM/7C9B7EprODZx6S/ozEC9aFiS7DajVog+D74Mb
        etflyTti/pRoGPauMakae5ZZEfmHmwrVnmODSSg90YLETQJqCLpCycZrSSJrhHuy
        z6KL3OzMHUXTSpR4TqS/gPopa24U7YUgq1/9yDCazEcDUY3ivc/SEh8CGYwLw4F7
        G8r0vF2bLsAhyrfG6CiTo840z7zv4dt8QwC96VMS6tjkkp2V76XWg+0jySBjNKpz
        eGcs/+Zn/8lq7qOCim7soDWJafaVDSmw/jJTv6rv1OxP+ci01laI8sIYRiTc80BK
        LBj92yUKYblPUItByvOJGrbYuKUNqOOP6szJ8Ew/j5KBBSP76V1CfRkagXFkHO0o
        jQKW5opbixF1TWwJ7N+SJZogSEHrAERDzFrupT9KL7YvhpD6qUuR4lXHV2nxOEJU
        TmVykm7Hr5wAHt+kPNP6lTwrYnD2GHMgzClChcvuDU0NTZ8J5PjDLnprbklQpwUH
        ixP6Min+TpcfDPGex8yXTP2WWy0+Tjpt6tKtbaEb7Wf9m10QSj2EHtUCAwEAAQ==
      '';
    };
  };
}
