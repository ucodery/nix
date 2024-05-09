-- reload neovim whenever configuration is saved
vim.cmd [[
  augroup live_config
    autocmd!
    autocmd BufWritePost */nvim/*.lua,*/nvim/lua/**/*.lua source $MYVIMRC
  augroup end
]]

vim.cmd [[
  augroup live_plugins
    autocmd!
    autocmd BufWritePost plugins.lua PackerSync
  augroup end
]]

vim.cmd [[
  augroup _auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd =
  augroup end
]]

vim.cmd [[
  augroup _custom_term
    autocmd!
    autocmd TermOpen * setlocal nospell
    autocmd TermEnter * setlocal norelativenumber nonumber
    autocmd TermOpen * startinsert
    autocmd BufWinEnter term://* startinsert
    autocmd WinEnter term://* startinsert
    autocmd TermLeave * setlocal relativenumber number
  augroup end
]]
