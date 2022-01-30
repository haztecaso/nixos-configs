let
  keys = import ../ssh-keys.nix;
in
with keys; {
  "configs/jobo_bot.age".publicKeys = [ skolem id_rsa_nixpi host_nixpi ];
  "credentials/cloudflare.age".publicKeys = [ skolem host_lambda ];
  "credentials/thumbor.age".publicKeys = [ skolem host_lambda ];
  "passwords/users/skolem.age".publicKeys = hosts ++ [ skolem ];
  "passwords/users/root.age".publicKeys   = hosts ++ [ skolem ];
}
