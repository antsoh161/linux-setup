# linux-setup

## Layout

- `docker/` — Ubuntu and Arch containers for testing `setup.sh` without touching a real machine.
- `packages/packages.csv` — `name,apt,pacman` rows consumed by `scripts/install-packages.sh`. Covers baseline tools plus the build dependencies for neovim and noctalia-shell.
- `repos/repos.txt` — `name|url|build_cmd|install_cmd` rows consumed by `scripts/build-from-source.sh` (currently: neovim, noctalia-shell).
- `versions.env` — `name=tag` pins looked up by repo name in `scripts/build-from-source.sh`. Edit this file to bump a version; nothing auto-updates it.
- `scripts/install-packages.sh` — installs the apt/pacman column from `packages.csv` for the detected distro.
- `scripts/build-from-source.sh` — clones/fetches each repo in `repos.txt` into `$HOME/src`, checks out the tag pinned in `versions.env` (if any), then runs its `build_cmd`/`install_cmd`.
- `scripts/setup-dotfiles.sh` — clones the bare dotfiles repo into `~/.dotfiles` and checks it out into `$HOME`, backing up any conflicting files into `~/.dotfiles-backup`. Contains no secrets; those are set up manually afterwards.
- `scripts/setup-nvim-config.sh` — clones `antsoh161/nvim` into `$XDG_CONFIG_HOME/nvim` (kept separate from the dotfiles repo on purpose).
- `setup.sh` — runs the four steps above in order, asking a yes/no before each phase.

## Testing in Docker

```
cd docker
docker compose build
docker compose run --rm ubuntu-test
docker compose run --rm arch-test
```

Inside a container:

```
./setup.sh
```
