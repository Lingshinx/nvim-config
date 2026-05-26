local langs = require("utils.language.langs").new()

local files = vim.api.nvim_get_runtime_file("langs/*.lua", true)
for _, file in ipairs(files) do
  local name = vim.fn.fnamemodify(file, ":t:r")
  local config = dofile(file)
  if config then
    if not config[1] then config[1] = name end
    langs:solve(config)
  end
end

return langs
