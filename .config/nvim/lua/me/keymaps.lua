local keymap = function(mode, key, action, opts)
  vim.api.nvim_set_keymap(
    mode,
    key,
    action,
    vim.tbl_extend('keep', opts or {}, { noremap = true, silent = true })
  )
end

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- quicker switch modes
keymap('n', '<leader><leader>', ':', { desc = 'command line' })
keymap('i', 'jj', '<ESC>')

-- toggles
keymap('n', '<leader>h', ':set hls!<CR>', { desc = 'toggle search highlight' })
keymap('n', '<leader>n', ':set number! relativenumber!<CR>', { desc = 'toggle line numbers' })
keymap('n', '<leader>s', ':set spell!<CR>', { desc = 'toggle spelling' })
keymap('n', '<leader>t', ':TransparentToggle<CR>', { desc = 'toggle transparency' })

-- format the buffer with the LSP, or with 'formatprg' (see autocmds.lua) when
-- no attached server can format
local format = function()
  if #vim.lsp.get_clients { bufnr = 0, method = 'textDocument/formatting' } > 0 then
    vim.lsp.buf.format()
  elseif vim.bo.formatprg ~= '' then
    local view = vim.fn.winsaveview()
    vim.cmd 'silent normal! gggqG'
    vim.fn.winrestview(view)
  end
end
vim.keymap.set('n', '<leader>f', format, { silent = true, desc = 'format buffer' })

-- <leader>?: a popup listing every leader mapping (global and buffer-local)
-- with its description, except itself. Mappings are collected live, so anything
-- added later with a `desc` shows up here on its own.
local leader_help = function()
  local leader = vim.g.mapleader
  local rows, seen = {}, {}
  for _, mode in ipairs { 'n', 'v', 'i', 't' } do
    for _, maps in ipairs { vim.api.nvim_buf_get_keymap(0, mode), vim.api.nvim_get_keymap(mode) } do
      for _, m in ipairs(maps) do
        local lhs = (m.lhs:gsub('<Space>', ' '))
        if lhs:sub(1, #leader) == leader and lhs ~= leader .. '?' and not seen[mode .. lhs] then
          seen[mode .. lhs] = true
          local key = '<leader>' .. (lhs:sub(#leader + 1):gsub(leader, '<leader>'))
          rows[#rows + 1] = string.format(' %s  %-18s %s ', mode, key, m.desc or m.rhs or '')
        end
      end
    end
  end
  table.sort(rows)
  local width = 0
  for _, r in ipairs(rows) do
    width = math.max(width, vim.fn.strdisplaywidth(r))
  end
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, rows)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = 'wipe'
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    style = 'minimal',
    border = 'rounded',
    title = ' <leader> ',
    title_pos = 'center',
    width = width,
    height = #rows,
    row = math.floor((vim.o.lines - #rows) / 2) - 1,
    col = math.floor((vim.o.columns - width) / 2),
  })
  for _, key in ipairs { 'q', '<Esc>' } do
    vim.keymap.set('n', key, function()
      vim.api.nvim_win_close(win, true)
    end, { buffer = buf, nowait = true })
  end
end
vim.keymap.set('n', '<leader>?', leader_help, { silent = true })

-- resize windows
keymap('n', '<S-Up>', ':resize +2<CR>')
keymap('n', '<S-Down>', ':resize -2<CR>')
keymap('n', '<S-Left>', ':resize -2<CR>')
keymap('n', '<S-Right>', ':resize +2<CR>')

-- Tab navigation
keymap('n', '<C-T><C-t>', 'gt')
keymap('n', '<C-T>t', 'gt')
keymap('n', '<C-T>l', 'gt')
keymap('n', '<C-T>T', 'gT')
keymap('n', '<C-T>T', 'gT')
keymap('n', '<C-T>n', ':tabnew<CR>')
keymap('n', '<C-T>o', ':tabonly<CR>')
keymap('n', '<C-T>q', ':tabclose<CR>')

-- Terminal navigation
keymap('t', '<C-w>', '<C-\\><C-n><C-w>') -- window shortcuts work as in normal mode
keymap('t', '<C-t>', '<C-\\><C-n>gt') -- tab shortcuts work as in normal mode
keymap('t', '<C-u>', '<C-\\><C-n><C-u>')
keymap('t', '<C-v>', '<C-\\><C-n><C-b>')
keymap('n', '<C-w>T', ':vsplit term://bash<CR>')
keymap('n', '<C-w>t', ':split term://bash<CR>')

-- indent easier
keymap('v', '<', '<gv')
keymap('v', '>', '>gv')

-- comment easier
keymap('v', '#', ':s/^/#/<CR>:noh<CR>')
keymap('v', '-#', ':s/^#//<CR>:noh<CR>gv')

-- easy character insertion
keymap('i', '<C-SPACE>', '<C-N>')
keymap('n', '<CR>', '<ESC>o<ESC>')
keymap('n', '<S-CR>', '<ESC>O<ESC>')

-- disable what is most often a typo
keymap('n', 'q:', ':q<CR>')
