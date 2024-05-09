local color_set, _ = pcall(vim.cmd, 'colorscheme witchhazel-hypercolor')
-- backport theacodes/witchhazel/pull/35
vim.cmd[[highlight Visual guibg=#894E63]]
-- vim.cmd[[highlight Cursor guibg=#894E63]]
if not color_set then
  -- a builtin colorscheme
  local color_set, _ = pcall(vim.cmd, 'colorscheme desert')
  if not color_set then
    print "Couldn't find any colors"
  end
end
