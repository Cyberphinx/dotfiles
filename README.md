### My configuration files

This is the configuration files for my development environment on fedora 40 Run
the ./install.sh to install all required dependencies for setting up the
terminal, code editor, and language servers.

### install.sh

- This bash script automatically installs all required dependencies on Fedora 40

### alacritty

- version: 0.14 Terminal emulator that uses GPU

### conky

- a system monitoring widget and theme

### efm-langserver

- A nice third party language server that is a good extension of the default
  ones in both helix and neovim.

### fish

- version: 3.7.0 A user-friendly shell (an alternative to bash)

### helix

- version: 23.10 Code editor with language servers and inlay hints working out
  of the box

### nvim

- version: 0.10 Neovim A beautiful and highly configurable code editor (this is
  my backup editor for helix)

### omf

- version: 7 Oh my fish, package manager for fish shell. Especially useful for
  using nvm with fish shell.

### phpactor

- version: 2023.12.03.0 phpactor json configuration that enables Inlay Hints!

### zellij

- version: 0.40 Terminal multiplexer that is performant and user-friendly

### bashrc

- Bash terminal configuration and PATH

### VPN files .ovpn

- After added the vpn file via
  `nmcli connection import type openvpn file /path/to/your/file.ovpn`, you need
  to configure the username and password to a file saved at
  /etc/NetworkManager/system-connections:

```
nmcli connection modify <connection-name> +vpn.data "connection-type=password-tls, username=YOUR_USERNAME" vpn.user-name YOUR_USERNAME +vpn.secrets "password=YOUR_PASSWORD"
```

- And then you must re-login/restart pc for the new vpn to take effect
