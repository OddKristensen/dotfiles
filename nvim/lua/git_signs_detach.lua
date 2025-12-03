local gitsigns = require('gitsigns')

local M = {
  detach_all = function ()
    gitsigns.detach_all()
  end
}

return M
