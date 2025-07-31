local path = require("plenary.path")
local telescope = require('telescope.builtin')

local function starts_with(s, start)
  return s:sub(1, #start) == start
end

local function project_root(s, prefix)
  if starts_with(s, prefix) then
    local spath = path:new(s)
    local prefix_path = path:new(prefix)
    local spath_pieces = spath:_split()
    local prefix_pieces = prefix_path:_split()

    if #prefix_pieces > #spath_pieces then
      return nil
    else
      return spath_pieces[#prefix_pieces + 1]
    end
  else
    return nil
  end
end

local function find_from_file_root(opts)
  opts = opts or {}
  if opts.project then
    opts.project = vim.fn.expand(opts.project)
  else
    opts.project = vim.uv.cwd()
  end

  local file_path = vim.fn.expand("%:p")
  local root_dir = project_root(file_path, opts.project)

  if root_dir then
    telescope.find_files {
      cwd = vim.fs.joinpath(
        opts.project,
        project_root(file_path, opts.project)
      ),
    }
  else
    print('No project root found')
  end

end

local M = {
  find_from_file_root = find_from_file_root
}

return M
