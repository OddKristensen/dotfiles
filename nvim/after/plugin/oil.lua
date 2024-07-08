require('oil').setup({
  view_options = {
    show_hidden = true,
  },
  keymaps = {
    ['<BS>'] = 'actions.parent',
    ['<TAB>'] = 'actions.select',
  },
})
