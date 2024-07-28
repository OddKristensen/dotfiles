local telescope = require('telescope')
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ")})
end)

vim.api.nvim_create_autocmd(
  'FileType',
  {
    pattern = 'TelescopeResults',
    callback = function (context)
      vim.api.nvim_buf_call(
        context.buf,
        function ()
          vim.fn.matchadd('TelescopeFilename', '^.*\t\t')
          vim.api.nvim_set_hl(0, 'TelescopeFilename', { link = 'Directory' })
          vim.fn.matchadd('TelescopeParent', '\t\t.*$')
          vim.api.nvim_set_hl(0, 'TelescopeParent', { link = 'Question' })
        end
      )
    end
  }
)

local reversePath = function(path)
  if path == '.' then return path end
  local tokens = {}
  for token in string.gmatch(path, '[^/]+') do
    tokens[#tokens + 1] = token
  end
  local i = #tokens
  local reversedPath = tokens[i]
  while (i > 1) do
    i = i - 1
    reversedPath = reversedPath .. '\\' .. tokens[i]
  end
  return reversedPath
end

local filenameFirst = function (order)
  return function (_, path)
    local filename = vim.fs.basename(path)
    local rest
    if order == 'reverse' then
      rest = reversePath(vim.fs.dirname(path))
    else
      local r = vim.fs.dirname(path)
      if r == '.' then
        rest = path
      else
        rest = r
      end
    end
    return string.format('%s\t\t%s', filename, rest)
  end
end

local reversedAndWidePath = {
  path_display = filenameFirst('reverse'),
  fname_width = 50,
}

telescope.setup {
  defaults = {
    layout_strategy = 'vertical',
  },
  extensions = {
    project = {
      base_dirs = {
        '~/projects',
        '~/.config',
        '~/Documents/book',
      },
      theme = 'dropdown',
    },
  },
  pickers = {
    find_files = {
      follow = true,
      path_display = filenameFirst(),
    },
    lsp_references = reversedAndWidePath,
    lsp_implementations = reversedAndWidePath,
    lsp_incoming_calls = reversedAndWidePath,
    lsp_outgoing_calls = reversedAndWidePath,
  },
}

-- Previews for all temporary buffers
telescope.load_extension('attempt')

-- Use different sorter
telescope.load_extension('fzf')

