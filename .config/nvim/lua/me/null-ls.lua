local null_ls = require 'null-ls'

null_ls.setup {
  debug = false,
  sources = {
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.stylua.with {
      extra_args = {
        '--call-parentheses=None',
        '--column-width=100',
        '--indent-type=Spaces',
        '--indent-width=2',
        '--quote-style=AutoPreferSingle',
      },
    },
  },
}
