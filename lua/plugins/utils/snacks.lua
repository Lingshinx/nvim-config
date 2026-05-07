return {
  {
    "folke/snacks.nvim",
    lazy = false,
    cmd = { "Pick", "PickFiles" },
    keys = {
      {
        "<Plug>(ConfigOpenTerminal)",
        require("utils.plugin.snacks").open_terminal,
        desc = "ToggleTerm",
        mode = { "n", "i", "x", "t" },
      },
      {
        "<Plug>(ConfigNotifications)",
        function() Snacks.notifier.show_history() end,
        desc = "Notifications",
      },
      {
        "K",
        require("utils.plugin.snacks").hover_image,
        desc = "Image hover",
        ft = "markdown",
      },
      {
        "<Plug>(ConfigLazygit)",
        function() Snacks.lazygit() end,
      },
    },
    ---@module "snacks"
    ---@type snacks.Config
    opts = {
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      bigfile = { enabled = true },
      zen = { enabled = true },
      input = { enabled = true },
      dim = { enabled = true },
      indent = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      explorer = { enabled = true },
      words = { enabled = true },
      styles = {
        input = { relative = "cursor", row = -3, col = 3 },
        terminal = {
          border = "rounded",
        },
      },
    },
    after = function(spec)
      local snacks = require "snacks"
      snacks.setup(spec.opts)
      local sources = require "snacks.picker.config.sources"
      sources.filetypes = require "config.pickers.filetypes"
      sources.tabpages = require "config.pickers.tabpages"
      vim.o.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
      vim.api.nvim_create_user_command("Pick", function(opts) snacks.picker[opts.args]() end, {
        nargs = 1,
        desc = "Snacks picker wrapper",
      })
      vim.api.nvim_create_user_command("PickFiles", function(opts) snacks.picker.files { cwd = opts.args } end, {
        nargs = 1,
        desc = "Snacks pick files wrapper",
      })
    end,
  },
}
