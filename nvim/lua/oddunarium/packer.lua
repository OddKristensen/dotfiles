-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.3',
    -- or                            , branch = '0.1.x',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  use 'navarasu/onedark.nvim'

  use(
    'nvim-treesitter/nvim-treesitter',
    {
      run = ':TSUpdate',
      build = ':TSUpdate',
    }
  )
  -- use('nvim-treesitter/playground')
  -- use('ThePrimeagen/harpoon')
  -- use('mbbill/undotree')
  -- use('tpope/vim-fugitive')

  use {
    "williamboman/mason.nvim",
    run = ":MasonUpdate" -- :MasonUpdate updates registry contents
  }

  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    requires = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' }, -- Required
      {
        -- Optional
        'williamboman/mason.nvim',
        run = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },     -- Required
      { 'hrsh7th/cmp-nvim-lsp' }, -- Required
      { 'L3MON4D3/LuaSnip' },     -- Required
    }


  }

  -- use({'scalameta/nvim-metals', requires = { "nvim-lua/plenary.nvim" }})
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-vsnip" },
      { "hrsh7th/vim-vsnip" },
    },
  })
  use({
    "scalameta/nvim-metals",
    requires = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
  })

  use("windwp/nvim-autopairs")

  use({
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 100
    end
  })

  use {
    'nvim-telescope/telescope-file-browser.nvim',
    requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  }

  use { 'nvim-telescope/telescope-project.nvim' }

  use { 'nvim-lualine/lualine.nvim', }

  -- use { 'terrortylor/nvim-comment' }

  -- use {
  --   'm-demare/attempt.nvim',
  --   requires = 'nvim-lua/plenary.nvim',
  -- }

  use {
    'NeogitOrg/neogit',
    requires = 'nvim-lua/plenary.nvim',
    -- tag = 'v0.0.1',
  }

  -- use { 'numToStr/Comment.nvim', }

  use { 'tzachar/local-highlight.nvim', }

  use({
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
    requires = "nvim-treesitter/nvim-treesitter",
  })

  use({
    "kylechui/nvim-surround",
    tag = "*",   -- Use for stability; omit to use `main` branch for the latest features
    -- config = function()
    --   require("nvim-surround").setup({
    --     -- Configuration here, or leave empty to use defaults
    --   })
    -- end
  })

  -- use({'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'})
  --
  use({ "stevearc/oil.nvim" })

  use({ 'lewis6991/gitsigns.nvim' })

  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    if packer_bootstrap then
      require('packer').sync()
    end
end)
