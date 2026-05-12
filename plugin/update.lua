require("utils.command").create("Update", {
  treesitter = {
    cmd = function(args, opts)
      if opts.bang then require("utils.update").clean.treesitter() end
      require("utils.update").update.treesitter(args)
    end,
    complete = function(arg_lead)
      if not package.loaded["nvim-treesitter"] then require("lz.n").trigger_load "nvim-treesitter" end
      local installed = require("nvim-treesitter").get_installed()
      if arg_lead:sub(-1) == " " then return installed end
      local args = vim.split(arg_lead, "%s+")
      local last_args = args[#args]
      return vim.iter(installed):filter(function(parser) return parser:find("^" .. last_args) end):totable()
    end,
  },
})
