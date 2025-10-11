return {
  get_path = function(pkg_name, path)
    return (vim.env.MASON or (vim.fn.stdpath "data" .. "/mason")) .. "/packages" .. pkg_name .. "/" .. path
  end,
  install = function(pkg_name)
    local registry = require "mason-registry"
    if not registry.is_installed(pkg_name) and registry.has_package(pkg_name) then
      vim.notify("installing " .. pkg_name .. "..")
      local pkg = registry.get_package(pkg_name)
      pkg:install():once("closed", function()
        vim.schedule(function() vim.notify(pkg_name .. (pkg:is_installed() and " is " or " not ") .. "installed") end)
      end)
    end
  end,
}
