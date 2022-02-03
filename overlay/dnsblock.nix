{ pkgs, ...}:
let
  message = import ./message.nix { pkgs = pkgs; };
in
pkgs.writeScriptBin "dnsblock"
''
  #!${pkgs.runtimeShell}

  ssh_cmd="${pkgs.openssh}/bin/ssh root@192.168.1.1"
  dnsmasq="/etc/init.d/dnsmasq reload"
  enabled=$($ssh_cmd "find '/etc/hosts' 2> /dev/null")

  if [[ -n $enabled ]]; then
      ${message}/bin/message 1 "DNS BLOCK DISABLED"
      $ssh_cmd "mv /etc/hosts /etc/hosts.bak; $dnsmasq"
  else
      "DNS BLOCK ENABLED"
      ${message}/bin/message 1 "DNS BLOCK ENABLED"
      $ssh_cmd "mv /etc/hosts.bak /etc/hosts; $dnsmasq"
  fi

''
