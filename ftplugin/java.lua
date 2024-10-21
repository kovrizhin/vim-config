local jdtls_ok, jdtls = pcall(require, "jdtls")
  if not jdtls_ok then
  -- vim.notify jdtls_ok)
  vim.notify "JDTLS not found, install with `:LspInstall jdtls`"
   return
end

--local spring = require("spring_boot")
--spring.setup({
--  --ls_path = nil,
--  jdt_extensions_path = nil,
--   ls_path = "/home/oleg/bootlsp/vmware.vscode-spring-boot/extension/language-server", -- 默认依赖 vscode-spring-boot 插件, 如果没有安装 vscode 插件，可以指定路径
--    --jdt_extensions_path =  "/home/oleg/bootlsp/vmware.vscode-spring-boot/extension/jars", -- 默认依赖 vscode-spring-boot 插件
-- })
local bundles = {
      vim.fn.glob("/home/oleg/Downloads/com.microsoft.java.debug.plugin-0.50.0.jar", 1),
      vim.fn.glob("/home/oleg/.local/share/nvim/mason/packages/java-test/extension/server/com.microsoft.java.test.plugin-0.40.1.jar", 1),
      vim.fn.glob("/home/oleg/.local/share/nvim/mason/packages/java-test/extension/server/com.microsoft.java.test.runner-jar-with-dependencies.jar", 1),
      --vim.fn.glob("/home/oleg/.local/share/nvim/mason/packages/java-test/extension/server/junit-jupiter-api_5.9.3.jar", 1),
      --vim.fn.glob("/home/oleg/.local/share/nvim/mason/packages/java-test/extension/server/junit-jupiter-engine_5.9.3.jar", 1),
      --vim.fn.glob("/home/oleg/.local/share/nvim/mason/packages/java-test/extension/server/junit-jupiter-migrationsupport_5.9.3.jar", 1),
      --vim.fn.glob("/home/oleg/.local/share/nvim/mason/packages/java-test/extension/server/junit-jupiter-params_5.9.3.jar", 1),
      --vim.fn.glob("/home/oleg/.local/share/nvim/mason/packages/java-test/extension/server/junit-platform-commons_1.9.3.jar", 1),
      --vim.fn.glob("/home/oleg/.local/share/nvim/mason/packages/java-test/extension/server/junit-platform-engine_1.9.3.jar", 1),
      --vim.fn.glob("/home/oleg/.local/share/nvim/mason/packages/java-test/extension/server/junit-platform-launcher_1.9.3.jar", 1),
      --vim.fn.glob("/home/oleg/.local/share/nvim/mason/packages/java-test/extension/server/junit-platform-runner_1.9.3.jar", 1),
      --vim.fn.glob("/home/oleg/.local/share/nvim/mason/packages/java-test/extension/server/junit-platform-suite-api_1.9.3.jar", 1),
      --vim.fn.glob("/home/oleg/.local/share/nvim/mason/packages/java-test/extension/server/junit-platform-suite-commons_1.9.3.jar", 1),
      --vim.fn.glob("/home/oleg/.local/share/nvim/mason/packages/java-test/extension/server/junit-platform-suite-engine_1.9.3.jar", 1),
      --vim.fn.glob("/home/oleg/.local/share/nvim/mason/packages/java-test/extension/server/junit-vintage-engine_5.9.3.jar", 1),
      --vim.fn.glob("/home/oleg/.local/share/nvim/mason/packages/java-test/extension/server/org.apiguardian.api_1.1.2.jar", 1),
      --vim.fn.glob("/home/oleg/.local/share/nvim/mason/packages/java-test/extension/server/org.eclipse.jdt.junit4.runtime_1.3.0.v20220609-1843.jar", 1),
      --vim.fn.glob("/home/oleg/.local/share/nvim/mason/packages/java-test/extension/server/org.eclipse.jdt.junit5.runtime_1.1.100.v20220907-0450.jar", 1),
      
      --vim.fn.glob("/home/oleg/Downloads/vscode-spring-boot-1.53.0-RC.3/extension/jars/commons-lsp-extensions.jar",1),
      --vim.fn.glob("/home/oleg/Downloads/vscode-spring-boot-1.53.0-RC.3/extension/jars/io.projectreactor.reactor-core.jar",1),
      --vim.fn.glob("/home/oleg/Downloads/vscode-spring-boot-1.53.0-RC.3/extension/jars/jdt-ls-commons.jar",1),
      --vim.fn.glob("/home/oleg/Downloads/vscode-spring-boot-1.53.0-RC.3/extension/jars/jdt-ls-extension.jar",1),
      --vim.fn.glob("/home/oleg/Downloads/vscode-spring-boot-1.53.0-RC.3/extension/jars/org.reactivestreams.reactive-streams.jar",1),
      --vim.fn.glob("/home/oleg/Downloads/vscode-spring-boot-1.53.0-RC.3/extension/jars/xml-ls-extension.jar",1),
    }

--vim.list_extend(bundles, require("spring_boot").java_extensions())



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
    --"java -jar -Dsts.lsp.client=vscode /home/oleg/Projects/sts4/headless-services/spring-boot-language-server/target/spring-boot-language-server-1.54.0-SNAPSHOT-exec.jar",
    --"-javaagent:/home/oleg/Downloads/value-2.9.3.jar"
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
    bundles =  bundles,
  },
}

config["on_init"] = function(client, _)
  --require("spring_boot").enable_classpath_listening()
end


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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
config['capabilities'] = capabilities
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
  capabilities=capabilities,
}
