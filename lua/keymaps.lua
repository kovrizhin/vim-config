local P = {}
keymaps = P
-- leader --
vim.g.mapleader = ' '

-- key_mapping --
local key_map = function(mode, key, result)
  vim.api.nvim_set_keymap(
    mode,
    key,
    result,
    {noremap = true, silent = true}
  )
end

function git_commit_all()
  vim.ui.input({ prompt = 'Msg: ' }, function(input)
    io.popen("git add * && git commit -am '" .. input .. "'")
  end)
end

function git_commit_push_all()
  vim.ui.input({ prompt = 'Msg: ' }, function(input)
    io.popen("git add * && git commit -am '" .. input .. "' && git push")
  end)
end

-- Telescope
key_map('n', '<C-p>', ':lua require"telescope.builtin".find_files()<CR>')
key_map('n', '<leader>fs', ':lua require"telescope.builtin".live_grep()<CR>')
key_map('n', '<leader>fh', ':lua require"telescope.builtin".help_tags()<CR>')
key_map('n', '<leader>fb', ':lua require"telescope.builtin".buffers()<CR>')
key_map('n', '<leader>ct', '<Cmd>TagbarToggle<CR>')
--key_map('n', "<leader>ff", "<cmd>Telescope find_files<cr>")
key_map('n', "<leader>fg", "<cmd>Telescope live_grep<cr>")
key_map('n', "<leader>fb", "<cmd>Telescope buffers<cr>")
key_map('n', "<leader>fm", "<cmd>Telescope marks<cr>")
key_map('n', "<leader>fr", "<cmd>Telescope lsp_references<cr>")
key_map('n', "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>")
key_map('n', "<leader>fc", "<cmd>Telescope lsp_incoming_calls<cr>")
key_map('n', "<leader>fo", "<cmd>Telescope lsp_outgoing_calls<cr>")
key_map('n', "<leader>fi", "<cmd>Telescope lsp_implementations<cr>")
key_map('n', "<leader>fx", "<cmd>Telescope diagnostics bufnr=0<cr>")

-- Git
key_map('n', '<leader>gc', ':lua git_commit_all()<CR>')
key_map('n', '<leader>ga', ':lua git_commit_push_all()<CR>')

--LSP
function P.map_lsp_keys() 
  key_map('n', '<C-]>', ':lua vim.lsp.buf.definition()<CR>')
  key_map('n', '<C-k>', ':lua vim.lsp.buf.signature_help()<CR>')
  key_map('n', '<S-R>', ':lua vim.lsp.buf.references()<CR>')
  key_map('n', '<S-H>', ':lua vim.lsp.buf.hover()<CR>')
  key_map('n', '<leader>ca', ':lua vim.lsp.buf.code_action()<CR>')
  key_map('n', '<leader>nc', ':lua vim.lsp.buf.rename()<CR>')
  key_map('n', '<leader>fr', ':lua require"telescope.builtin".lsp_references()') 
  key_map('n', '<leader>ff', ':lua vim.lsp.buf.format()<CR>')
end

-- nvim tree
vim.api.nvim_set_keymap('n', '<leader>tt', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tf', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<TAB>',':bn<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-TAB>', ':bp<CR>', { noremap = true, silent = true })


-- bufferline
key_map('n', '<leader>bq', '<Cmd>bdelete!<CR>')
key_map('n', '<leader>bp', '<Cmd>BufferLineTogglePin<CR>')
key_map('n', '<leader>bs', '<Cmd>BufferLinePick<CR>')
key_map('n', '<C-h>', '<Cmd>BufferLineCyclePrev<CR>')
key_map('n', '<C-l>', '<Cmd>BufferLineCycleNext<CR>')

local Terminal = require("toggleterm.terminal").Terminal
local zshTerminal = Terminal:new({ cmd = "zsh", hidden = true })
function openZshTerminal()
  zshTerminal:toggle()
