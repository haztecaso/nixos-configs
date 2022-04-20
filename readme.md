# Nix configs

## To do

- ssh over tor: https://mdleom.com/blog/2020/03/16/tor-hidden-onion-nixos/
- Manage copy of ssh keys
- Decide how to manage secrets:
  - [agenix](https://github.com/ryantm/agenix/)
    - Drawbacks
      - Only works for system configs, not home (Problem could be avoided by converting
        everything into system modules?)
    - Benefits
      - Uses ssh keys
      - Files decrypted on tmpfs
  - [git-crypt](https://www.agwa.name/projects/git-crypt)
    - Drawbacks
      - Need to use gpg or custom key
      - Plain files decrypted on machine
    - Benefits
      - Can encrypt full .nix files
- Fusionar con configs del portatil

## Tips

- nix flake update single input:
```bash
nix flake lock --update-input nixpkgs
```

- nginx webserver logs are managed with journalctl. For example:
```bash
journalctl -f --since today -u nginx
```

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

Future:

- zulmarecchini.com: indexhibit -> nodejs
- twozeroeightthree.com: jekyll

### beta

Thinkpad x270. Personal machine.

### galois

Macbook Pro mid 2012. Personal machine.

#### Migration todos

- retroarchWithCores
- music: beets config
- mail module
- pandoc-templates
- emacs
- money

## References

- Module organization based on [chvp/nixos-config](https://github.com/chvp/nixos-config/)
