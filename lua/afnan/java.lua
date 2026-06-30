local gh = require("afnan.pack").gh

vim.pack.add({
	{ src = gh("mfussenegger/nvim-jdtls") },
})

local jdtls = require("jdtls")

local home = vim.fn.expand("$HOME")
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name

local launcher = vim.fn.glob(
	home
		.. "/.local/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"
)
local bundles = {}

vim.list_extend(
	bundles,
	vim.split(
		vim.fn.glob(home .. "/.local/share/java/java-debug/**/*.jar"),
		"\n"
	)
)

vim.list_extend(
	bundles,
	vim.split(
		vim.fn.glob(home .. "/.local/share/java/java-test/**/*.jar"),
		"\n"
	)
)


local config = {
	cmd = {
		"java",

		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",

		"-Dlog.protocol=true",
		"-Dlog.level=ALL",

		"-Xms1g",

		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",

		"-jar",
		launcher,

		"-configuration",
		home .. "/.local/share/java/jdtls/config_linux",

		"-data",
		workspace_dir,
	},

	root_dir = require("jdtls.setup").find_root({
		".git",
		"mvnw",
		"gradlew",
		"pom.xml",
		"build.gradle",
	}),

	settings = {
		java = {
			signatureHelp = {
				enabled = true,
			},

			contentProvider = {
				preferred = "fernflower",
			},

			completion = {
				favoriteStaticMembers = {
					"org.junit.Assert.*",
					"org.junit.jupiter.api.Assertions.*",
					"org.mockito.Mockito.*",
				},
			},

			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},

			format = {
				enabled = false,
			},
		},
	},

	init_options = {
      bundles = bundles
	},
}

jdtls.start_or_attach(config)

local opts = { buffer = 0 }

vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, opts)
vim.keymap.set("n", "<leader>jv", jdtls.extract_variable, opts)
vim.keymap.set("n", "<leader>jc", jdtls.extract_constant, opts)
vim.keymap.set("v", "<leader>jm", [[<ESC><CMD>lua require("jdtls").extract_method(true)<CR>]], opts)
