vim.cmd [[
  augroup _auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd =
  augroup end
]]

-- terminals: no spelling and no number gutter in any mode. The pty is sized to
-- the text area, so a gutter appearing on a mode switch would SIGWINCH the
-- shell, which redraws (doubles) its prompt and wraps it. `:set number` still
-- works when wanted.
local term = vim.api.nvim_create_augroup('_custom_term', { clear = true })
vim.api.nvim_create_autocmd('TermOpen', {
  group = term,
  callback = function()
    vim.opt_local.spell = false
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.cmd.startinsert()
  end,
})
vim.api.nvim_create_autocmd('TermLeave', {
  group = term,
  callback = function()
    vim.b.term_paged = false -- Terminal mode leaves the cursor on the edit line
    vim.w.term_line = vim.fn.line '.'
  end,
})
-- only a cursor moved by the user counts; entering a window fires CursorMoved too
vim.api.nvim_create_autocmd('CursorMoved', {
  group = term,
  callback = function()
    local line = vim.fn.line '.'
    if vim.bo.buftype == 'terminal' and line ~= vim.w.term_line then
      vim.w.term_line = line
      vim.b.term_paged = line < vim.fn.prevnonblank(vim.fn.line '$')
    end
  end,
})
vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter' }, {
  group = term,
  pattern = 'term://*',
  callback = function()
    vim.w.term_line = vim.fn.line '.'
    -- deferred: `:split file` from a terminal fires WinEnter while the new window
    -- still shows the terminal, and an immediate startinsert would land on the file
    vim.schedule(function()
      if vim.bo.buftype == 'terminal' and not vim.b.term_paged then
        vim.cmd.startinsert()
      end
    end)
  end,
})

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
