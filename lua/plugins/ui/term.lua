return {
  "akinsho/toggleterm.nvim",
  enable = false,
  lazy = false,
  -- I can't copy this to my system clipboard maybe because it is headless
  -- I think it is because it's neovide
  -- i cannot copy/paste in neovide with cmd-c / cmd-v
  -- But you can still yy/dd/p right? yes. dd to your system clipboard?
  -- maybe with "+yy can do this
  -- in my neovide is automatic sync
  -- look "+"
  -- yep.
  -- idk how , it sometimes workso on my pc
  -- idk too
  -- how dare you to v-select before delete
  -- ei? is that dangrous?
  -- you should d9k
  -- sorry it's so dimming i cannot see the line number
  -- oh god. my clipboard borken? or neovide broken?
  -- alright
  -- i wanna know more aboud terminal in neovide. plz show me QAQ
  -- <C-\> to toggle
  opts = {
    open_mapping = [[<C-\>]],
    hide_numbers = true,
    start_in_insert = true,
    direction = "float", --<-- this ok
    -- let me do it for my toggleterm,
    -- I'll copy'em for you
    -- :)
    float_opts = {
      border = "rounded",
      width = function()
        local min = math.ceil(vim.o.columns * 0.8)
        return min > 130 and 130 or min
      end,
      title_pos = "center",
    },
    -- it this ?
    winbar = {
      enable = true,
      name_formatter = function(term)
        return term.name
      end,
    },
  },
}
