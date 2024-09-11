local whichKey = require("which-key")
local telescope = require('telescope.builtin')
local telescopeBase = require('telescope')
local attempt = require('attempt')
local neogit = require('neogit')

local tableLength = function (t)
  local count = 0
  for _ in pairs(t) do
    count = count + 1
  end
  return count
end

local switchWindow = function (i)
  local tabpage = vim.api.nvim_tabpage_list_wins(0)
  if tableLength(tabpage) >= i then
    vim.api.nvim_set_current_win(tabpage[i])
  else
    print('Window index not found')
  end
end

local switchWindowLambda = function (i)
  return function ()
    switchWindow(i)
  end
end

local command = function (command)
  return function() vim.cmd(command) end
end

whichKey.register({
  ['1'] = { switchWindowLambda(1), 'First window', },
  ['2'] = { switchWindowLambda(2), 'Second window', },
  ['3'] = { switchWindowLambda(3), 'Third window', },
  ['4'] = { switchWindowLambda(4), 'Fourth window', },
  ['5'] = { switchWindowLambda(5), 'Fifth window', },
  ['6'] = { switchWindowLambda(6), 'Sixth window', },
  ['7'] = { switchWindowLambda(7), 'Seventh window', },
  ['8'] = { switchWindowLambda(8), 'Eight window', },
  ['9'] = { switchWindowLambda(9), 'Ninth window', },
  b = {
    name = 'buffer',
    b = { telescope.buffers, 'Buffers' },
    d = { command('bd'), 'Delete current buffer' },
    f = { telescope.oldfiles, 'Files' },
    s = { command('vnew'), '(s)cratch up a new buffer vertically' },
    S = { command('new'), '(S)cratch up a new buffer horizontally' },
    t = {
      name = 'temporary',
      n = { attempt.new_select, 'New buffer' },
      N = { attempt.new_input_ext, 'New buffer with extenstion' },
      r = { attempt.rename_buf, 'Rename temporary buffer' },
      l = {
        function() vim.cmd('Telescope attempt') end,
        'List temporary buffers',
      },
      -- l = { attempt.open_select, 'List temporary buffers' },
    },
  },
  c = {
    name = 'code',
    -- d = { vim.lsp.buf.definition, 'Go to definition' },
    d = { telescope.lsp_definitions, 'Go to definition' },
    -- r = { vim.lsp.buf.references, 'Go to references' },
    r = { telescope.lsp_references, 'Go to references', },
    i = { telescope.lsp_implementations, 'Go to implementation' },
    -- i = { vim.lsp.buf.implementation, 'Go to implementation' },
    c = { vim.lsp.buf.hover, 'Characterize type at cursor' },
    s = { telescope.lsp_document_symbols, 'Symbols in file' },
    t = { vim.lsp.buf.signature_help, 'Type signature at cursor' },
    f = { vim.lsp.buf.format, 'Format' },
    a = { vim.lsp.buf.code_action, 'Code action' },
    n = { vim.lsp.buf.rename, 'Rename symbol at cursor', },
    m = { telescopeBase.extensions.metals.commands, 'Metals commands' },
    w = { telescope.lsp_dynamic_workspace_symbols, 'Workspace symbols' },
    ['>'] = { telescope.lsp_incoming_calls, 'Incoming calls' },
    ['<'] = { telescope.lsp_outgoing_calls, 'Outgoing calls' },
  },
  e = {
    name = 'error',
    e = { vim.diagnostic.open_float, 'Error' },
    n = { vim.diagnostic.goto_next, 'Next error', },
    p = { vim.diagnostic.goto_prev, 'Previous error' },
    l = { telescope.diagnostics, 'List all errors' },
  },
  f = {
    name = 'file',
    F = { command('Oil'), 'File browser (oil)' },
    f = {
      -- telescopeBase.extensions.file_browser.file_browser,
      function()
        telescopeBase.extensions.file_browser.file_browser {
          path = '%:p:h',
          select_buffer = true,
        }
      end,
      'File browser (telescope)',
    },
    s = { telescope.current_buffer_fuzzy_find, 'Search', },
    ['='] = { vim.lsp.buf.format, 'Format the current buffer' },
  },
  g = {
    name = 'git/version control',
    g = { neogit.open, 'status', },
    s = { telescope.git_status, 'Status' },
    L = { telescope.git_bcommits, 'Log for buffer' },
    l = { telescope.git_commits, 'Log for project' },
    b = { telescope.git_branches, 'Branches' },
    p = { command('G pull -r'), 'Pull', },
    f = { command('G fetch'), 'Fetch', },
    a = { command('G add -u'), 'Add', },
    A = { command('G add -A'), 'Add all', },
  },
  G = {
    name = 'git/Neogit',
    g = { command('G'), 'Fugitive status' },
  },
  j = { telescope.jumplist, '(J)ump list' },
  --[[
  m = {
    name = 'metals and other lsp stuff',
    s = {
      function ()
        vim.cmd('Metals')
      end,
      'stop server'
    },
    i = {
      function ()

      end,
      'import build',
    },
    d = {
      function ()

      end,
      'doctor',
    },
    r = {
      function ()

      end,
      'restart build server',
    },
  },
  --]]
  p = {
    name = "project",
    f = { telescope.find_files, "Find files" },
    s = { telescope.live_grep, "Search in files" },
    S = { telescope.grep_string, 'Search for word under cursor', },
    -- S = { ?, 'Search project for word under cursor'}
    c = { telescope.grep_string, 'Search for word under cursor' },
    g = { telescope.git_files, "Search git repo" },
    v = { vim.cmd.Ex, "Visually do things" },
    p = {
      function()
        telescopeBase.extensions.project.project { display_type = 'full' }
      end,
      'Switch project' ,
    },
  },
  q = {
    name = "quit",
    q = { command("qa"), "Quit neovim", },
    Q = { command("qa!"), "Quit neovim forcefully", },
  },
  s = {
    name = 'search',
    c = { command('noh'), 'Clear search highlight' },
    h = { telescope.search_history, 'Searrch (H)istory' },
    r = { telescope.resume, 'Resume the most recent search picker' },
    s = { telescope.current_buffer_fuzzy_find, 'Search in current buffer' },
    -- S = { telescope.grep_string, 'Search for word under cursor', },
  },
  t = { command('terminal'), '(T)erminal' },
  z = {
    name = '[Z]ystem (because I would never use it)',
    p = { command('PackerSync'), 'PackerSync', },
    t = { command('TSUpdate'),  'TSUpdate', },
  }
}, { prefix = "<leader>" })
whichKey.register({
  -- Buffer
  -- Window
  ['<leader>w'] = { name = 'window' },
  ['<leader>w3'] = { '<C-W>v<C-W>v', 'Split into 3 columns' },
  ['<leader>w|'] = { '<C-W>v', 'Split vertically' },
  ['<leader>w/'] = { '<C-W>v', 'Split vertically' },
  ['<leader>w-'] = { '<C-W>s', 'Split horizontally' },
  ['<leader>w<Up>'] = { '<C-W>k', 'Go to upper window' },
  ['<leader>w<Down>'] = { '<C-W>j', 'Go to lower window' },
  ['<leader>w<Left>'] = { '<C-W>h', 'Go to left window' },
  ['<leader>w<Right>'] = { '<C-W>l', 'Go to right window' },
  ['<leader>wd'] = { '<C-W>q', 'Delete window' },
  -- ['<leader>w1'] = { function() vim.cmd(':only') end, 'Unify all windows' },
  ['<leader>wu'] = { command(':only'), 'Unify all windows' },
  ['<leader>w='] = { '<C-W>=', 'Re-Balence all windows to have equal width and height' },
})
