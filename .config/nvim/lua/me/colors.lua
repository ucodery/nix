local color_set, _ = pcall(vim.cmd, 'colorscheme witchhazel-hypercolor')
-- backport theacodes/witchhazel/pull/35
vim.cmd[[highlight Visual guibg=#894E63]]
-- the cursor colour says who has the keyboard: in Terminal mode nvim hands the
-- cursor to the terminal (Alacritty's rose #894E63); in its own modes it is
-- pink, the vicmd colour of the starship prompt. Only entries that name a
-- highlight group send a colour, the default guicursor names none.
vim.cmd [[highlight Cursor guibg=#FFB8D1 guifg=#1e0010]]
vim.opt.guicursor = 'n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor,t:block-TermCursor'
if not color_set then
  -- a builtin colorscheme
  local color_set, _ = pcall(vim.cmd, 'colorscheme desert')
  if not color_set then
    print "Couldn't find any colors"
  end
end
