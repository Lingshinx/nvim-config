-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Globals
vim.g.root_pattern = { ".git", "lua", ".nvim" }

-- Persistence
vim.o.undofile = true
vim.o.undolevels = 10000
vim.o.shada = "'100,<0"
vim.o.swapfile = false
vim.opt.sessionoptions:append { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Appearance
vim.o.background = "dark"
vim.o.number = true -- Print line number
vim.o.laststatus = 3 -- global statusline
vim.o.wrap = false -- Disable line wrap
vim.o.list = true -- Show some invisible characters (tabs...
vim.o.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
vim.o.termguicolors = true -- True color support
vim.o.cursorline = true -- Enable highlighting of the current line
vim.o.relativenumber = true -- Relative line numbers
vim.o.pumblend = 10 -- Popup blend
vim.o.pumheight = 10 -- Maximum number of entries in a popup
vim.o.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
vim.o.showmode = false -- Dont show mode since we have a statusline
vim.o.ruler = false -- Disable the default ruler

-- Fold
vim.o.foldlevel = 99
vim.o.foldmethod = "expr"
vim.o.foldtext = ""
vim.opt.fillchars = { foldopen = "", foldclose = "", fold = " ", foldsep = " ", diff = "╱", eob = " " }

-- Format
vim.g.autoformat = true
vim.o.formatoptions = "jcroqlnt" -- tcqj

-- Indent
vim.o.expandtab = true -- Use spaces instead of tabs
vim.o.tabstop = 2 -- Number of spaces tabs count for
vim.o.linebreak = true -- Wrap lines at convenient points
vim.o.smartindent = true -- Insert indents automatically
vim.o.shiftround = true -- Round indent
vim.o.shiftwidth = 2 -- Size of an indent

-- Search & Replace
vim.o.grepformat = "%f:%l:%c:%m"
vim.o.grepprg = "rg --vimgrep"
vim.o.ignorecase = true -- Ignore case
vim.o.smartcase = true -- Don't ignore case with capitals
vim.o.wrap = false -- Disable line wrap
vim.o.inccommand = "nosplit" -- preview incremental substitute

-- Navigate
vim.o.jumpoptions = "stack"
vim.o.scrolloff = 4 -- Minimal number of screen lines to keep above and below the cursor.
vim.o.sidescrolloff = 8 -- Columns of context

-- Edit
vim.o.mouse = "a" -- Enable mouse mode
vim.opt.shortmess:append { W = true, I = true, c = true, C = true }
vim.o.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
vim.o.autowrite = true -- Auto write when switching buffer
vim.o.completeopt = "menu,menuone,noselect"
vim.o.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard

-- WinBuf
vim.o.splitright = true -- Put new windows right of current
vim.o.splitbelow = true -- Put new windows below current
vim.o.splitkeep = "screen"
vim.o.winminwidth = 5 -- Minimum window width

-- Time
vim.o.updatetime = 200 -- CursorHold
vim.o.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key

-- Command Line
vim.o.wildmode = "longest:full,full" -- Command-line completion mode
vim.o.confirm = true -- Confirm to save changes before exiting modified buffer
