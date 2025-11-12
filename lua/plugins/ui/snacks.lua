local function pick(cmd)
  return function() Snacks.dashboard.pick(cmd) end
end
local function pickfiles(cwd)
  return function() Snacks.dashboard.pick("files", { cwd = cwd }) end
end
local function is_full_size() return vim.o.columns > 135 end
local function make_side_panel(opts)
  return vim.tbl_extend("keep", opts, {
    section = opts.section,
    icon = opts.icon,
    title = opts.title,
    indent = 3,
    padding = 1,
    pane = 2,
    enabled = is_full_size,
  })
end

local config_dir = vim.fn.stdpath "config"
local dot_dir = vim.env.XDG_CONFIG_HOME or "~/.config"
local logo = [[
         ████                                             
        ██  ──聆噺讨厌写代码─󰫢─ █                    
    𓇼  ██                 ████ █  ⟡                   
      ██ ██ ████ █████ █     ██████ ██     
     ██ ██ ████ ████████████ █ ████      
    ██ ██ ████ █ █ █  █ █ ████      ⟡ 
  ████████████ ████████████ ████████ ████       
                        █                                 
          ███████████████       ⛧                         
]]
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    dashboard = {
      ---@type snacks.dashboard.Section
      sections = {
        { section = "header" },
        make_side_panel {
          section = "terminal",
          cmd = [[ gh notify -san 5 | choose .. -f '#\d+'\033'\[0m\s+' -o '\n   ' ]],
          height = 10,
          ttl = 5 * 100,
          icon = "",
          title = "Notification",
        },
        make_side_panel {
          section = "projects",
          title = "Projects",
          icon = "",
        },
        make_side_panel {
          section = "recent_files",
          title = "Recents",
          icon = "",
        },
        { section = "keys", gap = 1, indent = 2, padding = 1 },
        { section = "startup", indent = 2, padding = 1, pane = 2 },
      },
      preset = {
        header = logo,
        ---@type snacks.dashboard.Item[]

        keys = {
          { icon = " ", key = "f", desc = "Find File", action = pick "files" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "r", desc = "Recent Files", action = pick "oldfiles" },
          { icon = " ", key = ".", desc = "Dot Files", action = pickfiles(dot_dir) },
          { icon = " ", key = "c", desc = "Config", action = pickfiles(config_dir) },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          {
            icon = "󰒲 ",
            key = "l",
            desc = "Lazy",
            action = ":Lazy",
            enabled = package.loaded.lazy ~= nil,
          },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
    },
  },
}