end
-- Terminal
key_map('n', '<leader>op', '<cmd>lua openZshTerminal()<CR>')


-- Debugging 

function debug_open_centered_scopes()
  local widgets = require'dap.ui.widgets'
  widgets.centered_float(widgets.scopes)
end

key_map('n', 'gs', ':lua debug_open_centered_scopes()<CR>')
key_map('n', '<F5>', ':lua require"dap".continue()<CR>')
key_map('n', '<F8>', ':lua require"dap".step_over()<CR>')
key_map('n', '<F7>', ':lua require"dap".step_into()<CR>')
key_map('n', '<S-F8>', ':lua require"dap".step_out()<CR>')
key_map('n', '<leader>b', ':lua require"dap".toggle_breakpoint()<CR>')
key_map('n', '<leader>B', ':lua require"dap".set_breakpoint(vim.fn.input("Condition: "))<CR>')
key_map('n', '<leader>bl', ':lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log: "))<CR>')
key_map('n', '<leader>dr', ':lua require"dap".repl.open()<CR>')
key_map('n', '<leader>di', ':lua require"dap.ui.widgets".hover()')
key_map('n', '<leader>dr', ':lua require"dap.ui.widgets".centered_float(widgets.scopes)')
key_map('n', '<leader>df', '<cmd>Telescope dap frames<cr>')
key_map('n', '<leader>dh', '<cmd>Telescope dap commands<cr>')



-- Java

-- Rust
function P.map_rust_keys(bufnr)
  P.map_lsp_keys()
  key_map('n', '<leader>rr', '<Cmd>RustRunnable<CR>')
  key_map('n', '<leader>rb', '<cmd>term cargo build<cr>')
  key_map('n', '<leader>rc', '<cmd>term cargo check<cr>')
  key_map('n', '<leader>rt', '<cmd>term cargo test<cr>')
end

function P.run_command_method_test()
  local node_utils = require'node-utils'
  local method_name = node_utils.get_current_full_method_name("\\#")
  if detect_build_system() == "gradle" then
   local mvn_run = 'mvn test -Dmaven.surefire.debug -Dtest="' .. method_name .. '"' 
   vim.cmd('term ' .. mvn_run)
  else
    local gradle_run = 'gradlew test --tests "' .. method_name .. '"'
    vim.cmd('term ' .. gradle_run)
  end
end

function P.run_command_class_test()
  local node_utils = require'node-utils'
  local class_name = node_utils.get_current_full_class_name()
  local mvn_run = 'mvn test -Dmaven.surefire.debug -Dtest="' .. class_name .. '"' 
  vim.cmd('term ' .. mvn_run)
end

-- Java
function P.map_java_keys(bufnr)
  P.map_lsp_keys()
  key_map('n', '<leader>oi', ':lua require("jdtls").organize_imports()<CR>')
  key_map('n', '<leader>jc', ':lua require("jdtls).compile("incremental")')
  key_map("n", "<leader>vc", ':lua require("jdtls").test_class()<CR>')
  key_map("n", "<leader>vm", ':lua require("jdtls").test_nearest_method()<CR>')

end

-- hop
key_map('n', 'f', '<cmd>HopWordCurrentLineAC<cr>')
key_map('n', '<S-F>', '<cmd>HopWordCurrentLineBC<cr>')
key_map('n', '<leader>hp', '<cmd>HopPattern<cr>')
key_map('n', 'gt', '<cmd>HopLine<cr>')
-- additional
key_map('n', '<leader>sf', ':w<CR>')
key_map('n', '<S-Q>', '<Cmd>q<CR>')


function detect_build_system()
    local gradle_file = vim.fn.findfile('build.gradle', '.;')
    local maven_file = vim.fn.findfile('pom.xml', '.;')
    local gradle_file_kts = vim.fn.findfile('build.gradle.kts', '.;')

    if gradle_file ~= '' or gragle_file_kts ~= '' then
        return "gradle"
    elseif maven_file ~= '' then
        return "gradle"
    else
        return "gredle"
    end
