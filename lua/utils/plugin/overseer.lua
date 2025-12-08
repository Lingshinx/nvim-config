local overseer = require "overseer"
local create_cmd = vim.api.nvim_create_user_command

-- replace `on_output_quickfix` with `trouble.nvim`
overseer.add_template_hook(nil, function(task_defn, util)
  if util.has_component(task_defn, "on_output_quickfix") then
    util.remove_component(task_defn, { "on_output_quickfix" })
    util.add_component(task_defn, { "lingshin.on_output_trouble", open_on_exit = "failure", close = true })
  end
end)

create_cmd("OverseerRestartLast", function()
  local task_list = require "overseer.task_list"
  local tasks = overseer.list_tasks {
    status = {
      overseer.STATUS.SUCCESS,
      overseer.STATUS.FAILURE,
      overseer.STATUS.CANCELED,
    },
    sort = task_list.sort_finished_recently,
  }
  if vim.tbl_isempty(tasks) then
    require("overseer.commands").run_template {}
  else
    local most_recent = tasks[1]
    overseer.run_action(most_recent, "restart")
  end
end, {})

create_cmd("Make", function(params)
  local cmd, num_subs = vim.o.makeprg:gsub("%$%*", params.args)
  if num_subs == 0 then cmd = cmd .. " " .. params.args end
  local task = overseer.new_task {
    cmd = vim.fn.expandcmd(cmd),
    components = {
      { "lingshin.on_output_trouble", open_on_match = not params.bang, close = true, set_diagnostics = true },
      "on_result_diagnostics",
      "default",
    },
  }
  task:start()
end, {
  desc = "Run your makeprg as an Overseer task",
  nargs = "*",
  bang = true,
})

create_cmd("Grep", function(params)
  -- Insert args at the '$*' in the grepprg
  local cmd, num_subs = vim.o.grepprg:gsub("%$%*", params.args)
  if num_subs == 0 then cmd = cmd .. " " .. params.args end
  local task = overseer.new_task {
    cmd = vim.fn.expandcmd(cmd),
    components = {
      {
        "lingshin.on_output_trouble",
        errorformat = vim.o.grepformat,
        open_on_match = not params.bang,
        items_only = true,
      },
      -- We don't care to keep this around as long as most tasks
      { "on_complete_dispose", timeout = 30 },
      "default",
    },
  }
  task:start()
end, { nargs = "*", bang = true, complete = "file" })
