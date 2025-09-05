local rel = require('relative_project_files')

local M = {}

local function confirm_kill(buf_name, buf_nr)
  local answer = vim.fn.confirm('Kill ' .. buf_name .. ' ?', '&Yes\n&No')
  if answer == 0 then
    confirm_kill(buf_name, buf_nr)
  else
    return answer == 1
  end
end

local function force_kill(bufnr)
  vim.api.nvim_buf_delete(bufnr, { force = true })
end

local function kill_buf(buf_path, bufnr, close_type)
  local modified = vim.api.nvim_get_option_value('modified', { buf = bufnr })
  if close_type == 'force' then
    force_kill(bufnr)
  elseif close_type == 'confirm_all' and confirm_kill(buf_path, bufnr) then
    force_kill(bufnr)
  elseif close_type == 'confirm_unsaved' and modified and confirm_kill(buf_path, bufnr) then
    force_kill(bufnr)
  elseif modified then
    print('Unkilled buffer with changes: ' .. buf_path)
  else
    vim.api.nvim_buf_delete(bufnr, {})
  end
end

local function noop() end

-- TODO: Do something if there are no buffers open after all project ones have been killed
-- TODO: Forcefully close buffers with changes?
local function kill_project_buffers(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()
  -- confirm_all | confirm_unsaved | force | ???
  opts.close_type = opts.close_type or 'confirm_unsaved'
  opts.on_closed = opts.on_closed or noop

  local buffers = vim.fn.getbufinfo()
  for _, buffer in ipairs(buffers) do
    local buffer_path = buffer.name
    if rel.project_root(buffer_path, opts.cwd) then
      kill_buf(buffer_path, buffer.bufnr, opts.close_type)
    end
  end
  opts.on_closed()
end

M.kill_project_buffers = kill_project_buffers

return M
