let keys = import ../ssh-keys.nix;
in with keys; {
  "jobo_bot.age".publicKeys = [ skolem host_lambda ];
  "remadbot.age".publicKeys = [ skolem host_lambda ];
  "moodle-dl.age".publicKeys = [ skolem host_lambda ];
  "cloudflare.age".publicKeys = [ skolem host_lambda ];
  "thumbor.age".publicKeys = [ skolem host_lambda ];
  "users/skolem.age".publicKeys = [ skolem ];
  "users/root.age".publicKeys = [ skolem ];
  "grafana-cloud-prometheus-endpoint.age".publicKeys = [ skolem_elbrus skolem_nas host_nas ];
}
