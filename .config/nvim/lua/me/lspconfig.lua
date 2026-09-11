-- nvim-lspconfig now only ships server definitions (lsp/*.lua); neovim's own
-- vim.lsp.config / vim.lsp.enable configure and start them.
vim.lsp.config('pyright', {
  settings = {
    python = {},
  },
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua Neovim is using
        version = 'LuaJIT',
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          vim.fn.stdpath 'config' .. '/lua',
        },
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        -- library = vim.api.nvim_get_runtime_file("", true)
      },
    },
  },
})

vim.lsp.enable { 'pyright', 'lua_ls' }
