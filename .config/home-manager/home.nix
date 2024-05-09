{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jeremyp";
  home.homeDirectory = "/Users/jeremyp";

  # Configuration compatibility version. != running home-manager version
  home.stateVersion = "23.11"; # Please read the documentation before changing.

  home.packages = [
    # Terminal
    pkgs.alacritty
    pkgs.bront_fonts
    pkgs.bash
    pkgs.nerdfonts

    # Shell
    pkgs.bash-completion
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
    pkgs.gcc
    pkgs.git
    pkgs.jq
    pkgs.lsd
    pkgs.nix-bash-completions
    pkgs.ripgrep
    pkgs.starship

    # Editor
    pkgs.lua-language-server
    pkgs.neovim
    pkgs.nodejs
    pkgs.nodePackages.pyright
    pkgs.nodePackages.vim-language-server
    pkgs.tree-sitter

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
    ".config/home-manager/flake.nix".source = ./flake.nix;
    ".config/home-manager/home.nix".source = ./home.nix;
    ".config/starship.toml".source = ../starship.toml;
    ".config/nvim/init.lua".source = ../nvim/init.lua;
    ".config/nvim/lua/me/autocmds.lua".source = ../nvim/lua/me/autocmds.lua;
    ".config/nvim/lua/me/keymaps.lua".source = ../nvim/lua/me/keymaps.lua;
    ".config/nvim/lua/me/colors.lua".source = ../nvim/lua/me/colors.lua;
    ".config/nvim/lua/me/lspconfig.lua".source = ../nvim/lua/me/lspconfig.lua;
    ".config/nvim/lua/me/telescope.lua".source = ../nvim/lua/me/telescope.lua;
    ".config/nvim/lua/me/alpha.lua".source = ../nvim/lua/me/alpha.lua;
    ".config/nvim/lua/me/plugins.lua".source = ../nvim/lua/me/plugins.lua;
    ".config/nvim/lua/me/lsp.lua".source = ../nvim/lua/me/lsp.lua;
    ".config/nvim/lua/me/global-options.lua".source = ../nvim/lua/me/global-options.lua;
    ".config/nvim/lua/me/cmp.lua".source = ../nvim/lua/me/cmp.lua;
    ".config/nvim/lua/me/treesitter.lua".source = ../nvim/lua/me/treesitter.lua;
    ".config/nvim/lua/me/null-ls.lua".source = ../nvim/lua/me/null-ls.lua;
    ".config/nvim/lua/me/transparent.lua".source = ../nvim/lua/me/transparent.lua;
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
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
