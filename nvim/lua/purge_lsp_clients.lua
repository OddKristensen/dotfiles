local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")
local entry_display = require("telescope.pickers.entry_display")

local M = {}

local stop_lsp = function (opts)
  vim.lsp.stop_client(opts.id, opts.force)

  if opts.name == 'metals' then
    print('Killing orphaned java processes')
    -- This sleep is completely arbitrary... Ideally metals would figure
    -- this out on their end. Alas...
    -- We just have to wait until the LSP client is stopped, thereby leaving
    -- the underlying java process hanging
    os.execute('sleep 0.4')
    os.execute("ps -ef | grep java | awk '$3 == 1{ print $2; }' | xargs kill")
  end
end

M.purge_from_project = function (opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()
  opts.force = opts.force or false
  local clients = vim.lsp.get_clients()
  for _, client in ipairs(clients) do
    if client.config.root_dir == opts.cwd then
      print('Stopping LSP: ' .. client.id .. ' for project at ' .. client.config.root_dir)

      stop_lsp {
        id = client.id,
        name = client.name,
        force = opts.force,
      }
    end
  end
end

M.list_lsp_clients = function (opts)
  opts = opts or {}
  opts.force = opts.force or false
  local clients = vim.lsp.get_clients()
  local client_entries = {}
  local longest_lsp_name = 4
  -- print('RAW CLIENTS ' .. vim.inspect(clients))
  for _, client in ipairs(clients) do
    local name_len = string.len(client.name)
    if name_len > longest_lsp_name then
      longest_lsp_name = name_len
    end
    -- print('IT_DEBUG ' .. client.id .. ' | ' .. client.config.name .. ' | ' .. client.root_dir)
    table.insert(client_entries, {
      root = client.root_dir,
      lsp_name = client.name,
      id = client.id,
    })
  end
  -- print('CLIENTS ' .. vim.inspect(client_entries))
  local column_displayer = entry_display.create {
    separator = " ",
    items = {
      { width = longest_lsp_name },
      { width = 3 },
      { remaining = true },
    }
  }
  pickers.new(
    opts,
    {
      prompt_title = 'Kill LSP',
      finder = finders.new_table {
        results = client_entries,
        entry_maker = function (client_entry)
          return {
            value = client_entry,
            display = function (entry)
              return column_displayer {
                { entry.value.lsp_name, 'TelescopeResultsIdentifier' },
                { entry.value.id },
                entry.value.root,
              }
            end,
            -- Needs to be a string for some reason...
            ordinal = '' .. client_entry.id,
          }
        end,
      },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function (prompt_bufnr, _)
        actions.select_default:replace(
        function ()
          actions.close(prompt_bufnr)
          local client_entry = actions_state.get_selected_entry().value
          stop_lsp {
            id = client_entry.id,
            name = client_entry.lsp_name,
            force = opts.force,
          }
        end
        )
        return true
      end
    }
  ):find()
end

-- M.list_lsp_clients()

return M
