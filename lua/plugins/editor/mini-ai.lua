local function all_buffer()
  local start_line, end_line = 1, vim.fn.line("$")
              if ai_type == "i" then
                -- Skip first and last blank lines for `i` textobject
                local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
                -- Do nothing for buffer with all blanks
                if first_nonblank == 0 or last_nonblank == 0 then
                  return { from = { line = start_line, col = 1 } }
                end
                start_line, end_line = first_nonblank, last_nonblank
              end

              local to_col = math.max(vim.fn.getline(end_line):len(), 1)
              return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
end 

return { 'echasnovski/mini.ai',
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" }, -- digits
          e = { -- word with case
            { "%u[%l%d]+%f[^%l%d]", "%f[%s][%l%d]+%f[^%l%d]", "%f[%p][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          g = all_buffer,
          u = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
      }
    end,
}
