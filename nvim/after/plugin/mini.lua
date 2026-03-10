
require('mini.splitjoin').setup()
require('mini.diff').setup()
local indentscope = require('mini.indentscope')

indentscope.setup {
  delay = 50,
  draw = {
    animation = indentscope.gen_animation.none()
  },
  symbol = '│',
}
