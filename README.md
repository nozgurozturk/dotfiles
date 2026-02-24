# dotfiles

Personal macOS development environment setup.

## What this does

- Installs Zerobrew (if missing)
- Installs packages and apps from `Brewfile`
- Installs tmux TPM and a few zsh plugins
- Symlinks dotfiles into place
- Applies macOS defaults (keyboard, Finder, Dock, etc.)

## Requirements

- macOS (Apple Silicon or Intel)
- `git` and `curl`
- Admin privileges (the script uses `sudo` for macOS defaults)

## Install

### One-liner (latest release)

```sh
curl -fsSL https://codeberg.org/noo/dotfiles/raw/branch/main/install.sh | bash
```

### From source

```sh
git clone https://codeberg.org/noo/dotfiles.git
cd dotfiles
./install.sh
```

### Version pinning

```sh
DOTFILES_VERSION=vX.Y.Z ./install.sh
```

## Tools & apps

Installed via `Brewfile`:

### Homebrew packages

- asyncapi — AsyncAPI CLI
- awscli — AWS CLI
- btop — system monitor
- buf — Protobuf tooling
- crush — SSH/terminal UI
- curl — HTTP client
- d2 — diagramming tool
- deno — JS/TS runtime
- fd — fast file finder
- fzf — fuzzy finder
- gh — GitHub CLI
- git — version control
- git-delta — nicer diffs
- git-crypt — repo encryption
- gnupg — OpenPGP tools
- go — Go toolchain
- golangci-lint — Go linter
- golang-migrate — DB migrations
- goreleaser — release automation
- graphviz — graph renderer
- helm — Kubernetes package manager
- jo — JSON generator
- jq — JSON processor
- k9s — Kubernetes TUI
- kubectl — Kubernetes CLI
- kubectx — Kubernetes context switcher
- kubeseal — Sealed Secrets
- luarocks — Lua packages
- mole — dev tool
- n — Node version manager
- neovim — editor
- ollama — local LLM runner
- pnpm — Node package manager
- protobuf — Protocol Buffers
- python@3.14 — Python runtime
- ripgrep — fast search
- rustup — Rust toolchain
- sqlc — SQL to code
- starship — shell prompt
- terraform — IaC tool
- tlrc — tldr client
- tmux — terminal multiplexer
- tree — directory tree
- uv — Python package manager
- vim — editor
- websocat — WebSocket CLI
- yq — YAML processor
- zk — Zettelkasten tool

### Casks

- codex — OpenAI Codex app
- floorp — web browser
- font-jetbrains-mono — font
- font-jetbrains-mono-nerd-font — patched font
- ghostty — terminal emulator
- orbstack — containers + VMs

## Zsh plugins

Installed into `~/.zsh`:

- zsh-autosuggestions
- zsh-syntax-highlighting
- zsh-history-substring-search

## tmux

- Installs TPM into `~/.tmux/plugins/tpm`

## Symlinks

The installer links these into `$HOME`:

- `.config/*` → `${XDG_CONFIG_HOME:-$HOME/.config}`
- `.local/*` → `$HOME/.local`
- `.gitconfig`
- `.gitignore`
- `.ripgreprc`
- `.zshrc`

### Manual Steps

**GPG Key**

Follow the instructions provided in [this link](https://docs.codeberg.org/security/gpg-key/), then execute the command below. This will create a macOS pinentry helper, allowing GPG to prompt for your passphrase in GUI applications and utilize the macOS Keychain for securely storing passphrases.

```bash
echo "pinentry-program $(which pinentry-mac)" >> ~/.gnupg/gpg-agent.conf
killall gpg-agent
```
**SSH Key**

Follow the instructions provided in [this link](https://docs.codeberg.org/security/ssh-key/)

## Uninstall

To uninstall and revert changes made by this dotfiles installer, run the included uninstall script:

```bash
./uninstall.sh
```

## Notes

- This setup is macOS-only.
- Re-running the installer is safe; it will re-link files and re-apply defaults.
