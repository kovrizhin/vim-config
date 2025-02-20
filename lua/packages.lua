local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

local util = require 'packer.util'

packer.init({
  package_root = util.join_paths(vim.fn.stdpath('data'), 'site', 'pack')
})

--startup and add configure plugins
--
packer.startup(function(use)
  use 'wbthomason/packer.nvim'
  -- list of the plugins
  use 'nvim-treesitter/nvim-treesitter'
  use 'akinsho/bufferline.nvim'
  use "lukas-reineke/indent-blankline.nvim"
  use 'max397574/better-escape.nvim'
  -- themes
  use 'sainnhe/gruvbox-material'
  use 'sainnhe/everforest'

  -- LSP
  use "williamboman/mason.nvim"
  use 'neovim/nvim-lspconfig'
  use "mfussenegger/nvim-jdtls"
  use "ray-x/lsp_signature.nvim"

  -- Rust
  use 'simrat39/rust-tools.nvim'
  use 'preservim/tagbar'

  -- Debugging
  use 'mfussenegger/nvim-dap'
  use 'rcarriga/cmp-dap'
  use 'mfussenegger/nvim-dap-python'
  use {
    'theHamsta/nvim-dap-virtual-text',
  }
  use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } }
  -- Telescope
  use 'nvim-lua/plenary.nvim'
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/telescope.nvim'
  use { "jemag/telescope-diff.nvim",
    requires = {
      { "nvim-telescope/telescope.nvim" },
    }
  }
  use 'jremmen/vim-ripgrep'

  -- CMP
  use 'onsails/lspkind.nvim'
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      'L3MON4D3/LuaSnip',
      --'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
      'octaltree/cmp-look',
      'hrsh7th/cmp-path',
      'f3fora/cmp-spell',
      'hrsh7th/cmp-emoji'
    }
  }

  -- Miscellaneous --
  use {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
  }
  use 'tpope/vim-commentary'
  use 'nvim-lualine/lualine.nvim'
  use 'akinsho/toggleterm.nvim'

  use {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  }
  use {
    'tzachar/cmp-tabnine',
    run = './install.sh',
    requires = 'hrsh7th/nvim-cmp'
  }
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
  }
  use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({})
    end
  })
  --git
  use 'tpope/vim-fugitive'
  use 'udalov/kotlin-vim'
  --  use "sindrets/diffview.nvim"
  use({
    "kdheepak/lazygit.nvim",
    requires = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("telescope").load_extension("lazygit")
    end,
  })
  use {
    "someone-stole-my-name/yaml-companion.nvim",
    requires = {
      { "neovim/nvim-lspconfig" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("telescope").load_extension("yaml_schema")
    end,
  }
  use 'nvim-pack/nvim-spectre'
  use 'preservim/nerdcommenter'

  --navigation in text
  use 'justinmk/vim-sneak'
  use 'easymotion/vim-easymotion'
  use {
    'tanvirtin/vgit.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    }
  }

  --yaml_schema
  use {
    "someone-stole-my-name/yaml-companion.nvim",
    requires = {
      { "neovim/nvim-lspconfig" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("telescope").load_extension("yaml_schema")
    end,
  }
  use { "towolf/vim-helm", ft = "helm" }
  -- translate
  use {
    "voldikss/vim-translator"
  }
  --copilo
  use "github/copilot.vim"

  use {
    'harrisoncramer/gitlab.nvim',
    requires = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "stevearc/dressing.nvim",      -- Recommended but not required. Better UI for pickers.
      "nvim-tree/nvim-web-devicons", -- Recommended but not required. Icons in discussion tree.
    },
    run = function() require("gitlab.server").build(true) end,
    config = function()
      require("gitlab").setup()
    end,
  }
  use "folke/neodev.nvim"

  use {
    "JavaHello/spring-boot.nvim",
    --ft = "java",
    requires = {
      "mfussenegger/nvim-jdtls",
      "ibhagwan/fzf-lua", -- 可选
    },
  }
  use { "ibhagwan/fzf-lua",
    requires = {
      "vijaymarupudi/nvim-fzf",
      "kyazdani42/nvim-web-devicons" -- optional for icons
    }
  }
  --- go
  use 'ray-x/go.nvim'
  use 'ray-x/guihua.lua' -- recommended if need floating window support
  -- clipboard
  use {
    "AckslD/nvim-neoclip.lua",
    requires = {
      { 'kkharji/sqlite.lua',           module = 'sqlite' },
      -- you'll need at least one of these
      { 'nvim-telescope/telescope.nvim' },
      -- {'ibhagwan/fzf-lua'},
    },
    config = function()
      require('neoclip').setup()
    end,
  }
  use { 'nvim-telescope/telescope-dap.nvim'}
  use {
    'akinsho/flutter-tools.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim',   -- optional for vim.ui.select
    },
  }
end
)
