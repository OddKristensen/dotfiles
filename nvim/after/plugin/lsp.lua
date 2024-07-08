local lsp = require('lsp-zero')
local cmp = require('cmp')
local lspconfig = require('lspconfig')

lsp.preset("recommended")
--[[

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)


-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()
]]--

require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

cmp.setup({
  mapping = {
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
  }
})

lsp.on_attach(function (client, bufferNum)
  print('LSP attached ', client, bufferNum)
end)


lsp.setup()

lspconfig.tsserver.setup({})

