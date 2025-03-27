local whichKey = require("which-key")
local telescope = require('telescope.builtin')
local telescopeBase = require('telescope')
-- local attempt = require('attempt')
local neogit = require('neogit')
local gitsigns = require('gitsigns')
local find_in_project = require('find_in_project')
local pre_filter_symbols = require('pre_filter_symbols')
local todo = require("todo-comments")

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

local showTempFiles = function ()
  telescopeBase.extensions.file_browser.file_browser {
    path = '~/.temps',
    select_buffer = true,
  }
end

whichKey.add({

  { '<leader>1', switchWindowLambda(1), desc = 'First window' },
  { '<leader>2', switchWindowLambda(2), desc = 'Second window' },
  { '<leader>3', switchWindowLambda(3), desc = 'Third window' },
  { '<leader>4', switchWindowLambda(4), desc = 'Fourth window' },
  { '<leader>5', switchWindowLambda(5), desc = 'Fifth window' },
  { '<leader>6', switchWindowLambda(6), desc = 'Sixth window' },
  { '<leader>7', switchWindowLambda(7), desc = 'Seventh window' },
  { '<leader>8', switchWindowLambda(8), desc = 'Eight window' },
  { '<leader>9', switchWindowLambda(9), desc = 'Ninth window' },


  { '<leader>b', group = 'buffer' },
  { '<leader>bb', telescope.buffers, desc = 'Buffers' },
  { '<leader>bd', command('bd'), desc = 'Delete current buffer' },
  { '<leader>bf', telescope.oldfiles, desc = 'Files' },
  { '<leader>bl', showTempFiles, desc = "(L)ist temp files" },
  { '<leader>bs', command('vnew'), desc = '(s)cratch up a new buffer vertically' },
  { '<leader>bS', command('new'), desc = '(S)cratch up a new buffer horizontally' },
  { '<leader>bT', command('enew'), desc = "New (T)emp buffer" },


  { '<leader>c', group = 'code' },
  { '<leader>cd', telescope.lsp_definitions, desc = 'Go to definition' },
  { '<leader>cr', telescope.lsp_references, desc = 'Go to references' },
  { '<leader>ci', telescope.lsp_implementations, desc = 'Go to implementation' },
  { '<leader>cc', vim.lsp.buf.hover, desc = 'Characterize type at cursor' },
  { '<leader>cs', telescope.lsp_document_symbols, desc = 'Symbols in file' },
  {
    '<leader>cS',
    function () pre_filter_symbols.pre_filter_symbols() end,
    desc = 'Pre filtered Symbols in file',
  },
  { '<leader>ct', vim.lsp.buf.signature_help, desc = 'Type signature at cursor' },
  { '<leader>cf', vim.lsp.buf.format, desc = 'Format' },
  { '<leader>ca', vim.lsp.buf.code_action, desc = 'Code action' },
  { '<leader>cn', vim.lsp.buf.rename, desc = 'Rename symbol at cursor' },
  { '<leader>cm', telescopeBase.extensions.metals.commands, desc = 'Metals commands' },
  { '<leader>cw', telescope.lsp_dynamic_workspace_symbols, desc = 'Workspace symbols' },
  { '<leader>c>', telescope.lsp_incoming_calls, desc = 'Incoming calls' },
  { '<leader>c<', telescope.lsp_outgoing_calls, desc = 'Outgoing calls' },


  { '<leader>e', group = 'error'  },
  { '<leader>ee', vim.diagnostic.open_float, desc = 'Error' },
  { '<leader>en', vim.diagnostic.goto_next, desc = 'Next error' },
  { '<leader>ep', vim.diagnostic.goto_prev, desc = 'Previous error' },
  { '<leader>el', telescope.diagnostics, desc = 'List all errors' },


  { '<leader>f', group = 'file' },
  { '<leader>fF', command('Oil'), desc = 'File browser (oil)' },
  {
    '<leader>ff',
    function()
      telescopeBase.extensions.file_browser.file_browser {
        path = '%:p:h',
        select_buffer = true,
      }
    end,
    desc = 'File browser (telescope)',
  },
  { '<leader>fs', telescope.current_buffer_fuzzy_find, desc = 'Search' },
  { '<leader>ft', showTempFiles, desc = "(T)emp files" },
  { '<leader>f=', vim.lsp.buf.format, desc = 'Format the current buffer' },


  { '<leader>g', desc = 'git/version control' },
  { '<leader>gg', neogit.open, desc = 'status' },
  { '<leader>gs', telescope.git_status, desc = 'Status' },
  { '<leader>gL', telescope.git_bcommits, desc = 'Log for buffer' },
  { '<leader>gl', telescope.git_commits, desc = 'Log for project' },
  { '<leader>gb', telescope.git_branches, desc = 'Branches' },
  { '<leader>gp', command('!git pull -r'), desc = 'Pull' },
  { '<leader>gf', command('!git fetch'), desc = 'Fetch' },
  { '<leader>ga', command('!git add -u'), desc = 'Add' },
  { '<leader>gA', command('!git add -A'), desc = 'Add all' },
  { '<leader>gh', desc = 'Git (h)unk'},
  { '<leader>ghn', function() gitsigns.nav_hunk('next') end, desc = '(n)ext hunk' },
  { '<leader>ghp', function() gitsigns.nav_hunk('prev') end, desc = '(p)revious hunk' },
  { '<leader>ghd', gitsigns.reset_hunk, desc = '(d)elete hunk' },
  { '<leader>ghd', gitsigns.reset_hunk, desc = '(D)elete whole buffer' },
  { '<leader>ghh', gitsigns.preview_hunk, desc = '(p)review hunk' },
  { '<leader>ghq', gitsigns.setqflist, desc = '(Q)uickfix hunks in buffer' },
  {
    '<leader>ghQ',
    function () gitsigns.setqflist('all') end,
    desc = '(Q)uickfix hunks in project',
  },



  { '<leader>G', group = 'git/Fugitive' },
  { '<leader>Gg', command('G'), desc = 'Fugitive status' },


  { '<leader>j', telescope.jumplist, desc = '(J)ump list' },

  { '<leader>n', group = '(n)umber' },
  { '<leader>ni', '<C-a>', desc = 'Increment number' },
  { '<leader>nd', '<C-x>', desc = 'Decrement number' },

  { '<leader>p', group = '(p)roject' },
  { '<leader>pf', telescope.find_files, desc = "Find files" },
  {
    '<leader>pF',
    function() find_in_project.find_in_project() end,
    desc = "Find files in selected project",
  },
  { '<leader>ps', telescope.live_grep, desc = "Search in files" },
  { '<leader>pS', telescope.grep_string, desc = 'Search for word under cursor' },
  { '<leader>pc', telescope.grep_string, desc = 'Search for word under cursor' },
  { '<leader>pg', telescope.git_files, desc = "Search git repo" },
  { '<leader>pv', vim.cmd.Ex, desc = "Visually do things" },
  {
    '<leader>pp',
    function()
      telescopeBase.extensions.project.project { display_type = 'full' }
    end,
    desc = 'Switch project' ,
  },


  { '<leader>q', group = '(q)uit' },
  { '<leader>qq', command("qa"), desc = "Quit neovim" },
  { '<leader>qQ', command("qa!"), desc = "Quit neovim forcefully" },


  { '<leader>s', group = 'search' },
  { '<leader>sc', command('noh'), desc = 'Clear search highlight' },
  { '<leader>sh', telescope.search_history, desc = 'Searrch (H)istory' },
  { '<leader>sr', telescope.resume, desc = 'Resume the most recent search picker' },
  { '<leader>ss', telescope.current_buffer_fuzzy_find, desc = 'Search in current buffer' },


  { '<leader>T', command('terminal'), desc = '(T)erminal' },
  { '<leader>t', group = '(t)ab' },
  { '<leader>t<Left>', 'gT', desc = 'Previous Tab' },
  { '<leader>t<Right>', 'gt', desc = 'Next Tab' },
  { '<leader>t1', '1gt', desc = 'First Tab' },
  { '<leader>t2', '2gt', desc = 'Second Tab' },
  { '<leader>t3', '3gt', desc = 'Third Tab' },
  { '<leader>tp', 'gT', desc = '(p)revious Tab' },
  { '<leader>tn', 'gt', desc = '(n)ext tabl' },
  { '<leader>tq', command('tabclose'), desc = '(q)uit tab' },
  { '<leader>tt', command('tabnew'), desc = 'New (t)ab' },



  { '<leader>z', group = '[Z]ystem (because I would never use it)' },
  { '<leader>zp', command('PackerSync'), desc = 'PackerSync' },
  { '<leader>zt', command('TSUpdate'), desc =  'TSUpdate' },


  { '<leader>w', group = 'window' },
  { '<leader>w3', '<C-W>v<C-W>v', desc = 'Split into 3 columns' },
  { '<leader>w|', '<C-W>v', desc = 'Split vertically' },
  { '<leader>w/', '<C-W>v', desc = 'Split vertically' },
  { '<leader>w-', '<C-W>s', desc = 'Split horizontally' },
  { '<leader>w<Up>', '<C-W>k', desc = 'Go to upper window' },
  { '<leader>w<Down>', '<C-W>j', desc = 'Go to lower window' },
  { '<leader>w<Left>', '<C-W>h', desc = 'Go to left window' },
  { '<leader>w<Right>', '<C-W>l', desc = 'Go to right window' },
  { '<leader>wd', '<C-W>q', desc = 'Delete window' },
  { '<leader>w1', function() vim.cmd(':only') end, desc = 'Unify all windows' },
  { '<leader>wu', command(':only'), desc = 'Unify all windows' },
  { '<leader>w=', '<C-W>=', desc = 'Re-Balence all windows to have equal width and height' },


  { '<leader>W', group = "(W)indow" },
  { '<leader>W<Left>', 20 .. '<C-w><', desc = 'Shrink window horizontally' },
  { '<leader>W<Right>', 20 .. '<C-w>>', desc = 'Widen window horizontally' },
  { '<leader>W<Up>', 10 .. '<C-w>+', desc = 'Grow window vertically' },
  { '<leader>W<Down>', 10 .. '<C-w>-', desc = 'Shrink window vertically' },

  { '<leader>/', group = '/ Comments' },
  { '<leader>//', command(':TodoTelescope'), desc = 'List TODO comments', },
  { '<leader>/n', todo.jump_next, desc = 'Next TODO comment', },
  { '<leader>/p', todo.jump_prev, desc = 'Previous TODO comment', },
})
