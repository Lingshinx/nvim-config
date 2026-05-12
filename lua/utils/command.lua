---@alias nix-mason.Subcommand fun(args:string[], opts: vim.api.keyset.create_user_command.command_args)

---@class nix-mason.SubcommandOpt
---@field cmd fun(args:string[], opts: vim.api.keyset.create_user_command.command_args) The command implementation
---@field complete? fun(subcmd_arg_lead: string): string[] (optional) Command completions callback, taking the lead of the subcommand's arguments

return {
  ---@param subcommands table<string, nix-mason.SubcommandOpt|nix-mason.Subcommand>
  create = function(name, subcommands)
    vim.api.nvim_create_user_command(name, function(opts)
      local fargs = opts.fargs
      local subcommand_key = fargs[1]
      -- Get the subcommand's arguments, if any
      local args = #fargs > 1 and vim.list_slice(fargs, 2, #fargs) or {}
      local subcommand = subcommands[subcommand_key]
      if not subcommand then
        vim.notify("Rocks: Unknown command: " .. subcommand_key, vim.log.levels.ERROR)
        return
      end
      -- Invoke the subcommand
      if type(subcommand) == "function" then
        subcommand(args, opts)
      elseif type(subcommand) == "table" and subcommand.cmd then
        subcommand.cmd(args, opts)
      end
    end, {
      bang = true,
      nargs = "+",
      desc = "Commands to manage nix mason",
      complete = function(arg_lead, cmdline, _)
        local subcmd_key, subcmd_arg_lead = cmdline:match("^['<,'>]*" .. name .. "[!]*%s(%S+)%s(.*)$")
        if
          subcmd_key
          and subcmd_arg_lead
          and type(subcommands[subcmd_key]) == "table"
          and subcommands[subcmd_key].complete
        then
          return subcommands[subcmd_key].complete(subcmd_arg_lead)
        end
        if cmdline:match "^['<,'>]*" .. name .. "[!]*%s+%w*$" then
          local subcommand_keys = vim.tbl_keys(subcommands)
          return vim.iter(subcommand_keys):filter(function(key) return key:find(arg_lead) ~= nil end):totable()
        end
      end,
    })
  end,
}
