return {
   "mfussenegger/nvim-jdtls",
   ft = { "java" },
   dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui", "nvim-neotest/nvim-nio" },
   config = function()
      local java_cmds = vim.api.nvim_create_augroup("java_cmds", { clear = true })
      local cache_vars = {}

      local features = {
         codelens = true,
         debugger = false,
      }

      local function get_jdtls_paths()
         if cache_vars.paths then
            return cache_vars.paths
         end

         local path = {}

         path.data_dir = vim.fn.stdpath("cache") .. "/nvim-jdtls"

         local jdtls_install = "/data/data/com.termux/files/home/.local/share/jdtls/"
         local java_debug_install = "/data/data/com.termux/files/home/.local/share/java-debug/"
         local java_test_install =
         "/data/data/com.termux/files/home/.local/share/vscode-java-test/java-extension/"

         path.launcher_jar =
             vim.fn.glob(jdtls_install .. "/plugins/org.eclipse.equinox.launcher_*.jar")

         path.platform_config = jdtls_install .. "/config_linux"
         path.runtimes = {
            {
               name = "JavaSE-17",
               path = "/data/data/com.termux/files/usr/lib/jvm/java-17-openjdk/",
               javadoc = "/data/data/com.termux/files/home/.local/share/java-docs/",
            },
         }

         --[[ path.bundles = {
				vim.fn.glob(
					java_debug_install
						.. "/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
					1
				),
				vim.fn.glob(
					java_test_install
						.. "/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
					1
				),
			} ]]

         ---
         -- Include java-test bundle if present
         ---
         local java_test_bundle =
             vim.split(vim.fn.glob(java_test_install .. "/extension/server/*.jar"), "\n")

         if java_test_bundle[1] ~= "" then
            vim.list_extend(path.bundles, java_test_bundle)
         end
         --
         -- ---
         -- -- Include java-debug-adapter bundle if present
         -- ---

         local java_debug_bundle = vim.split(
            vim.fn.glob(
               java_debug_install .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"
            ),
            "\n"
         )

         if java_debug_bundle[1] ~= "" then
            vim.list_extend(path.bundles, java_debug_bundle)
         end

         cache_vars.paths = path

         return path
      end

      local function enable_codelens(bufnr)
         pcall(vim.lsp.codelens.refresh)

         vim.api.nvim_create_autocmd("BufWritePost", {
            buffer = bufnr,
            group = java_cmds,
            desc = "refresh codelens",
            callback = function()
               pcall(vim.lsp.codelens.refresh)
            end,
         })
      end

      local function enable_debugger(bufnr)
         require("jdtls").setup_dap({ hotcodereplace = "auto" })
         require("jdtls.dap").setup_dap_main_class_configs()

         local opts = { buffer = bufnr }
         vim.keymap.set("n", "<leader>df", "<cmd>lua require('jdtls').test_class()<cr>", opts)
         vim.keymap.set(
            "n",
            "<leader>dn",
            "<cmd>lua require('jdtls').test_nearest_method()<cr>",
            opts
         )
      end

      local function jdtls_on_attach(_, bufnr)
         if features.debugger then
            enable_debugger(bufnr)
         end

         if features.codelens then
            enable_codelens(bufnr)
         end

         -- The following mappings are based on the suggested usage of nvim-jdtls
         -- https://github.com/mfussenegger/nvim-jdtls#usage
         local function set_keymap(mode, lhs, rhs)
            vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { silent = true, noremap = true })
         end
         set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
         set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
         set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
         set_keymap("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>")
         set_keymap("n", "gk", "<cmd>lua vim.diagnostic.goto_next()<CR>")
         set_keymap("n", "gj", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
         set_keymap("n", "gR", "<cmd>lua vim.lsp.buf.references()<CR>")
         set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.rename()<CR>")
         set_keymap("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>")
         set_keymap("i", "<C-s>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
         set_keymap("n", "<F4>", "<cmd>lua vim.lsp.buf.format()<cr>")
         set_keymap("n", "<A-o>", "<cmd>lua require('jdtls').organize_imports()<cr>")
         set_keymap("n", "crv", "<cmd>lua require('jdtls').extract_variable()<cr>")
         set_keymap("x", "crv", "<esc><cmd>lua require('jdtls').extract_variable(true)<cr>")
         set_keymap("n", "crc", "<cmd>lua require('jdtls').extract_constant()<cr>")
         set_keymap("x", "crc", "<esc><cmd>lua require('jdtls').extract_constant(true)<cr>")
         set_keymap("x", "crm", "<esc><Cmd>lua require('jdtls').extract_method(true)<cr>")
         set_keymap("n", "crm", "<esc><Cmd>lua require('jdtls').extract_method(true)<cr>")
      end

      local function jdtls_setup(_)
         local jdtls = require("jdtls")

         local path = get_jdtls_paths()
         local data_dir = path.data_dir .. "/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

         if cache_vars.capabilities == nil then
            jdtls.extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

            local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
            cache_vars.capabilities = vim.tbl_deep_extend(
               "force",
               vim.lsp.protocol.make_client_capabilities(),
               ok_cmp and cmp_lsp.default_capabilities() or {}
            )
         end

         local cmd = {
            "java",
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-Xms1g",
            "-XX:+IgnoreUnrecognizedVMOptions",
            "--add-modules=jdk.incubator.vector,jdk.incubator.foreign",
            "--add-exports=jdk.incubator.vector/jdk.incubator.vector=ALL-UNNAMED",
            "--add-exports=jdk.incubator.foreign/jdk.incubator.foreign=ALL-UNNAMED",
            "--add-opens",
            "java.base/java.util=ALL-UNNAMED",
            "--add-opens",
            "java.base/java.lang=ALL-UNNAMED",
            "-jar",
            path.launcher_jar,
            "-configuration",
            path.platform_config,
            "-data",
            data_dir,
         }

         local lsp_settings = {
            java = {
               jdt = {
                  ls = {
                     vmargs =
                     "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m",
                  },
               },
               eclipse = {
                  downloadSources = true,
               },
               configuration = {
                  updateBuildConfiguration = "interactive",
                  runtimes = path.runtimes,
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
               inlayHints = {
                  parameterNames = {
                     enabled = "all",
                  },
               },
               format = {
                  enabled = true,
               },
            },
            signatureHelp = {
               enabled = true,
            },
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
            },
            contentProvider = {
               preferred = "fernflower",
            },
            extendedClientCapabilities = jdtls.extendedClientCapabilities,
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
         }
         on_init = function(client)
            if client.config.settings then
               client.notify(
                  "workspace/didChangeConfiguration",
                  { settings = client.config.settings }
               )
            end
         end
         jdtls.start_or_attach({
            cmd = cmd,
            settings = lsp_settings,
            on_attach = jdtls_on_attach,
            capabilities = cache_vars.capabilities,
            root_dir = vim.fn.getcwd(),
            flags = { allow_incremental_sync = true },
            on_init = on_init,
            init_options = {
               bundles = path.bundles,
            },
         })
      end

      vim.api.nvim_create_autocmd("FileType", {
         group = java_cmds,
         pattern = { "java" },
         desc = "Setup jdtls",
         callback = jdtls_setup,
      })

      vim.diagnostic.config({
         signs = false,
         virtual_text = false,
         update_in_insert = true,
         underline = true,
         float = {
            focusable = false,
            border = "rounded",
            scope = "cursor",
            source = "if_many",
            header = { "Cursor Diagnostics: ", "DiagnosticInfo" },
         },
      })
   end,
   --[[ {
		"nvim-java/nvim-java",
		config = function()
			require("java").setup()
		end,
	} ]]
}
