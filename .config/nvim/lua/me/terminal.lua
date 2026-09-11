-- <leader><CR> pops the first terminal up in a floating window covering 85% of
-- the editor; {count}<leader><CR> pops up terminal number {count},
-- creating it when it does not exist yet. Inside the popup, <leader><CR> closes
-- it, and it also closes when focus moves to another window (the `edit` wrapper
-- splitting a file open does this).
local M = {}
local slots = {} -- terminal number -> buffer, stable for the session
local float = { win = nil, n = nil }
local group = vim.api.nvim_create_augroup('me_terminal_popup', { clear = true })

local is_term = function(buf)
  return buf ~= nil and vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == 'terminal'
end

-- terminals that exist before the first popup (nvim starts with one) take the
-- first numbers, in creation order
local seed = function()
  if next(slots) ~= nil then
    return
  end
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if is_term(buf) then
      slots[#slots + 1] = buf
    end
  end
end

local is_open = function()
  return float.win ~= nil and vim.api.nvim_win_is_valid(float.win)
end

local layout = function()
  local width = math.ceil(vim.o.columns * 0.85)
  local height = math.ceil(vim.o.lines * 0.85)
  return {
    relative = 'editor',
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2) - 1,
    col = math.floor((vim.o.columns - width) / 2),
    border = 'rounded',
    title = ' terminal ' .. float.n .. ' ',
    title_pos = 'center',
  }
end

local relayout = function()
  if is_open() then
    vim.api.nvim_win_set_config(float.win, layout())
  end
end

M.close = function()
  if is_open() then
    vim.api.nvim_win_close(float.win, true)
  end
  float.win = nil
end

M.show = function(n)
  seed()
  n = (n and n > 0) and n or 1
  local buf = slots[n]
  local new = not is_term(buf)
  if new then
    buf = vim.api.nvim_create_buf(true, false)
    slots[n] = buf
  end
  float.n = n
  if is_open() then
    vim.api.nvim_win_set_buf(float.win, buf)
    vim.api.nvim_set_current_win(float.win)
    relayout()
  else
    float.win = vim.api.nvim_open_win(buf, true, layout())
    -- what the terminal autocmds set on the window a terminal opens in; a float
    -- gets the global defaults instead
    vim.wo[float.win].wrap = false
    vim.wo[float.win].list = false
    vim.wo[float.win].spell = false
    vim.wo[float.win].number = false
    vim.wo[float.win].relativenumber = false
  end
  if new then
    vim.fn.jobstart(vim.o.shell, { term = true }) -- TermOpen starts Insert mode
  end
  -- otherwise the terminal autocmds decide: Insert on the edit line, Normal when paged up
end

M.toggle = function()
  local n = vim.v.count
  if n == 0 and is_open() and vim.api.nvim_get_current_win() == float.win then
    M.close()
  else
    M.show(n)
  end
end

vim.api.nvim_create_autocmd('VimResized', { group = group, callback = relayout })
vim.api.nvim_create_autocmd('WinLeave', {
  group = group,
  callback = function()
    if is_open() and vim.api.nvim_get_current_win() == float.win then
      vim.schedule(function()
        if is_open() and vim.api.nvim_get_current_win() ~= float.win then
          M.close()
        end
      end)
    end
  end,
})

-- nvim's working directory follows terminal 1: the shell announces its cwd at
-- every prompt with OSC 7 (PROMPT_COMMAND in home.nix) and nvim :cd's to match
vim.api.nvim_create_autocmd('TermRequest', {
  group = group,
  callback = function(args)
    local dir = args.data.sequence:match '^\27%]7;file://[^/]*(/.*)$'
    if dir == nil then
      return
    end
    dir = dir:gsub('%%(%x%x)', function(h)
      return string.char(tonumber(h, 16))
    end)
    seed()
    if args.buf == slots[1] and vim.fn.isdirectory(dir) == 1 and dir ~= vim.fn.getcwd() then
      vim.cmd.cd(vim.fn.fnameescape(dir))
    end
  end,
})

vim.keymap.set('n', '<leader><CR>', M.toggle, { silent = true, desc = 'terminal popup (count: terminal n)' })

return M
