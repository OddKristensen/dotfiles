
require('mini.splitjoin').setup()
require('mini.diff').setup()
require('mini.surround').setup({
  custom_surroundings = {
    ['('] = {
      output = {
        left = '(',
        right = ')',
      },
    },
    ['{'] = {
      output = {
        left = '{',
        right = '}',
      },
    },
    ['['] = {
      output = {
        left = '[',
        right = ']',
      },
    },
    ['<'] = {
      output = {
        left = '<',
        right = '>',
      },
    },
    ["'"] = {
      output = {
        left = "'",
        right = "'",
      },
    },
    ['"'] = {
      output = {
        left = '"',
        right = '"',
      },
    },
  }
})
local indentscope = require('mini.indentscope')

indentscope.setup {
  delay = 50,
  draw = {
    animation = indentscope.gen_animation.none()
  },
  symbol = '│',
}
