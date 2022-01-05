let
  keys = import ./ssh-keys.nix;
in
with keys; {
  "hosts/nixpi/jobo_bot.age".publicKeys = [ skolem id_rsa_nixpi host_nixpi ];
}
