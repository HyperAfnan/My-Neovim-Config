return {
  "erichlf/devcontainer-cli.nvim",
  dependencies = { "akinsho/toggleterm.nvim" },
  init = function()
    require("devcontainer-cli").setup({
      interactive = false,
      toplevel = true,
      remove_existing_container = true,
      dotfiles_repository = "https://github.com/HyperAfnan/dotfiles.git",
      dotfiles_branch = "devcontainer-cli",
      dotfiles_targetPath = "~/dotfiles",
      dotfiles_installCommand = "~/dotfiles/scripts/install-devcontainer.sh",
      shell = "zsh",
      nvim_binary = "nvim",
      log_level = "debug",
      console_level = "info",
    })
  end,
}
