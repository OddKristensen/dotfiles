local telescope = require('telescope')
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ")})
end)
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- local projectActions = require('telescope._extensions.project.actions')
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
      -- display_type = 'full',
    },
  },
  pickers = {
    find_files = {
      follow = true,
    },
  },
}

-- Previews for all temporary buffers
telescope.load_extension('attempt')

-- Use different sorter
telescope.load_extension('fzf')

