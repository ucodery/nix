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
keymap('n', '<leader><leader>', ':')
keymap('i', 'jj', '<ESC>')

-- toggles
keymap('n', '<leader>h', ':set hls!<CR>')
keymap('n', '<leader>n', ':set number! relativenumber!<CR>')
keymap('n', '<leader>s', ':set spell!<CR>')
keymap('n', '<leader>t', ':TransparentToggle<CR>')

keymap('n', '<leader>f', ':lua vim.lsp.buf.formatting()<CR>')

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
