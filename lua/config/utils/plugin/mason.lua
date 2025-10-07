local registry = require "mason-registry"
return {
  install = function(pkg_name)
    if not registry.is_installed(pkg_name) and registry.has_package(pkg_name) then
      vim.notify("installing " .. pkg_name .. "..")
      local pkg = registry.get_package(pkg_name)
      pkg:install():once("closed", function()
        vim.schedule(function() vim.notify(pkg_name .. (pkg:is_installed() and " is " or " not ") .. "installed") end)
      end)
    end
  end,
}
