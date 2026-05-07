local escapes = { vim.cmd.noh }

return {
  add = function(f) escapes[#escapes + 1] = f end,
  escape = function()
    for _, func in ipairs(escapes) do
      func()
    end
    return "<esc>"
  end,
}
