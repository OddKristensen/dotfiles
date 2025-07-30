local pickers = require "telescope.pickers"
local sorters = require("telescope.sorters")
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local make_entry = require("telescope.make_entry")


local grepable_grep = function (opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()

  local finder = finders.new_async_job {
    command_generator = function (search_query)
      if not search_query or search_query == "" then
        return nil
      end

      local split_search = vim.split(search_query, "  ")
      local args = { "rg" }

      if split_search[1] then
        table.insert(args, "-e")
        table.insert(args, split_search[1])
      end
      if split_search[2] then
        table.insert(args, "-g")
        table.insert(args, split_search[2])
      end

      return vim.iter {
        args,
        {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        }
      }:flatten():totable()
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  }

  pickers.new(opts, {
    prompt_title = "Grepable (Live) Grep",
    debounce = 100,
    finder = finder,
    previewer = conf.grep_previewer(opts),
    sorter = sorters.empty(),
  }):find()
end

local M = {
  grepable_grep = grepable_grep
}

return M

