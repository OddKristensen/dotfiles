local path = require("plenary.path")
local oil = require('oil')

function starts_with(str, start)
  return str:sub(1, #start) == start
end

local M = {
  buffer_parent_dir = function ()
    local buffer_path = vim.fn.expand('%:p')
    local parent = nil
    local oil_prefix = 'oil://'
    if starts_with(buffer_path, oil_prefix) then
      local unoiled_path = string.sub(buffer_path, #oil_prefix)
      -- FIXME: This will break if you are closer to the root, but who cares
      parent = path:new(unoiled_path):parent().filename
    else
      -- FIXME: This will break if you are closer to the root, but who cares
      parent = path:new(buffer_path):parent():parent().filename
    end
    oil.open(parent)
  end
}

return M

