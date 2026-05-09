vim.api.nvim_create_user_command("Update", function(opts) require("utils.update").update(opts.args) end, {
  nargs = 1,
  complete = function() return vim.tbl_keys(require("utils.update").updaters) end,
})
