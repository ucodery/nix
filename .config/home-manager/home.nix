{ config, lib, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jeremyp";
  home.homeDirectory = "/Users/jeremyp";

  # Configuration compatibility version. != running home-manager version
  home.stateVersion = "26.05"; # Please read the documentation before changing.

  home.packages = [
    # Terminal
    pkgs.alacritty
    pkgs.nerd-fonts.ubuntu-mono

    # Shell
    pkgs.bat
    pkgs.bat-extras.batdiff
    pkgs.bat-extras.batgrep
    pkgs.bat-extras.batman
    pkgs.bat-extras.batpipe
    pkgs.bat-extras.batwatch
    pkgs.bat-extras.prettybat
    pkgs.cloc
    pkgs.delta
    pkgs.dust
    pkgs.fd
    pkgs.git
    pkgs.jq
    pkgs.lsd
    pkgs.nix-bash-completions
    pkgs.postgresql
    pkgs.ripgrep
    pkgs.python313
    pkgs.shellcheck
    pkgs.shfmt

    # Editor (neovim itself is programs.neovim below)
    pkgs.black
    pkgs.lua-language-server
    pkgs.nodejs
    pkgs.prettier
    pkgs.pyright
    pkgs.rust-analyzer
    pkgs.stylua
    pkgs.vim-language-server

    # Presenting
    pkgs.asciinema
    pkgs.ffmpeg
    pkgs.figlet

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  home.file = {
    ".config/alacritty/alacritty.toml".source = ../alacritty/alacritty.toml;
    ".config/git/config".source = ../git/config;
    ".config/git/ignore".source = ../git/ignore;
    ".config/starship.toml".source = ../starship.toml;
    ".config/nvim/lua" = {
      source = ../nvim/lua;
      recursive = true;
    };
    ".config/ptpython/config.py".source = ../ptpython/config.py;
    ".config/python/config.py".source = ../python/config.py;
    ".inputrc".source = ../../.inputrc;
    ".ssh/config".source = ../../.ssh/config;
    "bin/edit".source = ../../bin/edit;
    "bin/gen".source = ../../bin/gen;
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jeremyp/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "edit here block --";
    VISUAL = "${config.home.sessionVariables.EDITOR}";
    CLICOLOR = "1";
    GIT_PAGER = "delta";
    SHELL = "${pkgs.bashInteractive}/bin/bash";
  };
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/bin"
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # ~/.local/usr/bin mirrors /usr/bin minus Xcode's command-line-tools shims
  # (cc, git, python3, make, ...), which fail or prompt to install Xcode when no
  # toolchain is present. profileExtra puts it on PATH in place of /usr/bin.
  # Rebuilt on every activation so it tracks the running macOS.
  home.activation.usrBinWithoutXcodeShims = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    target="$HOME/.local/usr/bin"
    run rm -rf "$target.new"
    run mkdir -p "$target.new"
    for src in /usr/bin/*; do
      if [ -f "$src" ] && ! /usr/bin/grep -q tool-shim "$src" 2>/dev/null; then
        run ln -s "$src" "$target.new/"
      fi
    done
    if [ -e "$target" ]; then
      run mv "$target" "$target.old"
    fi
    run mv "$target.new" "$target"
    run rm -rf "$target.old"
    if ! /usr/bin/grep -qxF "$target" /etc/paths; then
      printf >&2 '\e[1;33mwarning: /etc/paths does not list %s; see nix/README.md "Replacing Apple'"'"'s /usr/bin"\e[0m\n' "$target"
    fi
    # path_helper appends whatever PATH the terminal inherited, so /usr/bin
    # survives at the end until launchd's own PATH is set (README step 2)
    case ":$PATH:" in
      *:/usr/bin:*)
        printf >&2 '\e[1;33mwarning: /usr/bin is still on PATH (launchd default); see nix/README.md "Replacing Apple'"'"'s /usr/bin" step 2\e[0m\n'
        ;;
    esac
  '';

  programs.neovim = {
    enable = true;
    initLua = builtins.readFile ../nvim/init.lua;
    # Plugins are pinned by nixpkgs, replacing packer.
    plugins = with pkgs.vimPlugins; [
      plenary-nvim # Useful lua functions used by lots of plugins

      # colorscheme; not packaged in nixpkgs
      (pkgs.vimUtils.buildVimPlugin {
        pname = "witchhazel";
        version = "0-unstable-2025-08-27";
        src = pkgs.fetchFromGitHub {
          owner = "theacodes";
          repo = "witchhazel";
          rev = "e297207c4cf196d4049a1e7920a24a1b8e6a0541";
          hash = "sha256-lZwKuAYk0fGaR74moBBWshRhtFRizh+VWqwYKnPHWAg=";
        };
      })
      transparent-nvim
      alpha-nvim
      vim-bbye
      vim-sleuth

      # Autocomplete
      nvim-cmp
      luasnip # the snippet manager
      cmp_luasnip
      cmp-buffer
      cmp-cmdline
      cmp-nvim-lua
      cmp-path
      cmp-nvim-lsp

      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      telescope-nvim
      vim-test
    ];
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [ "ignoredups" "ignorespace" ];
    shellAliases = {
      g = "git";
      e = "edit";
      ls = "ls -hlAB --color=always";
      lsd = "lsd --total-size -lA";
      cat = "bat";
      man = "batman";
      pretty = "prettybat";
    };
    # .bashrc: every interactive shell, including nvim's :terminal and a bare `bash`
    initExtra = ''
      # each local bash module should be a function and will be imported
      # into the current session for use. They are private to this machine
      # and live outside this repo on purpose.
      for bash_module in ~/.local/lib/bash/*
      do
        [ -e "$bash_module" ] || continue # unmatched glob on a fresh machine
        source "$bash_module"
      done
    '';
    # .profile: login shells only; PATH is inherited by everything they start
    profileExtra = ''
      # be done with Apple's /usr/bin
      if [ -d /Users/jeremyp/.local/usr/bin ]; then
        PATH="$(echo :"$PATH": | sed -e 's/:\/usr\/bin:/:\/Users\/jeremyp\/.local\/usr\/bin:/' -e 's/^.//' -e 's/.$//')"
        export PATH
      fi
    '';
  };

  # Let direnv manage project-specific development environments
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };
}
