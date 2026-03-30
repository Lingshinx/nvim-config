return {
  Lang = require "utils.language.lang",
  Langs = require "utils.language.langs",

  ---@param opts config.language.Opts
  setup = function(opts)
    opts = vim.tbl_extend("keep", opts or {}, {
      rtp = "langs",
    })

    local langs = require("utils.language.langs").new()

    coroutine.wrap(function()
      local files = vim.api.nvim_get_runtime_file(opts.rtp .. "/*.lua", true)
      for _, file in ipairs(files) do
        local name = vim.fn.fnamemodify(file, ":t:r")
        local config = dofile(file)
        if not config[1] then config[1] = name end
        langs:solve(config)
      end
      langs.ok = true
      local callback = opts.hook
      if callback then callback(langs) end
    end)()

    return langs
  end,
}
