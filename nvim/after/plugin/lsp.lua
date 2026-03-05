-- local lsp = require('lsp-zero')
-- local cmp = require('cmp')
-- local lspconfig = require('lspconfig')
--
-- lsp.preset("recommended")
-- --[[
--
-- lsp.on_attach(function(client, bufnr)
--   lsp.default_keymaps({buffer = bufnr})
-- end)
--
--
-- -- (Optional) Configure lua language server for neovim
-- require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
--
-- lsp.setup()
-- ]]--
--
-- require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
--
-- cmp.setup({
--   mapping = {
--     ['<CR>'] = cmp.mapping.confirm({ select = true }),
--     ['<Tab>'] = cmp.mapping.confirm({ select = true }),
--   }
-- })
--
-- lsp.on_attach(function (client, bufferNum)
--   print('LSP attached ', client, bufferNum)
-- end)
--
--
-- lsp.setup()
--
-- lspconfig.ts_ls.setup({})
-- lspconfig.rust_analyzer.setup {}
-- lspconfig.basedpyright.setup {
--   settings = {
--     basedpyright = {
--       analysis = {
--         diagnosticMode = "openFilesOnly",
--         inlayHints = {
--           callArgumentNames = true
--         }
--       }
--     }
--   }
-- }
--
-- vim.lsp.config('*', {
--   on_attach = function (client, bufferNum)
--     print('LSP attached ', client, bufferNum)
--   end
-- })
--
-- vim.api.nvim_create_autocmd('LspAttach', {
--   callback = function (opts)
--
--   end
-- })
local cmp = require('cmp')
cmp.setup({
  mapping = {
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    ['<Down>'] = cmp.mapping.select_next_item(),
    ['<Up>'] = cmp.mapping.select_prev_item(),
  }
})

local on_attach = function (client, bufferNum)
  print('LSP attached ', client, bufferNum)
end

vim.lsp.config('*', {
  on_attach = on_attach,
})

vim.diagnostic.config({ virtual_text = true })

vim.lsp.enable('lua_ls')

vim.lsp.enable('ts_ls')

-- vim.lsp.config('rust_analyzer', {
--   settings = {
--     check = {
--       command = 'clippy',
--     },
--   },
-- })
-- vim.lsp.config.rust_analyzer = {
--   name = 'rust_analyzer',
-- }
vim.lsp.enable('rust_analyzer')

vim.lsp.config.basedpyright = {
  name = 'basedpyright',
  filetypes = { 'python' },
  settings = {
    basedpyright = {
      analysis = {
        diagnosticMode = "openFilesOnly",
        inlayHints = {
          callArgumentNames = true
        }
      }
    }
  }
}
vim.lsp.enable('basedpyright')

