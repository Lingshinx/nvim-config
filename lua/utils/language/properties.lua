local after = require("utils.pack").after_wrap

local function get_lspnames(lsp)
  if type(lsp) == "string" then
    return { lsp }
  elseif type(lsp) == "table" then
    return vim.iter(pairs(lsp)):map(function(k, v) return type(k) == "number" and v or k end):totable()
  end
end

---@type utils.language.Properties
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
    default = true,
    extract = function(treesitter) return treesitter ~= false end,
    collect = function(acc, treesitter, name)
      if type(treesitter) == "table" then
        vim.list_extend(acc, treesitter)
      elseif type(treesitter) == "string" then
        acc[#acc + 1] = treesitter
      elseif treesitter == true then
        acc[#acc + 1] = name
      end
    end,
    load = function(langs)
      local treesitters = langs.treesitter
      if not treesitters or vim.tbl_isempty(treesitters) then return end
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

  plugin = {
    extract = function(plugin) require("utils.pack").add(plugin) end,
  },

  formatter = {
    extract = {
      table = true,
      string = function(formatter) return { formatter } end,
    },
    collect = function(acc, formatter, name)
      if type(formatter) == "string" then
        acc[name] = { formatter }
      elseif type(formatter) == "table" then
        acc[name] = formatter
      end
    end,
    load = after("conform.nvim", function(langs) require("conform").formatters_by_ft = langs.formatter end),
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

  filetype = {
    collect = function(acc, filetype, name)
      if not acc.inited then
        acc.inited = true
        acc.extension = {}
        acc.filename = {}
        acc.pattern = {}
      end
      for _, key in ipairs { "extension", "filename", "pattern" } do
        local value = filetype[key]
        local property_acc = acc[key]
        if value then
          if type(value) == "string" then
            property_acc[value] = name
          elseif type(value) == "table" then
            for k, v in pairs(value) do
              if type(k) == "number" then
                property_acc[value] = name
              elseif type(k) == "string" then
                property_acc[k] = v
              end
            end
          end
        end
      end
    end,
    load = function(langs) vim.filetype.add(langs.filetype) end,
  },

  parser = {
    extract = {
      table = true,
      string = function(parser) return { url = parser } end,
    },
    load = after("nvim-treesitter", function(langs)
      for name, lang in ipairs(langs.data) do
        if lang.parser then require("nvim-treesitter.parsers")[name] = lang.parser end
      end
    end),
  },

  package = {
    collect = function(acc, packages)
      if type(packages) == "string" then
        acc[#acc + 1] = packages
      elseif type(packages) == "table" then
        vim.list_extend(acc, packages)
      end
    end,
    load = function(langs)
      local packages = langs.package
      for _, lang in pairs(langs.data) do
        if lang.lsp then vim.list_extend(packages, get_lspnames(lang.lsp)) end
      end
      vim.list_extend(packages, vim.iter(vim.tbl_values(langs.formatter)):flatten():totable())
      if vim.g.config_installer == "mason" then
        require("utils.pack").after("mason.nvim", function()
          local install = require("utils.plugin.mason").install
          for _, pkg in ipairs(packages) do
            install(pkg)
          end
        end)
      elseif vim.g.config_installer == "nix" then
        require("nix-mason").ensure_installed(packages)
      end
    end,
  },
}
