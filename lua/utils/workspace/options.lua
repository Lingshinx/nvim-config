local is_file_in = require("utils.workspace.fn").is_file_in

return {
  handle_file = function(options, opts)
    if not options then return end
    local callback = function(event)
      local file = vim.api.nvim_buf_get_name(event and event.buf or 0)
      if not is_file_in(opts.root, file) then return end
      for opt, value in pairs(options or {}) do
        vim.opt_local[opt] = value
      end
    end
    callback()
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
      desc = string.format("Set options in workspace %s", opts.root),
      callback = callback,
    })
  end,
}
