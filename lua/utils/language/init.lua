return {
  Lang = require "utils.language.lang",
  Langs = require "utils.language.langs",

  setup = function(opts)
    opts = vim.tbl_extend("keep", opts or {}, {
      rtp = vim.fn.stdpath "config",
      mod = "config.langs",
    })

    local langs = require("utils.language.langs").new()
    require("utils.fs").load_each(opts.rtp, opts.mod, function(name, config)
      if not config[1] then config[1] = name end
      langs:solve(config)
    end)
    if opts.auto_config then langs:config() end
    return langs
  end,
}
