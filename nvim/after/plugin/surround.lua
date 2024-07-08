require("nvim-surround").setup({
  -- Configuration here, or leave empty to use defaults
  surrounds = {
    ['('] = false,
    ['['] = false,
    ['{'] = false,
    ['<'] = false,
  },
  aliases = {
    ['('] = ')',
    ['{'] = '}',
    ['['] = ']',
    ['<'] = '>',
  },
})

