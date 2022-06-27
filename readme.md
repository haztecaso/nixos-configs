# Nix configs

## Hosts

### lambda

VPS for services and web hosting.

#### Services

- [bitwarden server (vaultwarden)](https://bw.haztecaso.com)
- [matomo analytics](https://matomo.haztecaso.com)
- [thumbor image thumbnailer](https://img.haztecaso.com)
- [vscode web](https://code.haztecaso.com)
- [gitea](https://git.haztecaso.com)

#### Webs

- [haztecaso.com](https://haztecaso.com)
- [elvivero.es](https://elvivero.es)
- [zulmarecchini.com](https://zulmarecchini.com)

Future:

- twozeroeightthree.com: jekyll

### beta

Thinkpad x270. Personal machine.

### galois

Macbook Pro mid 2012. Personal machine.


## Tips

- nix flake update single input:
```bash
nix flake lock --update-input nixpkgs
```

- nginx webserver logs are managed with journalctl. For example:
```bash
journalctl -f --since today -u nginx
```


## References

- Module organization based on [chvp/nixos-config](https://github.com/chvp/nixos-config/)
