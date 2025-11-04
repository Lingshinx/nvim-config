return {
  "zk-org/zk-nvim",
  lazy = false,
  cmd = {
    "ZkBacklinks",
    "ZkBuffers",
    "ZkCd",
    "ZkIndex",
    "ZkInsertLink",
    "ZkInsertLinkAtSelection",
    "ZkLinks",
    "ZkMatch",
    "ZkNew",
    "ZkNewFromContentSelection",
    "ZkNewFromTitleSelection",
    "ZkNotes",
    "ZkTags",
    "ZkAdd",
  },
  config = function()
    require("zk").setup {
      picker = "snacks_picker",
    }
    require "utils.plugin.zk"
  end,
}
