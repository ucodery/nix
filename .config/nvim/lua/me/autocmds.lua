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

-- external formatters for gq and <leader>f (the tools come from home.nix)
local formatprg = vim.api.nvim_create_augroup('me_formatprg', { clear = true })
local set_formatprg = function(filetypes, prg)
  vim.api.nvim_create_autocmd('FileType', {
    group = formatprg,
    pattern = filetypes,
    callback = function(args)
      vim.bo[args.buf].formatprg = type(prg) == 'function' and prg(args.buf) or prg
    end,
  })
end
set_formatprg('python', 'black --quiet -')
set_formatprg(
  'lua',
  'stylua --call-parentheses=None --column-width=100 --indent-type=Spaces --indent-width=2 --quote-style=AutoPreferSingle -'
)
set_formatprg({ 'javascript', 'typescript', 'json', 'yaml', 'markdown', 'css', 'scss', 'html' }, function(buf)
  return 'prettier --stdin-filepath ' .. vim.fn.shellescape(vim.api.nvim_buf_get_name(buf))
end)
