local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")
local scan = require("plenary.scandir")
local builtin = require("telescope.builtin")

local default_project = '~/projects'
local noop = function(_) end

local get_projects = function ()
  -- This should be configurable
  local path = vim.fn.expand("~/projects")
  return scan.scan_dir(path, {
    depth = 1,
    only_dirs = true,
    hidden = true,
  })
end

local pick_project = function (opts)
  opts = opts or {}
  opts.path = opts.path or default_project
  opts.project_picker_title = opts.project_picker_title or 'Pick project'
  opts.on_selected = opts.on_selected or noop

  pickers.new(
    opts,
    {
      prompt_title = opts.project_picker_title,
      finder = finders.new_table {
        results = scan.scan_dir(vim.fn.expand(opts.path), {
          depth = 1,
          only_dirs = true,
          hidden = true,
        })
      },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function (prompt_bufnr, _)
        actions.select_default:replace(
          function ()
            actions.close(prompt_bufnr)
            local selection = actions_state.get_selected_entry()
            opts.on_selected({ selection = selection[1] })
          end
        )
        return true
      end,
    }
  ):find()
end

local find_files_from_selection = function (opts)
  builtin.find_files { cwd = opts.selection }
end

local cwd_from_selection = function (opts)
  vim.cmd('cd ' .. opts.selection)
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
    projects()
  end,
  pick_project = pick_project,
  find_files_in_project = function (opts)
    opts = opts or {}
    opts.on_selected = find_files_from_selection
    pick_project(opts)
  end,
  cwd_to_project = function (opts)
    opts = opts or {}
    opts.on_selected = cwd_from_selection
    pick_project(opts)
  end,
}

return M

