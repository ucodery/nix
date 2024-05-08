This is the personal system configuration of @ucodery

Nix is used as the primary package manager/ deployment method.
However, there is a tiny bit of work to bootstrap a new system, after which nix can entirely take over.

1. Install Nix from [Determinate Systems](https://zero-to-nix.com/start/install)
    * `curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install`
2. Clone [This Repo](https://github.com/ucoery/nix)
    * `nix run "nixpkgs#git" -- clone https://github.com/ucodery/nix.git ~/nix`
3. Bootstrap [Home-Manager](https://nix-community.github.io/home-manager/index.xhtml)
    * `nix run ~/nix/.config/home-manager/ -- switch -f ~/nix/.config/home-manager/home.nix`
