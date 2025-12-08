local log = require "overseer.log"
local util = require "overseer.util"
local trouble = require "trouble"

local function cclose()
  if trouble.is_open() then trouble.close() end
end

---@param self table The component
---@param height nil|integer
---@param focus boolean
---@return boolean True if the quickfix window was opened
local function copen(self, height, focus)
  if self.qf_opened then return false end
  local cur_qf = vim.fn.getqflist { winid = 0, id = self.qf_id }
  trouble.open {
    mode = "qflist",
    focus = focus,
    win = {
      type = "split",
      size = height,
    },
    preview = {
      type = "split",
      relative = "win",
      position = "right",
      size = 0.3,
    },
  }
  self.qf_opened = true
  return cur_qf.winid == 0
end

---@type overseer.ComponentFileDefinition
return {
  desc = "Set all task output into the quickfix (on complete)",
  params = {
    errorformat = {
      desc = "See :help errorformat",
      type = "string",
      optional = true,
      default_from_task = true,
    },
    open = {
      desc = "Open the quickfix on output",
      type = "boolean",
      default = false,
    },
    open_on_match = {
      desc = "Open the quickfix when the errorformat finds a match",
      type = "boolean",
      default = false,
    },
    open_on_exit = {
      desc = "Open the quickfix when the command exits",
      type = "enum",
      choices = { "never", "failure", "always" },
      default = "never",
    },
    open_height = {
      desc = "The height of the quickfix when opened",
      type = "integer",
      optional = true,
      default = 14,
      validate = function(v) return v > 0 end,
    },
    relative_file_root = {
      desc = "Relative filepaths will be joined to this root (instead of task cwd)",
      optional = true,
      default_from_task = true,
    },
    close = {
      desc = "Close the quickfix on completion if no errorformat matches",
      type = "boolean",
      default = false,
    },
    items_only = {
      desc = "Only show lines that match the errorformat",
      type = "boolean",
      default = false,
    },
    set_diagnostics = {
      desc = "Add the matching items to vim.diagnostics",
      type = "boolean",
      default = false,
    },
    focus = {
      desc = "Focus the quickfix window when opened",
      type = "boolean",
      default = false,
    },
  },

  constructor = function(params)
    return {
      qf_id = 0,
      qf_opened = false,
      on_reset = function(self)
        self.qf_id = 0
        self.qf_opened = false
      end,
      on_exit = function(self, _, code)
        local open = params.open_on_exit == "always"
        open = open or (params.open_on_exit == "failure" and code ~= 0)
        if open then copen(self, params.open_height, params.focus) end
      end,
      on_pre_result = function(self, task)
        local bufnr = task:get_bufnr()
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)

        local exceeds_scrollback = vim.bo[bufnr].buftype == "terminal" and #lines >= vim.bo[bufnr].scrollback
        if exceeds_scrollback then
          log.warn(
            "Task(%d) '%s' exceeded the output scrollback limit (%d lines). Only the last lines will be processed for the quickfix.",
            task.id,
            task.name,
            vim.bo[bufnr].scrollback
          )
        end

        local prev_context = vim.fn.getqflist({ context = 0 }).context
        local action = " "
        -- If we have a quickfix ID, or if the current QF has a matching context, replace the list
        -- instead of creating a new one
        if prev_context == task.id or self.qf_id ~= 0 then action = "r" end
        local items
        -- Run this in the context of the task cwd so that relative filenames are parsed correctly
        util.run_in_cwd(
          params.relative_file_root or task.cwd,
          function()
            items = vim.fn.getqflist({
              lines = lines,
              efm = params.errorformat,
            }).items
          end
        )
        local valid_items = vim.tbl_filter(function(item) return item.valid == 1 end, items)
        if params.items_only then items = valid_items end

        local what = {
          title = task.name,
          context = task.id,
          items = items,
        }
        if self.qf_id ~= 0 then what.id = self.qf_id end
        vim.fn.setqflist({}, action, what)

        if vim.tbl_isempty(valid_items) then
          if params.close then
            cclose()
          elseif params.open then
            copen(self, params.open_height, params.focus)
          end
        elseif params.open_on_match or params.open then
          copen(self, params.open_height, params.focus)
        end

        if params.set_diagnostics then return {
          diagnostics = items,
        } end
      end,
    }
  end,
}
