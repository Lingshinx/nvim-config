local function pick(cmd)
	return function()
		Snacks.dashboard.pick(cmd)
	end
end
local function pickfiles(cwd)
	return function()
		Snacks.dashboard.pick("files", { cwd = cwd })
	end
end
local config_dir = vim.fn.stdpath("config")
local dot_dir = vim.env.XDG_CONFIG_HOME or "~/.config"
local logo = [[
     ██╗     ██╗███╗   ██╗ ██████╗ ███████╗██╗  ██╗██╗███╗   ██╗██╗     
     ██║     ██║████╗  ██║██╔════╝ ██╔════╝██║  ██║██║████╗  ██║██║    ⟡
     ██║ ⛧   ██║██╔██╗ ██║██║  ███╗███████╗███████║██║██╔██╗ ██║██║     
     ██║     ██║██║╚██╗██║██║   ██║╚════██║██╔══██║██║██║╚██╗██║╚═╝ ⟡   
 𓇼   ███████╗██║██║ ╚████║╚██████╔╝███████║██║  ██║██║██║ ╚████║██╗  ⟡  
     ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚═╝     
                                -------------聆噺讨厌写代码             
]]
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = function()
		---@type snacks.Config
		return {
			scroll = { enabled = true },
			statuscolumn = { enabled = true },
			dashboard = {
				preset = {
					header = logo,
          -- stylua: ignore
					---@type snacks.dashboard.Item[]
					keys = {
						{ icon = " ", key = "f", desc = "Find File", action =  pick("files") , },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "r", desc = "Recent Files", action = pick("oldfiles") },
						{ icon = " ", key = ".", desc = "Dot Files", action =  pickfiles(dot_dir) },
						{ icon = " ", key = "c", desc = "Config", action = pickfiles(config_dir) },
						{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
						{ icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" }
					},
				},
			},
		}
	end,
}
