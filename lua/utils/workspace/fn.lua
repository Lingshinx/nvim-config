return {
  ---@param dir string
  ---@param file string
  ---@return boolean
  is_file_in = function(dir, file) return file:find(dir, 1, true) == 1 end,
}
