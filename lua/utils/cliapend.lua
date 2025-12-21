local autocmd_id

---@class config.cliapend.Opts
---@field register? string
---@field yank_only? boolean
---@field keymap? {toggle?:string, paste_prefix?:string}

local function off(opts)
  vim.api.nvim_del_autocmd(autocmd_id)
  autocmd_id = nil
  for _, key in ipairs { "p", "P" } do
    vim.keymap.del({ "n", "x" }, opts.keymap.paste_prefix .. key)
  end
end

local function autocmd_opts(opts)
  return {
    callback = function()
      if (not opts.yank_only or vim.v.event.operator == "y") and vim.v.event.regname == "" then
        vim.fn.setreg(string.upper(opts.register), vim.fn.getreg())
      end
    end,
  }
end

local function paste(key, opts)
  return function()
    vim.cmd.norm('"' .. opts.register .. key)
    off(opts)
  end
end

local function on(opts)
  vim.fn.setreg(opts.register, "")
  for key, desc in pairs { p = "after", P = "before" } do
    vim.keymap.set({ "n", "x" }, opts.keymap.paste_prefix .. key, paste(key, opts), { desc = "Paste " .. desc })
  end
  autocmd_id = vim.api.nvim_create_autocmd("TextYankPost", autocmd_opts(opts))
end

return {
  ---@param opts? config.cliapend.Opts
  setup = function(opts)
    opts = vim.tbl_deep_extend("force", {
      register = "x",
      yank_only = false,
      keymap = {
        toggle = "<leader>uy",
        paste_prefix = "g",
      },
    }, opts or {})

    Snacks.toggle
      .new({
        id = "clipboard",
        name = "Clipboard Append",
        get = function() return autocmd_id end,
        set = function(state)
          if state then
            on(opts)
          else
            off(opts)
          end
        end,
      })
      :map(opts.keymap.toggle)
  end,
}
