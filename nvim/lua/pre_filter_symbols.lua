local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local themes = require("telescope.themes")
local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")
local builtin = require("telescope.builtin")

local symbols = {
  'File',
  'Module',
  'Namespace',
  'Package',
  'Class',
  'Method',
  'Property',
  'Field',
  'Constructor',
  'Enum',
  'Interface',
  'Function',
  'Variable',
  'Constant',
  'String',
  'Number',
  'Boolean',
  'Array',
  'Object',
  'Key',
  'Null',
  'EnumMember',
  'Struct',
  'Event',
  'Operator',
  'TypeParameter',
}

local pre_filter_symbols = function (opts)
  opts = opts or {}
  pickers.new(
    opts,
    {
      prompt_title = "Symbol type picker",
      finder = finders.new_table {
        results = symbols,
      },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function (prompt_bufnr, _)
        actions.select_default:replace(
          function ()
            actions.close(prompt_bufnr)
            local selection = actions_state.get_selected_entry()
            builtin.lsp_document_symbols { symbols = selection }
          end
        )
        return true
      end
    }
  ):find()
end


local M = {
  pre_filter_symbols = function ()
    pre_filter_symbols(themes.get_dropdown({}))
  end
}

return M
