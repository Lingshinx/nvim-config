local function all_buffer()
  local start_line, end_line = 1, vim.fn.line "$"
  if ai_type == "i" then
    -- Skip first and last blank lines for `i` textobject
    local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
    -- Do nothing for buffer with all blanks
    if first_nonblank == 0 or last_nonblank == 0 then return { from = { line = start_line, col = 1 } } end
    start_line, end_line = first_nonblank, last_nonblank
  end

  local to_col = math.max(vim.fn.getline(end_line):len(), 1)
  return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
end

return {
  "echasnovski/mini.ai",
  event = "VeryLazy",
  opts = function()
    ---@module "which-key"
    ---@type wk.Spec[]
    local list = require "utils.list"
    local keys = { mode = { "o", "x" } }
    local objects = {
      { " ", desc = "whitespace" },
      { '"', desc = '"' },
      { "'", desc = "'" },
      { "(", desc = "()" },
      { ")", desc = "()" },
      { "<", desc = "<>" },
      { ">", desc = "<>" },
      { "?", desc = "user prompt" },
      { "U", desc = "use/call" },
      { "[", desc = "[]" },
      { "]", desc = "[]" },
      { "_", desc = "underscore" },
      { "`", desc = "`" },
      { "a", desc = "argument" },
      { "b", desc = ")]} " },
      { "c", desc = "class" },
      { "d", desc = "digit" },
      { "e", desc = "CamelCase / snake_case" },
      { "f", desc = "function" },
      { "g", desc = "global file" },
      { "i", desc = "indent" },
      { "o", desc = "block, conditional, loop" },
      { "q", desc = "quote `\"'" },
      { "t", desc = "tag" },
      { "u", desc = "use/call" },
      { "{", desc = "{}" },
      { "}", desc = "{}" },
    }
    local mappings = {
      a = "around",
      i = "inside",
      ["a]"] = "next",
      ["i]"] = "next",
      ["a["] = "prev",
      ["i["] = "prev",
    }
    for prefix, name in pairs(mappings) do
      list.append(keys, { prefix, group = name })
      for _, obj in pairs(objects) do
        list.append(keys, { prefix .. obj[1], desc = obj.desc })
      end
    end
    require("which-key").add(keys, { notify = false })

    local ai = require "mini.ai"
    return {
      n_lines = 500,
      custom_textobjects = {
        o = ai.gen_spec.treesitter { -- code block
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        },
        f = ai.gen_spec.treesitter { a = "@function.outer", i = "@function.inner" }, -- function
        c = ai.gen_spec.treesitter { a = "@class.outer", i = "@class.inner" }, -- class
        t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
        d = { "%f[%d]%d+" }, -- digits
        e = { "%u?%f[%l%d][%l%d]+" }, -- word with case
        g = all_buffer,
        u = ai.gen_spec.function_call(), -- u for "usage"
        U = ai.gen_spec.function_call { name_pattern = "[%w_]" }, -- without dot in function name
      },
    }
  end,
}
