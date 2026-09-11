This is the personal system configuration of @ucodery

Nix is used as the primary package manager/ deployment method.
However, there is a tiny bit of work to bootstrap a new system, after which nix can entirely take over.

1. Install Nix from [Determinate Systems](https://zero-to-nix.com/start/install)
    * `curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install`
2. Clone [This Repo](https://github.com/ucodery/nix)
    * `nix run "nixpkgs#git" -- clone https://github.com/ucodery/nix.git ~/nix`
3. Bootstrap [Home-Manager](https://nix-community.github.io/home-manager/index.xhtml)
    * `nix run ~/nix/.config/home-manager -- switch --flake ~/nix/.config/home-manager#jeremyp`
    * afterwards `home-manager switch --flake ~/nix/.config/home-manager#jeremyp` is on PATH,
      or `cp pre-commit post-commit .git/hooks/` to switch on every commit

## Replacing Apple's /usr/bin

macOS ships `/usr/bin` with ~95 Xcode "tool shims" (`cc`, `git`, `python3`,
`make`, ...) that either prompt to install Xcode or fail. Nothing can remove
them, so home-manager builds `~/.local/usr/bin` on every switch: a copy of
`/usr/bin` as symlinks, minus the shims (see `usrBinWithoutXcodeShims` in
`home.nix`). Then that directory replaces `/usr/bin` on `PATH`.

Home-manager can only do that for its own shells: `.profile` rewrites `PATH`
for login shells. Getting the replacement everywhere needs two system-level
edits, which require `sudo` and so are not managed here. The activation script
warns when the first one is missing.

1. **Every login shell, including zsh and scripts run with `-l`.**
   `path_helper` builds the initial `PATH` from `/etc/paths`, so replace the
   `/usr/bin` line there with the mirror (`/etc/paths.d` can only add):

   ```
   sudo sed -i.bak "s|^/usr/bin$|$HOME/.local/usr/bin|" /etc/paths
   ```

   macOS updates may restore this file; the switch warning will say so.

2. **Everything launchd starts (GUI apps and whatever they spawn).**
   Those get launchd's default `PATH`, `/usr/bin:/bin:/usr/sbin:/sbin`. It
   matters even for terminals: `path_helper` keeps whatever `PATH` the shell
   inherited and appends it after `/etc/paths`, so `/usr/bin` survives at the
   end and every shim the mirror omits is found there. The switch warns while
   this is the case. Set the user domain's `PATH` once (takes effect after a
   reboot):

   ```
   sudo launchctl config user path "$(tr '\n' : < /etc/paths)"
   ```

Non-interactive shells started from a shell inherit `PATH` and need nothing.
