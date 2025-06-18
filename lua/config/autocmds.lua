-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Git stage on VimLeave event
vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    local git_path = Snacks.git.get_root()
    if git_path then
      vim.system({ "git", "stage", "." })
    end
  end,
})

vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
