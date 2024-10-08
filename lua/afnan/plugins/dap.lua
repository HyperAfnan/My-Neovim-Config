-- return {
--    {
--       "mfussenegger/nvim-dap",
--       dependencies = {
--          {
--             "ibhagwan/fzf-lua",
--             dependencies = { "nvim-tree/nvim-web-devicons" },
--          },
--          "rcarriga/nvim-dap-ui",
--          "nvim-neotest/nvim-nio",
--          {
--             "theHamsta/nvim-dap-virtual-text",
--             opts = { virt_text_pos = "eol" },
--          },
--          {
--             "jbyuki/one-small-step-for-vimkind",
--             keys = {
--                {
--                   ",dl",
--                   function()
--                      require("osv").launch({ port = 8086 })
--                   end,
--                   desc = "Launch Lua adapter",
--                },
--             },
--          },
--       },
--       keys = {
--          {
--             ",db",
--             function()
--                require("dap").toggle_breakpoint()
--             end,
--             desc = "Toggle breakpoint",
--          },
--          {
--             ",dB",
--             "<cmd>FzfLua dap_breakpoints<cr>",
--             desc = "List breakpoints",
--          },
--          {
--             ",dc",
--             function()
--                require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
--             end,
--             desc = "Breakpoint condition",
--          },
--          {
--             "<F4>",
--             function()
--                require("dap").continue()
--             end,
--             desc = "Continue",
--          },
--          {
--             "<F10>",
--             function()
--                require("dap").step_over()
--             end,
--             desc = "Step over",
--          },
--          {
--             "<F11>",
--             function()
--                require("dap").step_into()
--             end,
--             desc = "Step into",
--          },
--          {
--             "<F12>",
--             function()
--                require("dap").step_out()
--             end,
--             desc = "Step Out",
--          },
--       },
--       config = function()
--          local dap, dapui = require("dap"), require("dapui")
--          dap.listeners.before.attach.dapui_config = function()
--             dapui.open()
--          end
--          dap.listeners.before.launch.dapui_config = function()
--             dapui.open()
--          end
--          dap.listeners.before.event_terminated.dapui_config = function()
--             dapui.close()
--          end
--          dap.listeners.before.event_exited.dapui_config = function()
--             dapui.close()
--          end
--
--          dap.adapters["nlua"] = function(callback, _)
--             callback({ type = "server", host = "127.0.0.1", port = 8086 })
--          end
--
--          dap.configurations["lua"] = {
--             {
--                type = "nlua",
--                request = "attach",
--                name = "Attach to running Neovim instance",
--                host = function()
--                   return "127.0.0.1"
--                end,
--                port = function()
--                   return 8086
--                end
--             },
--          }
--
--          dap.adapters.lldb = {
--             type = "executable",
--             command = "lldb-dap",
--             name = "lldb"
--          }
--
--          dap.configurations.cpp = {
--             {
--                name = 'Launch',
--                type = 'lldb',
--                request = 'launch',
--                program = function()
--                   return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--                end,
--                cwd = '${workspaceFolder}',
--                stopOnEntry = false,
--                args = {},
--                runInTerminal = false,
--             },
--          }
--
--          dap.configurations.c = dap.configurations.cpp
--
--          --[[ dap.adapters.cppdbg = {
--           id = "cppdbg",
--           type = "executable",
--           command = " /data/data/com.termux/files/home/.local/share/debuggers/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
--         } ]]
--          --[[ dap.configurations.cpp = {
--           {
--             name = "Launch file",
--             type = "cppdbg",
--             request = "launch",
--             program = function()
--               return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
--             end,
--             cwd = "${workspaceFolder}",
--             stopAtEntry = true,
--           },
--           {
--             name = "Attach to gdbserver :1234",
--             type = "cppdbg",
--             request = "launch",
--             MIMode = "gdb",
--             miDebuggerServerAddress = "localhost:1234",
--             miDebuggerPath = " /data/data/com.termux/files/usr/bin/gdb",
--             cwd = "${workspaceFolder}",
--             program = function()
--               return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
--             end,
--             setupCommands = {
--               {
--                 text = "-enable-pretty-printing",
--                 description = "enable pretty printing",
--                 ignoreFailures = false,
--               },
--             },
--           },
--         } ]]
--       end,
--    },
-- }

return {}
