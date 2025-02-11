require("oddunarium")

vim.opt.clipboard:append("unnamed")
vim.opt.clipboard:append("unnamedplus")

-- Highlight copied text
vim.cmd([[
  au TextYankPost * silent! lua vim.highlight.on_yank()
]])

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function ()
    local save_cursor = vim.fn.getpos('.')
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos('.', save_cursor)
  end
})

-- Automatically resize splits when the terminal is resized
vim.api.nvim_create_autocmd('VimResized', { command = 'wincmd ='})


