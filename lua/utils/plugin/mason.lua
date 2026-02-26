return {
  get_path = function(pkg_name, path)
    return (vim.env.MASON or (vim.fn.stdpath "data" .. "/mason")) .. "/packages" .. pkg_name .. "/" .. path
  end,
  install = function(pkg_name)
    local registry = require "mason-registry"
    if not registry.is_installed(pkg_name) and registry.has_package(pkg_name) then
      local pkg = registry.get_package(pkg_name)
      local all_installed = not vim.iter(pkg.spec.bin):any(function(k, _) return not vim.fn.executable(k) end)
      if all_installed then return end
      vim.notify("installing " .. pkg_name .. "..")
      pkg:install():once("closed", function()
        vim.schedule(function() vim.notify(pkg_name .. (pkg:is_installed() and " is " or " not ") .. "installed") end)
      end)
    end
  end,
}
