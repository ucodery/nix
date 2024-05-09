local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = vim.fn.system {
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  }
  vim.cmd [[packadd packer.nvim]]
end

local packer = require 'packer'

packer.init {
  display = {
    open_fn = function()
      return require('packer.util').float { border = 'rounded' }
    end,
  },
}

packer.startup(function(use)
  use { 'wbthomason/packer.nvim' } -- Have packer manage itself
  use { 'nvim-lua/popup.nvim' } -- An implementation of the Popup API from vim in Neovim
  use { 'nvim-lua/plenary.nvim' } -- Useful lua functions used ny lots of plugins

  use { 'theacodes/witchhazel' } -- colorscheme
  use {
    'xiyaowong/transparent.nvim',
    run = ':TransparentEnable'
  }
  use { 'goolord/alpha-nvim' }
  use { 'moll/vim-bbye' }
  use { 'tpope/vim-sleuth' }

  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'L3MON4D3/LuaSnip', --the snipit manager
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
    },
  } -- Autocomplete

  use {
    'neovim/nvim-lspconfig',
    --opt = false,
    --after = "nvim-lsp-installer"
  }
  use {
    'williamboman/nvim-lsp-installer',
    --requires = "neovim/nvim-lspconfig"
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  }
  use { 'jose-elias-alvarez/null-ls.nvim' }

  use {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use { 'vim-test/vim-test' }


  -- look into these
  -- use { 'tpope/vim-commentary' }
  -- use({ "AndrewRadev/splitjoin.vim" })
  -- use { "vim-test/vim-test" }

  if PACKER_BOOTSTRAP then
    require('packer').sync()
  end
end)
