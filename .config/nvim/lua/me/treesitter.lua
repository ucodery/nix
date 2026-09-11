-- nvim-treesitter (main branch). Parsers and their queries are installed by nix
-- (nvim-treesitter.withAllGrammars in home.nix), so nothing is downloaded or
-- compiled here. The main branch only ships parsers, queries and an indent
-- expression; highlighting is neovim's own and is enabled per buffer.
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('me_treesitter', { clear = true }),
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match)
    if not (lang and vim.treesitter.language.add(lang)) then
      return -- no parser for this filetype
    end
    vim.treesitter.start(args.buf, lang)
    -- keep vim's regex highlighting layered on top of treesitter's
    vim.bo[args.buf].syntax = 'ON'
    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
