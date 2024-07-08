require("oddunarium")

vim.opt.clipboard:append("unnamed")
vim.opt.clipboard:append("unnamedplus")

vim.cmd([[
  au TextYankPost * silent! lua vim.highlight.on_yank()
]])
