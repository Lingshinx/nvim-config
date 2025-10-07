return {
  ls = function(dir, callback)
    local files = vim.uv.fs_scandir(dir)
    while files do
      local file, _ = vim.uv.fs_scandir_next(files)
      if not file then break end
      callback(file)
    end
  end,
}
