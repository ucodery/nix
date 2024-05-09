-- gutter
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.numberwidth = 1

-- nicer windows
vim.opt.scrolloff = 8
vim.opt.showmode = false
vim.opt.splitright = true
vim.opt.splitbelow = true

-- invisible characters
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0 -- set to the same as 'tabstop'
vim.opt.list = true
vim.opt.listchars = 'tab:@ ,conceal:~'
vim.conceallevel = 2
vim.opt.spell = true
vim.opt.hlsearch = true

vim.opt.smartindent = true

-- command options
vim.opt.wildmode = 'longest:full,full'
vim.opt.wildmenu = true

-- color
vim.opt.termguicolors = true

vim.opt.clipboard = 'unnamedplus'
vim.opt.undofile = true
vim.opt.hidden = true

vim.opt.mouse = ''
