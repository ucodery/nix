-- floating windows (terminal popup, leader help) draw with their own groups,
-- which transparent.nvim does not clear by default
vim.g.transparent_groups = vim.list_extend(vim.g.transparent_groups or {}, { 'NormalFloat', 'FloatBorder', 'FloatTitle' })
