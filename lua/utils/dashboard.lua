---@class utils.dashboard.Notification
---@field name string
---@field title string
---@field unread boolean
---@field type string
---@field time string

local M = {}

local query = [[
map({ name: .repository.full_name, reason, unread, title: .subject.title, type: .subject.type, time: (.updated_at | fromdate | strftime("%d/%b"))})
]]

local fn = require "utils.fn"

local function is_full_size() return vim.o.columns > 135 end

local function gh_notify(cb, opts)
  vim.system({
    "gh",
    "api",
    "notifications",
    "-X",
    "GET",
    "-f",
    "per_page=" .. tostring(math.floor(opts.height / 2)),
    "-f",
    "all=true",
    "--cache",
    "1h",
    "-q",
    query,
  }, {}, function(result)
    if result.code ~= 0 then
      Snacks.notify(result.stderr, { level = "warn" })
      return
    end
    cb(vim.json.decode(result.stdout))
  end)
end

---@param opts snacks.dashboard.Item
---@return snacks.dashboard.Item
function M.make_side_panel(opts)
  return vim.tbl_extend("keep", opts, {
    indent = 3,
    padding = 1,
    pane = 2,
    enabled = is_full_size,
  })
end

local newline = { "\n" }
local space = { " " }

---@param result utils.dashboard.Notification[]
---@param opts table
---@return snacks.dashboard.Text[]
local function format(result, opts)
  local max = vim
    .iter(result)
    :map(function(x) return #x.reason end)
    :fold(0, function(acc, v) return math.max(acc, v) end)
  local ret = vim
    .iter(result)
    :map(
      function(notification)
        return {
          { notification.time, hl = notification.unread or "Comment", width = max },
          space,
          { notification.name, hl = "Include" },
          space,
          { notification.type, hl = "Constant" },
          newline,
          { fn.capitalize(notification.reason), hl = "WarningMsg", width = max },
          space,
          { fn.truncate(notification.title, opts.width - max, "…"), hl = "String" },
          newline,
        }
      end
    )
    :flatten(1)
  ret:pop()
  return ret:totable()
end

function M.notification(opts)
  opts = vim.tbl_extend("force", {
    width = 57,
    height = 10,
  }, opts or {})
  opts.text = ("\n"):rep(opts.height)
  ---@type snacks.dashboard.Gen
  gh_notify(
    vim.schedule_wrap(function(result)
      opts.text = format(result, opts)
      vim.wait(1000, function() return Snacks ~= nil end)
      Snacks.dashboard.update()
    end),
    opts
  )
  return function() return opts end
end

return M
