{ config, pkgs, ... }:

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
    profileExtra = ''
      # each local bash module should be a function and will be imported
      # into the current session for use
      for bash_module in ~/.local/lib/bash/*
      do
        source $bash_module
      done
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
