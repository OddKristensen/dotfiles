
-- local unix = vim.fn.has 'unix' == 1
-- local path_separator = unix and '/' or '\\'


require('attempt').setup({
  -- dir = (unix and ('~/tmp/' or '/tmp/') or vim.fn.expand('$TEMP\\')) .. 'attempt.nvim' .. path_separator,
  -- dir = '~/tmp' .. 'attempt.nvim' .. path_separator,
  ext_options = { 'md', 'ts', 'js', 'py' },
})

