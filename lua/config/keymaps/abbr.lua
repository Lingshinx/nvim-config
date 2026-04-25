local function iabbr(l, r) return { l, r, mode = "ia" } end

return {
  iabbr("cosnt", "const"),
  iabbr("mian", "main"),
}
