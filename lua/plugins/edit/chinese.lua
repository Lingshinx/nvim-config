local file_types = { "text", "plaintex", "typst", "gitcommit", "markdown" }

return {
  {
    "noearc/jieba.nvim",
    dependencies = { "noearc/jieba-lua" },
    ft = file_types,
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = file_types,
        callback = function()
          local jieba = require("jieba_nvim")
          for lhs, rhs in pairs({
            w = jieba.wordmotion_w,
            W = jieba.wordmotion_W,
            b = jieba.wordmotion_b,
            B = jieba.wordmotion_B,
            e = jieba.wordmotion_e,
            E = jieba.wordmotion_E,
            ge = jieba.wordmotion_ge,
            gE = jieba.wordmotion_gE,
          }) do
            vim.keymap.set({ "o", "x", "n" }, lhs, rhs, { buffer = true, noremap = false, silent = true })
          end
        end,
      })
    end,
  },

  {
    "liubianshi/cmp-lsp-rimels",
    keys = { { "\\\\", mode = "i" } },
    config = function()
      vim.system({ "rime_ls", "--listen", "127.0.0.1:9257" }, { detach = true })
      require("rimels").setup({
        cmd = vim.lsp.rpc.connect("127.0.0.1", 9257),
        keys = { start = "\\\\", stop = "\\s", esc = "\\e", undo = "\\u" },
      })
    end,
  },
}
