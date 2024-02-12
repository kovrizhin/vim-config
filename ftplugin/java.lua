local jdtls_ok, jdtls = pcall(require, "jdtls")
  if not jdtls_ok then
  -- vim.notify jdtls_ok)
  vim.notify "JDTLS not found, install with `:LspInstall jdtls`"
   return
end


-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local jdtls_path = "/home/oleg/.local/share/nvim/mason/share/jdtls"
local path_to_lsp_server = jdtls_path .. "/config"
local path_to_plugins = jdtls_path .. "/plugins/"
local path_to_jar = path_to_plugins .. "org.eclipse.equinox.launcher_1.6.600.v20231106-1826.jar"
local lombok_path = path_to_plugins .. "lombok.jar"

local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then
  return
end

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = '/home/oleg/.data/site/java/workspace-root/' .. project_name
os.execute("mkdir -p" .. workspace_dir)

local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    --   '/usr/lib/jvm/java-17-openjdk/bin/java',
    --   '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    --   '-Dosgi.bundles.defaultStartLevel=4',
    --   '-Declipse.product=org.eclipse.jdt.ls.core.product',
    --   '-Dlog.protocol=true',
    --   '-Dlog.level=ALL',
    --   '-javaagent:' .. lombok_path,
    --   '-Xms1g',
    --   '--add-modules=ALL-SYSTEM',
    --   '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    --   '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    --   '-jar', path_to_jar,
    --   '-configuration', path_to_lsp_server,
    --   '-data', workspace_dir,
    'jdtls',
    "-javaagent:/home/oleg/Downloads/value-2.9.3.jar"
  },

  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = root_dir,

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      home = '/usr/lib/jvm/java-21-openjdk',
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = {
          {
            name = "JavaSE-21",
            path = "/usr/lib/jvm/java-21-openjdk",
            default = true,
          },
          {
            name = "JavaSE-11",
            path = "/usr/lib/jvm/java-11-openjdk",
       ---  default = true,
          },
        }
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      format = {
        enabled = true,
        settings = {
          url = vim.fn.stdpath "config" .. "/lang-servers/intellij-java-google-style.xml",
          profile = "GoogleStyle",
        },
      },

    },
    signatureHelp = { enabled = true },
    completion = {
      favoriteStaticMembers = {
        "org.hamcrest.MatcherAssert.assertThat",
        "org.hamcrest.Matchers.*",
        "org.hamcrest.CoreMatchers.*",
        "org.junit.jupiter.api.Assertions.*",
        "java.util.Objects.requireNonNull",
        "java.util.Objects.requireNonNullElse",
        "org.mockito.Mockito.*",
      },
      importOrder = {
        "java",
        "javax",
        "com",
        "org"
      },
    },
    extendedClientCapabilities = extendedClientCapabilities,
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
      },
      useBlocks = true,
    },
  },

  flags = {
    allow_incremental_sync = true,
  },
  init_options = {
    bundles = {
      vim.fn.glob("/home/oleg/Downloads/com.microsoft.java.debug.plugin-0.50.0.jar", 1)
    },
  },
}

config['on_attach'] = function(client, bufnr)
  require 'keymaps'.map_java_keys(bufnr);
  require "lsp_signature".on_attach({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    floating_window_above_cur_line = true,
    padding = '',
    handler_opts = {
      border = "rounded"
    }
  }, bufnr)
  require('jdtls').setup_dap({ hotcodereplace = 'auto' })
end
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)

require('dap').configurations.java = {
  {
    type = 'java',
    request = 'attach',
    name = "Debug (Attach) - Remote",
    hostName = "127.0.0.1",
    port = 5005,
  },
}

local on_attach = function(client, bufnr)
  -- Regular Neovim LSP client keymappings

  require 'keymaps'.map_java_keys(bufnr);
  require "lsp_signature".on_attach({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    floating_window_above_cur_line = false,
    padding = '',
    handler_opts = {
      border = "rounded"
    }
  }, bufnr)
end



require 'lspconfig'.kotlin_language_server.setup {
  on_attach = on_attach,
}
