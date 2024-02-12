-- Nvim Tree
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1
require'nvim-tree'.setup {
  --auto_open = true,
  --open_on_startup = true,
  disable_netrw       = true,
  hijack_netrw        = true,
  --open_on_setup       = false,
  --ignore_ft_on_setup  = {},
  --auto_close          = true,
  open_on_tab         = false,
  hijack_cursor       = true,
  update_cwd          = false,
  diagnostics         = {
    enable = true,
    icons = {
      hint = "H",
      info = "I",
      warning = "W",
      error = "E",
    }
  },
  update_focused_file = {
    enable      = false,
    update_cwd  = false,
    ignore_list = {}
  },
  system_open = {
    cmd  = nil,
    args = {}
  },
  view = {
    width = 30,
    side = 'left',
    --auto_resize = false,
--[[    mappings = {]]
      --[[custom_only = false,]]
      --[[list = {}]]
--[[    }]]
  }
}
