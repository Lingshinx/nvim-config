local mappings = {}
local index = 1

return {
  register = function(map, mode, icon)
    mappings[index] = { map, mode = mode, icon = icon }
    index = index + 1
  end,

  load = function() require("which-key").add(mappings) end,
}
