local config = vim.fn.stdpath "config"
local dotfile = vim.env.XDG_CONFIG_HOME or "~/.config"
local function picker(name) return Snacks.picker[name] end
local function pickfile(cwd)
  return function() return Snacks.picker.files { cwd = cwd } end
end

-- stylua: ignore
require("which-key").add({
  { "<leader>fn", "<cmd>enew<cr>", desc = "New File" },
	{ "<leader>fb", picker("buffers"), desc = "Buffers" },
	{ "<leader>fc", pickfile(config), desc = "Config" },
	{ "<leader>f.", pickfile(dotfile), desc = "Dotfile" },
	{ "<leader>fg", picker("git_files"), desc = "Git" },
	{ "<leader>fr", picker("recent"), desc = "Recent" },
	{ "<leader>fp", picker("projects"), desc = "Projects" },
  { "<leader><space>", picker("files"), desc = "Files" },
  { "<leader>e", Snacks.explorer.open, desc = "Explorer", icon = { icon = "", color = "purple" } },
  { "<leader>fy", function() require("toggleterm.terminal").Terminal:new({ cmd = "yazi" }):toggle() end, desc = "Explorer Yazi", icon = "󰇥" }
})
