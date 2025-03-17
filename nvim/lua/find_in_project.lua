local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local themes = require("telescope.themes")
local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")
local scan = require("plenary.scandir")
local builtin = require("telescope.builtin")

local get_projects = function ()
  -- This should be configurable
  local path = vim.fn.expand("~/projects")
  return scan.scan_dir(path, {
    depth = 1,
    only_dirs = true,
    hidden = true,
  })
end

local projects = function (opts)
  opts = opts or {}
  pickers.new(
    opts,
    {
      prompt_title = "Picker project",
      finder = finders.new_table {
        results = get_projects(),
      },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function (prompt_bufnr, _)
        actions.select_default:replace(
          function ()
            actions.close(prompt_bufnr)
            local selection = actions_state.get_selected_entry()
            builtin.find_files({ cwd = selection[1] })
          end
        )
        return true
      end,
    }
  ):find()
end

local M = {
  find_in_project = function ()
    projects(themes.get_dropdown({}))
  end
}

return M
