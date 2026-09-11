-- nvim-lspconfig now only ships server definitions (lsp/*.lua); neovim's own
-- vim.lsp.config / vim.lsp.enable configure and start them.

-- advertise nvim-cmp's completion support (snippets, resolve fields) to every server
vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})
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

vim.lsp.enable { 'pyright', 'lua_ls', 'vimls' }
-- rust-analyzer needs the project's toolchain: its root detection runs rustc and
-- it drives cargo. Toolchains come from per-project direnv flakes, not home.nix,
-- so enable it only when one is on PATH.
if vim.fn.executable 'rustc' == 1 then
  vim.lsp.enable 'rust_analyzer'
end
