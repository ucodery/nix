local lsp = require 'lspconfig'

lsp.pyright.setup {
  settings = {
    python = {},
  },
}

lsp.lua_ls.setup {
  -- originally from https://github.com/neovim/nvim-lspconfig/blob/a3d9395455f2b2e3b50a0b0f37b8b4c23683f44a/doc/server_configurations.md#lua_ls
  on_init = function(client)
    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua Neovim is using
        version = 'LuaJIT'
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          vim.fn.stdpath 'config' .. '/lua'
        }
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        -- library = vim.api.nvim_get_runtime_file("", true)
      }
    })
  end
}
