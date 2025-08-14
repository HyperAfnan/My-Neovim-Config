# Afnan’s Neovim Config

A fast, modern Neovim setup powered by lazy.nvim with first-class LSP, Treesitter, Telescope, DAP, Git tooling, and a polished UI.

## Requirements
- Neovim 0.9+ (recommended 0.10+)
- Nerd Font (for icons) — e.g. FiraCode Nerd Font
- ripgrep (for Telescope live grep)
- Git (for lazy.nvim, plugins, and Git tooling)
- Node.js (for many LSPs and js DAP)
- Python 3 with pynvim (host is set in options)
- Java (for jdtls if you want Java LSP)

Optional (used by some features):
- gh CLI (used in some Git workflows)
- Prettier (provided in package.json for formatting workflow)

## Installation
1) Backup your current config
- mv ~/.config/nvim ~/.config/nvim.bak

2) Place this repo at ~/.config/nvim
- git clone <your-fork-or-this-repo-url> ~/.config/nvim

3) Start Neovim
- nvim
- lazy.nvim will bootstrap automatically. When Neovim opens, run :Lazy to ensure everything is installed and up to date.

4) Install language servers and tools
- :Mason to manage LSP/DAP/linters
- Treesitter parsers will auto-install on demand (also available via :TSUpdate)

## Project Structure
- init.lua — core entrypoint
- lua/afnan/lazyy.lua — lazy.nvim bootstrap + plugin import
- lua/afnan/core/
  - options.lua — editor options and globals
  - mappings.lua — core keymaps
  - autocommands.lua — autocommands
  - statusline/ — Galaxyline statusline config
- lua/afnan/plugins/*.lua — plugin specs grouped by domain (LSP, UI, DAP, Telescope, etc.)
- ftplugin/javascript.lua — JS-specific helpers

## Highlights & Plugins
- LSP: neovim/nvim-lspconfig, mason-org/mason.nvim, cmp-nvim-lsp
  - Pre-configured for TypeScript/JavaScript (tsserver), JSON, CSS, HTML, Lua, Bash/Zsh, Clangd, Pyright, JDTLS
  - Tailwind CSS enhancements via tailwind-tools.nvim
- Completion: nvim-cmp (see plugins/cmp.lua)
- Syntax & Structure: nvim-treesitter (+ autotag, context)
- Search/Navigation: Telescope with common pickers
- Git: gitsigns.nvim, vim-fugitive, diffview.nvim
- Files: neo-tree with window-picker and file nesting
- Debugging: nvim-dap + dap-ui + virtual text, mason-nvim-dap
- UI/UX: tokyonight (default), catppuccin, onedark, tokyodark; indent-blankline; barbecue (breadcrumbs); transparent.nvim; colorizer; devicons auto-colors; dashboard (start screen); smear-cursor; Tip.nvim
- Editing Aids: autopairs, surround, comments, tabout
- Statusline/Tabline: galaxyline.nvim, custom tabline
- Productivity: todo-comments, vim-test, compiler/coderunner utilities
- Knowledge/Integrations: Obsidian, LeetCode
- AI/Presence: GitHub Copilot, Discord presence

## Notable Keymaps
Note: Many mappings use the comma , prefix as a leader-like key. There is also heavy use of Alt (Meta) for window navigation and resizing.

Core
- k/j → gk/gj (respect wrapped lines)
- Space in normal/visual → : (command-line)
- Alt-q → :q, Alt-w → :write
- F5 →
  - In Lua buffers: write and source current file
  - In other buffers: :RunFile (code_runner)
- F6 (Lua): add rtp and source current file
- Y → y$ (yank to end of line)
- Quickfix: Ctrl-j / Ctrl-k → cnext / cprev
- Bufferline: <Tab> next buffer, <S-Tab> previous, ,bd delete buffer
- Move lines: ,J (down), ,K (up); in visual: J/K move selection
- Splits: Alt-h/j/k/l to move focus
- Resize: Alt-Arrow keys (Up/Down/Left/Right)
- Line start/end: Alt-Left (start), Alt-Right (end)
- Terminal: Esc → exit to Normal mode
- Insert: Ctrl-BS delete word back; Ctrl-v paste; Ctrl-c/Ctrl-f trigger completion menus

Files (Neo-tree)
- <leader>e → Neotree reveal
- Ctrl-n → :Neotree

Telescope
- ,tf find files; ,tr live grep; ,th help; ,tu resume; ,tt todo pickers; ,to oldfiles; ,tg git status; ,T open Telescope; ,ti import modules; ,te rest env selector

Git/Gitsigns
- Hunk actions: ,ghn next, ,ghp prev, ,ghs stage, ,ghu unstage, ,ghr reset, ,ghk preview, ,ghK inline preview
- Buffer actions: ,gbs stage buffer, ,gbr reset buffer
- General Git: ,gg. stage all, ,ggc commit, ,ggp push, ,ggP pull, ,ggo open repo in browser
- Lazy: ,l → :Lazy

Copilot
- ,cd disable, ,cp open panel

Vim Test
- ,vn nearest, ,vf file, ,vs suite, ,vl last, ,vv visit

LSP (buffer-local)
- K hover, gd definition, gD declaration, gI implementation, gR references, gr rename, ga code actions
- Diagnostics: gk next, gj previous
- Insert: Ctrl-s signature help

DAP
- <space>b toggle breakpoint; <space>gb run to cursor; <space>? eval
- F1 continue; F2 step into; F3 step over; F4 step out; F5 step back; F13 restart

JavaScript ftplugin
- In insert mode, a small helper auto-adds async to a function declaration when you type await inside it (JS buffers only)

## Usage Tips
- :Lazy opens the plugin manager
- :Mason opens the LSP/DAP/formatter manager
- :Telescope … for fuzzy finding (files, grep, help, git, etc.)
- :RunFile runs current buffer using code_runner (F5 binds to this outside Lua)
- :DiffviewOpen / :DiffviewFileHistory for advanced diffs

## Appearance
- Default colorscheme: tokyonight-night (switchable to catppuccin, onedark, tokyodark)
- Breadcrumbs via barbecue
- Indentation guides via indent-blankline
- Optional transparency via transparent.nvim (with extra groups configured)

## Configuration Notes
- Python host is set in core options to ~/.local/pipx/venvs/pynvim/bin/python
- Treesitter auto-install is enabled and large files are handled gracefully
- Diagnostics are shown via floating windows (no signcolumn icons by default)

## Troubleshooting
- Missing icons → install a Nerd Font and ensure your terminal uses it
- Telescope live grep not working → install ripgrep (rg)
- LSP not starting → open :Mason and install the server for your language
- DAP for JS requires the js-debug-adapter (handled by mason-nvim-dap). Ensure Node.js is installed
- If you use a different Python path, update vim.g.python3_host_prog in options.lua

## Credits
- Built with lazy.nvim and many fantastic plugins by the Neovim community

