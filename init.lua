-- global init --
o = vim.o
bo = vim.bo
wo = vim.wo

require('packages')
require('basic')
require('keymaps')
require('completion')
require('rust')
require('tree')
require('debugging')
require("spectre-setup")
require('toggleterm-config')
-- Neovide Configuration
if vim.g.neovide ~= nil then
  vim.opt.guifont = { "Fantasque Sans Mono", ":h16" }
  vim.g.neovide_scroll_animation_length = 0.3
  -- vim.g.neovide_fullscreen = true
end

require('lualine').setup {
  options = {
    theme = 'gruvbox-material'
  }
}

o.background = 'dark'
vim.g.gruvbox_material_background = 'medium'
vim.g.gruvbox_material_better_performance = 1
vim.cmd("colorscheme gruvbox-material")

-- Bufferline --
require("bufferline").setup {
  options = {
    separator_style = "slant",
    diagnostics = "nvim_lsp",

    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        highlight = "Directory",
        separator = true,
      }
    }
  }
}

-- TreeSettter Config
local configs = require 'nvim-treesitter.configs'
configs.setup {
  ensure_installed = { "lua", "rust", "c", "go", "json", "html", "yaml" },
  sync_install = false,
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true }
}

-- LSP
require("mason").setup()
local nvim_lsp = require 'lspconfig'


-- Autopairs
require('nvim-autopairs').setup({
  disable_filetype = { "TelescopePrompt", "vim" },
})

-- TabNine
local tabnine = require('cmp_tabnine.config')
tabnine:setup({ max_lines = 1000, max_num_results = 20, sort = true })

-- hop
local hop = require('hop')
hop.setup {}

-- Indent lines
--require("indent_blankline").setup {
-- for example, context is off by default, use this to turn it on
--    show_current_context = true,
--    show_current_context_start = true,
--}

-- Better Escape
require("better_escape").setup {
  mapping = { "jk", "jj" },     -- a table with mappings to use
  timeout = vim.o.timeoutlen,   -- the time in which the keys must be hit in ms. Use option timeoutlen by default
  clear_empty_lines = false,    -- clear line after escaping if there is only whitespace
  keys = "<Esc>",               -- keys used for escaping, if it is a function will use the result everytime
}

-- Terminal
require('toggleterm').setup()

-- Telescope
actions = require('telescope.actions')
require('telescope').setup {
  defaults = {
    layout_strategy = "vertical",
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-e>"] = actions.close,
      }
    }
  }
}

-- Configure vim-fugitive
vim.api.nvim_exec([[
augroup fugitive_settings
    autocmd!
    " Open fugitive in a vertical split
    autocmd FileType fugitive setlocal splitright
augroup END
]], false)

-- Set the nvim-tree configurations
--[=[
vim.g.nvim_tree_side = 'left'
vim.g.nvim_tree_width = 30
vim.g.nvim_tree_ignore = { '.git', 'node_modules', '__pycache__' }
vim.g.nvim_tree_auto_open = 1
vim.g.nvim_tree_auto_close = 1
vim.g.nvim_tree_quit_on_open = 1
vim.g.nvim_tree_follow = 1
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_hide_dotfiles = 1
vim.g.nvim_tree_highlight_opened_files = 1
vim.g.nvim_tree_highlight_opened_files = 1
vim.g.nvim_tree_add_trailing = 1
vim.g.nvim_tree_disable_netrw = 1 -- enable netrw for remote path
vim.g.nvim_tree_hijack_netrw = 1 -- hijack netrw window on startup

-- Auto close nvim-tree on open
vim.cmd([[
  autocmd FileType NvimTree setlocal nowrap
  autocmd FileType NvimTree setlocal winfixwidth
]])
]=]
    --
local on_attach = function(client, bufnr)
  -- Regular Neovim LSP client keymappings

  require 'keymaps'.map_java_keys(bufnr);
  require "lsp_signature".on_attach({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    floating_window_above_cur_line = true,
    padding = '',
    handler_opts = {
      border = "rounded"
    }
  }, bufnr)
end

require 'lspconfig'.kotlin_language_server.setup {
  on_attach = on_attach,
}

require 'lspconfig'.lua_ls.setup {
  on_attach = on_attach,
}

require 'lspconfig'.tsserver.setup {
  on_attach = on_attach,
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
  cmd = { "typescript-language-server", "--stdio" }
}

local cfg = require("yaml-companion").setup({
  -- Add any options here, or leave empty to use the default settings
  -- lspconfig = {
  --   cmd = {"yaml-language-server"}
  -- },
})
require 'lspconfig'.yamlls.setup {
 -- on_attach = on_attach,
  cfg
}

require('vgit').setup()
--[==[
  settings = {
    yaml = {
      schemas = { kubernetes = "globPattern",
        ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
        ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
        ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
        ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
        ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
        ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
        ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
        ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
        ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
        ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
        ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
      },
    }
  }
}
]==]--
