return {
  append = function(acc, cur)
    acc[#acc + 1] = cur
    return acc
  end,
}
