---@class nix-mason.Profile
---@field dir string
---@field list string[]

local function make_progress_bar(percent, width)
  local filled = math.floor((percent / 100) * width)
  local empty = width - filled
  return string.rep("", filled) .. string.rep("", empty)
end

---@return string
local function get_default_profile()
  return vim.g.nix_mason_profile_dir or vim.fs.joinpath(vim.fn.stdpath "data", "nix-mason", "profile")
end

---@param err string
---@param data string
local function stderr(err, data)
  if err or not data then return end
  vim.print(data)
end

---@param cmd string[]
---@param quiet boolean?
local function system(cmd, quiet)
  vim.system(cmd, {
    stderr = quiet or stderr,
  }, function() end)
end

---@param path string
---@return string[]
local function nix_profile(path, ...)
  local cmd = { "nix", "profile", ... }
  cmd[#cmd + 1] = "--profile"
  cmd[#cmd + 1] = path
  return cmd
end

---@param pkg string
---@return string
local function parse_pack(pkg) return pkg:find "#" and pkg or "nixpkgs#" .. pkg end

---@return table<string, boolean>
local function list()
  local path = get_default_profile()

  local result = vim.system(nix_profile(path, "list", "--json")):wait()
  if result.code ~= 0 then error("failed to get profile list\n" .. result.stderr, vim.log.levels.ERROR) end
  return vim.tbl_keys(vim.json.decode(result.stdout).elements)
end

---@param quiet boolean?
---@param pkgs string[]
local function install(pkgs, quiet)
  if not pkgs or vim.tbl_isempty(pkgs) then return end
  local path = get_default_profile()
  local cmd = nix_profile(path, "add", "--log-format", "internal-json")
  if type(pkgs) == "string" then
    cmd[#cmd + 1] = parse_pack(pkgs)
  else
    vim.list_extend(cmd, vim.iter(pkgs):map(parse_pack):totable())
  end
  local warned = false
  local pkg_names = type(pkgs) == "string" and pkgs or (#pkgs > 1 and #pkgs .. " pkgs" or pkgs[1])
  vim.system(cmd, {
    stderr = quiet
      or require("utils.nix.log").log {
        ---@param msg string
        on_msg = function(msg)
          if msg:find "^  /nix/store" then return end
          local replaced, count = msg:gsub("^warning: ", "", 1)
          if count ~= 0 then
            vim.notify(replaced, vim.log.levels.WARN)
            warned = true
          else
            vim.notify(msg)
          end
        end,
        on_tasks = function(tasks)
          if tasks.done == 0 then return end
          local mb_total = math.floor(tasks.total / 1024 / 1024)
          local mb_done = math.floor(tasks.done / 1024 / 1024)
          local percentage = tasks:percentage()
          if percentage < 95 then
            local bar = make_progress_bar(percentage, 20)
            vim.print(string.format("installing %s...\n%s %.1f MB / %.1f MB", pkg_names, bar, mb_done, mb_total))
          else
            vim.print(
              string.format(
                "installing %s...\n %.1f MB / %.1f MB",
                pkg_names,
                mb_done,
                mb_total
              )
            )
          end
        end,
      },
  }, function()
    if warned then return end
    vim.notify(pkg_names .. " installed")
  end)
end

---@param pkgs string[]
local function ensure_installed(pkgs, quiet)
  if not pkgs or vim.tbl_isempty(pkgs) then return end
  local path = get_default_profile()
  vim.system(
    { vim.fs.joinpath(vim.fn.stdpath "config", "scripts", "nix-need"), "--profile", path, unpack(pkgs) },
    { stdout = true, stderr = true },
    function(result)
      if result.code ~= 0 then
        vim.notify(result.stderr, vim.log.levels.ERROR)
        return
      end
      pkgs = vim.split(result.stdout, "\n", { plain = true })
      if pkgs[1] == "" then
        vim.notify("No pkg need to install", vim.log.levels.WARN)
        return
      end
      install(pkgs, quiet)
    end
  )
end

---@param pkgs string[]?
---@param quiet boolean?
local function update(pkgs, quiet)
  if not pkgs or vim.tbl_isempty(pkgs) then return end
  local path = get_default_profile()

  local cmd = pkgs and nix_profile(path, "upgrade", "--all")
    or nix_profile(path, "upgrade", type(pkgs) == "string" and pkgs or unpack(pkgs)) ---@diagnostic disable-line

  system(cmd, quiet)
end

---@param pkgs string[]?
---@param quiet boolean?
local function remove(pkgs, quiet)
  if not pkgs or vim.tbl_isempty(pkgs) then return end
  local path = get_default_profile()

  if not pkgs or not pkgs[1] then
    vim.notify("At least one argument is needed", vim.log.levels.ERROR)
    return
  end
  if type(pkgs) == "table" then
    for _, pkg in ipairs(pkgs) do
      local cmd = nix_profile(path, "remove", pkg)
      system(cmd, quiet)
    end
  else
    local cmd = nix_profile(path, "remove", pkgs)
    system(cmd, quiet)
  end
end

local function setup()
  local path = get_default_profile()
  vim.fn.mkdir(vim.fs.dirname(path), "p")
  vim.env.PATH = vim.fs.joinpath(path, "bin") .. ":" .. vim.env.PATH
  require("utils.manager").register {
    nix = {
      install = function(pkgs)
        if not pkgs or vim.tbl_isempty(pkgs) then
          ensure_installed(require "utils.language.pkgs"())
        else
          install(pkgs)
        end
      end,
      update = function(pkgs) update(pkgs) end,
      clean = function()
        local pkgs_contains = require("utils.fn").contains_map(require "utils.language.pkgs"())
        local to_uninstall = vim.iter(list()):filter(function(pkg) return not pkgs_contains[pkg] end):totable()
        remove(to_uninstall)
      end,
    },
  }
end

return {
  remove = remove,
  list = list,
  update = update,
  install = install,
  ensure_installed = ensure_installed,
  setup = setup,
}
