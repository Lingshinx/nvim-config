---@type utils.language.Collectors
return {
  lsp = {
    extract = true,
    each = function(lsp)
      if type(lsp) == "string" then
        vim.lsp.enable(lsp)
      elseif type(lsp) == "table" then
        for k, v in pairs(lsp) do
          if type(k) == "number" then
            vim.lsp.enable(v)
          else
            vim.lsp.config(k, v)
            vim.lsp.enable(k)
          end
        end
      end
    end,
  },

  treesitter = {
    extract = function(treesitter, name)
      if type(treesitter) == "table" then
        return treesitter
      elseif type(treesitter) == "string" then
        return { treesitter }
      elseif treesitter ~= false then
        return { name }
      end
    end,
    load = function(langs)
      local treesitters = langs:fold("treesitter", function(acc, cur) return vim.list_extend(acc, cur) end)
      if not treesitters then return end
      require("utils.plugin.treesitter").ensure_installed(treesitters)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = treesitters,
        callback = function()
          vim.treesitter.start()
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo.foldmethod = "expr"
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  plugins = {
    extract = function(plugin)
      require("utils.pack").add(plugin)
      return plugin
    end,
  },

  formatter = {
    extract = {
      table = true,
      string = function(formatter) return { formatter } end,
    },
    load = function(langs)
      local formatters_by_ft = {}
      for name, lang in pairs(langs.data) do
        formatters_by_ft[name] = lang.formatter
      end
      langs.formatters_by_ft = formatters_by_ft
    end,
  },

  option = {
    extract = true,
    each = function(options, name)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = name,
        desc = string.format("Set options for filetype %s", name),
        callback = function()
          for opt, value in pairs(options) do
            vim.opt_local[opt] = value
          end
        end,
      })
    end,
  },
}
