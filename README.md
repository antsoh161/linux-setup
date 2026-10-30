# linux-setup

## Layout

- `docker/` — Ubuntu and Arch containers for testing `setup.sh`
- `packages/packages.csv` — `name,apt,pacman` rows consumed by `scripts/install-packages.sh`
- `repos/repos.txt` — `name|url|build_cmd|install_cmd` rows consumed by `scripts/build-from-source.sh`
- `versions.env` — `name=tag` pins looked up by repo name in `scripts/build-from-source.sh`. 
- `scripts/install-packages.sh` — installs the apt/pacman column from `packages.csv`
- `scripts/build-from-source.sh` — asks per repo, then clones/fetches each confirmed repo in `repos.txt` into `$HOME/src`, checks out the tag pinned in `versions.env`, then runs its `build_cmd`/`install_cmd`.
- `scripts/setup-dotfiles.sh` — clones the bare dotfiles repo into `~/.dotfiles` and checks it out into `$HOME`, backing up any conflicting files into `~/.dotfiles-backup`
- `scripts/setup-nvim-config.sh` — clones `antsoh161/nvim` into `$XDG_CONFIG_HOME/nvim`
- `scripts/setup-tpm.sh` — clones `tmux-plugins/tpm` into `$XDG_CONFIG_HOME/tmux/plugins/tpm`.
- `scripts/setup-nvm.sh` — clones `nvm-sh/nvm` into `$NVM_DIR` (default `~/.nvm`) at the tag pinned in `versions.env`, then runs `nvm install --lts`.
- `setup.sh` — runs the six steps above in order

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
