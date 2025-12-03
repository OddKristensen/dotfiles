
local M = {}

M.clipboard_current_buf_path = function (keyword)
  local path = vim.fn.expand(keyword or '%')
  vim.fn.setreg('*',  path)
  vim.notify('Copied buffer path to clipboard', vim.log.levels.INFO)
end

return M

