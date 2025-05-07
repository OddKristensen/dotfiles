local gitsigns = require('gitsigns')
local telescope = require('telescope.builtin')

local M = {
  git_signs_in_telescope = function ()
    gitsigns.setqflist('all', { open = false })
    telescope.quickfix()
  end
}

return M

