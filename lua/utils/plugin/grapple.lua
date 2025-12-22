return {
  ---@type grapple.hook_fn
  tag_hook = function(window)
    local Grapple = require "grapple"
    local TagActions = require "grapple.tag_actions"
    local app = Grapple.app()

    -- Select
    window:map("n", "<cr>", function()
      local cursor = window:cursor()
      window:perform_close(TagActions.select, { index = cursor[1], command = vim.cmd.drop })
    end, { desc = "Select" })

    -- Select (horizontal split)
    window:map("n", "-", function()
      local cursor = window:cursor()
      window:perform_close(TagActions.select, { index = cursor[1], command = vim.cmd.split })
    end, { desc = "Select (split)" })

    -- Select (vertical split)
    window:map("n", "|", function()
      local cursor = window:cursor()
      window:perform_close(TagActions.select, { index = cursor[1], command = vim.cmd.vsplit })
    end, { desc = "Select (vsplit)" })

    -- Select (new tab)
    window:map("n", "|", function()
      local cursor = window:cursor()
      window:perform_close(TagActions.select, { index = cursor[1], command = vim.cmd.tabdrop })
    end, { desc = "Select (vsplit)" })

    -- Quick select
    for i, quick in ipairs(app.settings:quick_select()) do
      window:map(
        "n",
        string.format("%s", quick),
        function() window:perform_close(TagActions.select, { index = i, command = vim.cmd.drop }) end,
        { desc = string.format("Quick select %d", i) }
      )
    end

    -- Quickfix list
    window:map("n", "<c-q>", function() window:perform_close(TagActions.quickfix) end, { desc = "Quickfix" })

    -- Go "up" to scopes
    window:map("n", "<BS>", function() window:perform_close(TagActions.open_scopes) end, { desc = "Go to scopes" })

    -- Rename
    window:map("n", "R", function()
      local entry = window:current_entry()
      local path = entry.data.path
      window:perform_retain(TagActions.rename, { path = path })
    end, { desc = "Rename" })

    -- Help
    window:map("n", "?", function()
      local WindowActions = require "grapple.window_actions"
      window:perform_retain(WindowActions.help)
    end, { desc = "Help" })
  end,
}
