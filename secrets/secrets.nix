let
  keys = import ../ssh-keys.nix;
in
with keys; {
  "jobo_bot.age".publicKeys = [ skolem id_rsa_nixpi host_nixpi host_lambda ];
  "moodle-dl.age".publicKeys = [ skolem id_rsa_nixpi host_nixpi host_lambda ];
  "cloudflare.age".publicKeys = [ skolem host_lambda ];
  "thumbor.age".publicKeys = [ skolem host_lambda ];
  "users/skolem.age".publicKeys = hosts ++ [ skolem ];
  "users/root.age".publicKeys = hosts ++ [ skolem ];
}
