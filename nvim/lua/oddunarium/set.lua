vim.opt.nu = true
vim.opt.relativenumber = true

-- Highlight the current line
vim.opt.cursorline = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.smartcase = true
vim.opt.ignorecase = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.g.mapleader = " "

vim.g.gitcommit_summary_length = 72

-- vim.cmd([[
--     autocmd FileType scala,sbt setlocal commentstring=//\ %s
-- ]])

vim.cmd([[
    autocmd FileType sql setlocal commentstring=--\ %s
]])

-- Use the system clipboard by default
-- vim.clipboard = unnamedplus
