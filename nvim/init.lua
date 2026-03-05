require("oddunarium")

local branch_tail = require('brach_tail')
local gitsigns_m = require('git_signs_detach')

vim.o.winborder = "rounded"

vim.opt.clipboard:append("unnamed")
vim.opt.clipboard:append("unnamedplus")

-- Highlight copied text
vim.cmd([[
  au TextYankPost * silent! lua vim.highlight.on_yank()
]])

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    local save_cursor = vim.fn.getpos('.')
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos('.', save_cursor)
  end
})

-- Automatically resize splits when the terminal is resized
vim.api.nvim_create_autocmd('VimResized', { command = 'wincmd =' })

-- Copy the branch tail - often a ticket number - to the system clipboard
vim.api.nvim_create_user_command('BranchTail', branch_tail.copy_branch_tail, {})
vim.api.nvim_create_user_command(
  'EchoBufferPath',
  function()
    print(vim.fn.expand('%'))
  end,
  {}
)

vim.api.nvim_create_user_command('GitSignsDetachAll', gitsigns_m.detach_all, {})

vim.api.nvim_create_user_command(
  'NumMath',
  function(opts)
    print(opts.args)
    local operator = string.sub(opts.args, 1, 1)
    local num = tonumber(string.sub(opts.args, 2))

    if operator == '+' then
      vim.cmd('s/\\d\\+/\\=submatch(0)+' .. num .. '/')
    elseif operator == '*' then
      vim.cmd('s/\\d\\+/\\=submatch(0)*' .. num .. '/')
    elseif operator == '-' then
      vim.cmd('s/\\d\\+/\\=submatch(0)-' .. num .. '/')
    elseif operator == '/' then
      print('Division not supported')
      -- vim.cmd('s/\\d\\+/\\=submatch(0)-//' .. num .. '/')
    end
  end,
  { nargs = 1 }
)

-- use `jq` to format JSON files
-- autocommand FileType json set formatprg=jq
vim.api.nvim_create_autocmd("FileType", {
  pattern = "json",
  callback = function()
    -- TODO: The indentation shoudl ideally be customizable..
    vim.bo.formatprg = "jq --indent 4"
  end,
})

vim.api.nvim_create_user_command(
  'JqFormat',
  function (opts)
    vim.cmd('%!jq .')
  end,
  {}
)
