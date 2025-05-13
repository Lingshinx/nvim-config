return {
  "echasnovski/mini.operators",
  version = "*",
  opts = {
    -- No need to copy this inside `setup()`. Will be used automatically.
    -- Each entry configures one operator.
    -- `prefix` defines keys mapped during `setup()`: in Normal mode
    -- to operate on textobject and line, in Visual - on selection.

    -- Evaluate text and replace with output
    evaluate = {
      prefix = "g=",

      -- Function which does the evaluation
      func = nil,
    },

    -- Exchange text regions
    exchange = {
      prefix = "gx",

      -- Whether to reindent new text to match previous indent
      reindent_linewise = true,
    },

    -- Multiply (duplicate) text
    multiply = {
      prefix = "yx",

      -- Function which can modify text before multiplying
      func = nil,
    },

    -- Replace text with register
    replace = {
      prefix = "dx",

      -- Whether to reindent new text to match previous indent
      reindent_linewise = true,
    },

    -- Sort text
    sort = {
      prefix = "gst",

      -- Function which does the sort
      func = nil,
    },
  },
}
