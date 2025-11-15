return {
  "zk-org/zk-nvim",
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
    require("utils.plugin.zk").setup {
      picker = "snacks_picker",
    }
  end,
}
