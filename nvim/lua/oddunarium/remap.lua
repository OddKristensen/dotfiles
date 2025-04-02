vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Move line below the current one into this one
vim.keymap.set("n", "J", "mzJ`z")
-- vim.keymap.set("v", "<Up>", "")

-- Center line of next search result
vim.keymap.set("n", 'n', 'nzz')
-- Center line of previous search result
vim.keymap.set('n', 'N', 'Nzz')

-- Move the visual block (the entire line in fact) up one line
vim.keymap.set("v", "<S-Up>", ":m '<-2<CR>gv=gv")
-- Move the visual block (the entire line in fact) down one line
vim.keymap.set("v", "<S-Down>", ":m '>+1<CR>gv=gv")

-- Center the line after scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Resize split
vim.keymap.set('n', '<A-S-Left>', '5<c-w><')
vim.keymap.set('n', '<A-S-Right>', '5<c-w>>')
vim.keymap.set('n', '<A-S-Up>', '5<C-W>+')
vim.keymap.set('n', '<A-S-Down>', '5<C-W>-')

-- Alt plus the arrows jumps around
vim.keymap.set("n", "<A-Right>", "e")
-- vim.keymap.set("n", "<A-Left>", "b")
vim.keymap.set("i", "<A-Right>", "<Esc>ea")
vim.keymap.set("i", "<A-Left>", "<Esc>bi")
vim.keymap.set("i", "<A-Down>", "<Esc>}a")
vim.keymap.set("i", "<A-Up>", "<Esc>{i")

-- Escape exits terminal mode
vim.keymap.set('t', '<ESC>', [[<C-\><C-n>]])
