vim.opt.makeprg = "fish %"
vim.opt.errorformat = vim.env.LC_MESSAGES == "zh_CN.UTF-8"
    and {
      "%Afish: %m",
      "%Z%f (行 %l): ",
      "%f (行 %l): %m",
    }
  or {
    "%Afish: %m",
    "%Z%f (line %l): ",
    "%f (line %l): %m",
  }
