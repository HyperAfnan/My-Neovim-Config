return {
   {
      "CRAG666/code_runner.nvim",
      cmd = {
         "RunClose",
         "RunCode",
         "RunFile",
         "RunProject",
      },
      config = function()
         vim.keymap.set("n", "<F5>", "<cmd>RunFile<cr>", { silent = true, noremap = true })
         require('code_runner').setup({
            filetype = {
               java = {
                  "cd $dir &&",
                  "javac $fileName -d classes/ &&",
                  "cd classes/ && ",
                  "java $fileNameWithoutExt"
               },
            }
         })
      end,
   },
}
