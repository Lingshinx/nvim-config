local config = vim.fn.stdpath "config"
local dotfile = vim.env.XDG_CONFIG_HOME or "~/.config"
local picker = require("utils.plugin.snacks").picker
local function pickfile(cwd)
  return function() return Snacks.picker.files { cwd = cwd } end
end

require("which-key").add {
  { "<leader>fn", "<cmd>enew<cr>", desc = "New File" },
  { "<leader>fb", picker "buffers", desc = "Buffers" },
  { "<leader>ff", picker "files", desc = "Files" },
  { "<leader>fc", pickfile(config), desc = "Config" },
  { "<leader>f.", pickfile(dotfile), desc = "Dotfile" },
  { "<leader>fg", picker "git_files", desc = "Git" },
  { "<leader>fr", picker "recent", desc = "Recent" },
  { "<leader>fp", picker "projects", desc = "Projects" },
  { "<leader>fz", picker "zoxide", desc = "Zoxide" },
  { "<leader><space>", picker "smart", desc = "Files" },
  { "<leader>e", Snacks.explorer.open, desc = "Explorer", icon = { icon = "", color = "purple" } },
  {
    "<leader>fs",
    Snacks.scratch.open,
    desc = "Toggle Scratch Buffer",
  },
  {
    "<leader>fS",
    Snacks.scratch.select,
    desc = "Select Scratch Buffer",
  },
  {
    "<leader>fy",
    function() require("toggleterm.terminal").Terminal:new({ cmd = "yazi" }):toggle() end,
    desc = "Explorer Yazi",
    icon = "󰇥",
  },
}
