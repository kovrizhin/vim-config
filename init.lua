-- global init --
o = vim.o
bo = vim.bo
wo = vim.wo


vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'} , {
    pattern = '*/templates/*.{yaml,yml},*/templates/*.tpl,*.gotmpl,helmfile*.{yaml,yml}',
    callback = function()
          vim.bo.filetype = 'helm'
    end
})

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
  ensure_installed = { "lua", "rust", "c", "go", "json", "html", "yaml", "java", "ruby" },
  sync_install = false,
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true }
}

-- LSP
require("mason").setup()
local nvim_lsp = require 'lspconfig'

require 'luasnip'.config.set_config({
  history = true,
  updateevents = 'TextChanged,TextChangedI'
})

require 'luasnip.loaders.from_vscode'.load()

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
  mapping = { "jk", "jj" },   -- a table with mappings to use
  timeout = vim.o.timeoutlen, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
  clear_empty_lines = false,  -- clear line after escaping if there is only whitespace
  keys = "<Esc>",             -- keys used for escaping, if it is a function will use the result everytime
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
require("telescope").load_extension("diff")

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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

require 'lspconfig'.kotlin_language_server.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

require("neodev").setup({
  library = { plugins = { "nvim-dap-ui" }, types = true },
  -- add any options here, or leave empty to use the default settings
})

require 'lspconfig'.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      }
    }
  }
}

require("nvim-dap-virtual-text").setup {
  enabled = true,                       -- enable this plugin (the default)
  enabled_commands = true,              -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
  highlight_changed_variables = true,   -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
  highlight_new_as_changed = false,     -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
  show_stop_reason = true,              -- show stop reason when stopped for exceptions
  commented = false,                    -- prefix virtual text with comment string
  only_first_definition = true,         -- only show virtual text at first definition (if there are multiple)
  all_references = false,               -- show virtual text on all all references of the variable (not only definitions)
  clear_on_continue = false,            -- clear virtual text on "continue" (might cause flickering when stepping)
  --- A callback that determines how a variable is displayed or whether it should be omitted
  --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
  --- @param buf number
  --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
  --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
  --- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
  --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
  display_callback = function(variable, buf, stackframe, node, options)
    if options.virt_text_pos == 'inline' then
      return ' = ' .. variable.value
    else
      return variable.name .. ' = ' .. variable.value
    end
  end,
  -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
  virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',

  -- experimental features:
  all_frames = false,       -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
  virt_lines = false,       -- show virtual lines instead of virtual text (will flicker!)
  virt_text_win_col = nil   -- position the virtual text at a fixed window column (starting from the first text column) ,
  -- e.g. 80 to position at col
}

require("dapui").setup()

local dap, dapui = require("dap"), require("dapui")
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

require 'lspconfig'.pylsp.setup {
  --  cmd = {"pylsp"},
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    pylsp = {
      plugins = {
        -- formatter options
        black = { enabled = true },
        autopep8 = { enabled = false },
        yapf = { enabled = false },
        -- linter options
        pylint = { enabled = true, executable = "pylint" },
        pyflakes = { enabled = false },
        pycodestyle = { enabled = false },
        -- type checker
        pylsp_mypy = { enabled = true },
        -- auto-completion options
        jedi_completion = { fuzzy = true },
        -- import sorting
        pyls_isort = { enabled = true },
        pyrope = { enabled = true }
      },
    },
  }
}

require 'lspconfig'.tsserver.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
  cmd = { "typescript-language-server", "--stdio" }
}


require("lspconfig").helm_ls.setup {
  settings = {
    ['helm-ls'] = {
      yamlls = {
        path = "yaml-language-server",
      }
    }
  },
  on_attach = on_attach,
}




--local cfg = require("yaml-companion").setup({
--  -- Add any options here, or leave empty to use the default settings
--  -- lspconfig = {
--  --   cmd = {"yaml-language-server"}
--  -- },
--})
--require 'lspconfig'.yamlls.setup {
--  -- on_attach = on_attach,
--  cfg
--}

require('vgit').setup()
--[==[

require 'lspconfig'.yamlls.setup {
--  on_attach = on_attach,
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
]==]
     --

--[[require 'lspconfig'.yamlls.setup{]]
--[[settings = {]]
--[[yaml = {]]
--[[schemas = { kubernetes = "globPattern" },]]
--[[}]]
--[[}]]
--[[}]]
local cfg = require("yaml-companion").setup({
  -- Add any options here, or leave empty to use the default settings
  -- lspconfig = {
  --   cmd = {"yaml-language-server"}
  -- },
})
require("lspconfig")["yamlls"].setup(cfg)
require('dap-python').setup('python')

vim.g.translator_target_lang = "ru"
vim.g.translator_history_enable = true
vim.g.translator_window_type = "preview"

require("diffview").setup()
require("gitlab").setup( {
  debug = { go_request = true, go_response = true },
})