end

-- run debug
function get_test_runner(test_name, debug)
  if(debug_open_centered_scopes() == "gradle") then 
    if debug then 
      return  'gradlew test --debug-jvm --tests "' .. test_name .. '"'
    end
    return  'gradlew test --tests "' .. test_name .. '"'
  else 
   if debug then
     return 'mvn test -Dmaven.surefire.debug -Dtest="' .. test_name .. '"' 
   end
   return 'mvn test -Dtest="' .. test_name .. '"' 
  end
end

function run_java_test_method(debug)
  local utils = require'utils'
  local method_name = utils.get_current_full_method_name("\\#")
  vim.cmd('term ' .. get_test_runner(method_name, debug))
end

function run_java_test_class(debug)
  local utils = require'utils'
  local class_name = utils.get_current_full_class_name()
  vim.cmd('term ' .. get_test_runner(class_name, debug))
end

function get_spring_boot_runner(profile, debug)
  local debug_param = ""
  if debug then
    debug_param = ' -Dspring-boot.run.jvmArguments="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5005" '
  end 

  local profile_param = ""
  if profile then
    profile_param = " -Dspring-boot.run.profiles=" .. profile .. " "
  end

  return 'mvn spring-boot:run ' .. profile_param .. debug_param
end

function run_spring_boot(debug)
  vim.cmd('term ' .. get_spring_boot_runner("local", debug))
end

vim.keymap.set("n", "<leader>tm", function() run_java_test_method() end)
vim.keymap.set("n", "<leader>TM", function() run_java_test_method(true) end)
vim.keymap.set("n", "<leader>tc", function() run_java_test_class() end)
vim.keymap.set("n", "<leader>TC", function() run_java_test_class(true) end)

vim.keymap.set("n", "<F9>", function() run_spring_boot() end)
vim.keymap.set("n", "<F10>", function() run_spring_boot(true) end)

function attach_to_debug()
  local dap = require('dap')
  dap.configurations.java = {
    {
      type = 'java';
      request = 'attach';
      name = "Attach to the process";
      hostName = 'localhost';
      port = '5005';
    },
  }
  dap.continue()
end 

key_map('n', '<leader>da', ':lua attach_to_debug()<CR>')

--git
--key_map('n', ']g', {map=[[&diff ? ']g' : '<cmd>Gitsigns next_hunk<CR>']], opts={expr=true}})
--key_map('n', '[g', {map=[[&diff ? '[g' : '<cmd>Gitsigns prev_hunk<CR>']], opts={expr=true}})
key_map('n', '<Leader>gp', ':Gitsigns preview_hunk<CR>')
key_map('n', '<Leader>gs', ':Gitsigns stage_hunk<CR>')
key_map('n', '<Leader>gr', ':Gitsigns reset_hunk<CR>')
key_map('n', '<Leader>gu', ':Gitsigns undo_stage_hunk<CR>')
key_map('n', '<Leader>gS', ':Gitsigns stage_buffer<CR>')
key_map('n', '<Leader>gU', ':Gitsigns reset_buffer_index<CR>')
key_map('n', '<Leader>gR', ':Gitsigns reset_buffer<CR>')
key_map('n', '<Leader>gg', ':Git<CR>')
key_map('n', '<Leader>gs', ':Git status<CR>')
key_map('n', '<Leader>gc', ':Git commit | startinsert<CR>')
key_map('n', '<Leader>gd', ':Git difftool<CR>')
key_map('n', '<Leader>gm', ':Git mergetool<CR>')
key_map('n', '<Leader>g|', ':Gvdiffsplit<CR>')
key_map('n', '<Leader>g_', ':Gdiffsplit<CR>')
-- Popup what's changed in a hunk under cursor
vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
    desc = "Toggle Spectre"
})
vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
    desc = "Search current word"
})
vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
    desc = "Search current word"
})
vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
    desc = "Search on current file"
})

return P

