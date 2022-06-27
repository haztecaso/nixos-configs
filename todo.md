## To do

- Migración a modules/home
- instalar statping
- reemplazar thumbor por imgproxy
- Manage copy of ssh keys
- Improve secrets management.
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


#### Finish migration from old config

- retroarchWithCores
- music: beets config
- mail module
- pandoc-templates

### Ideas random

- ssh over tor: https://mdleom.com/blog/2020/03/16/tor-hidden-onion-nixos/
