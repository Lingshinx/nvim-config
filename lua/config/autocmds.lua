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

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  callback = function()
    if vim.bo.buftype ~= "" or vim.o.filetype == "oil" then
      return
    end

    local file = vim.fn.expand("%:p:h")
    local root = LazyVim.root()
    if file == "" then
      return
    elseif root == "/home/lingshin" then
      vim.fn.chdir(file)
    else
      vim.fn.chdir(vim.startswith(file, root) and root or file)
    end
  end,
})

vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
