local map = require "utils.keymaps"

local function need_wk(mapping) return mapping.icon or mapping.group end

local dir = vim.fn.stdpath "config" .. "/lua/config/keymaps"

require("utils.load").ls(dir, {
  recursive = true,
  after = vim.schedule_wrap(function(files)
    local wk_mappings = {}
    local ft_mappings = {}
    local mappings = {}

    for _, file in ipairs(files) do
      print(files)
      local keymaps = dofile(file)
      if keymaps then
        for _, keymap in ipairs(keymaps) do
          if need_wk(keymap) then
            wk_mappings[#wk_mappings + 1] = keymap
          elseif keymap.ft then
            local ft_map = ft_mappings[keymap.ft]
            ft_map[#ft_map + 1] = keymap
          else
            mappings[#mappings + 1] = keymap
          end
        end
      end
    end

    map.add(mappings)
    map.add_ft(ft_mappings)
    require("which-key").add(wk_mappings)
  end),
})
