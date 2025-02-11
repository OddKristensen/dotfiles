local window = { 'windows', mode = 1, max_length = 1, }

require('lualine').setup({
  options = {
    icons_enabled = false,
    -- FIXME: removing the separators fixes the splash screen disappearing
    section_separators = "",
    component_separators = "",
  },
  sections = {
    lualine_a = { window, 'mode', },
    -- Show the full(er) path when the window is active
    lualine_c = { {'filename', path = 1} },
    lualine_y = { 'searchcount', 'progress', },
  },
  inactive_sections = {
    lualine_a = { window },
    lualine_c = {'filename'},
    lualine_x = {'location'},
  },
})
