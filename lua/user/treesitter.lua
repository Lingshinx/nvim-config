---@type table<string, any>
local tree_sitter = require("nvim-treesitter.parsers").get_parser_configs()
tree_sitter.solyrc = {
  install_info = {
    url = "/home/lingshin/Desktop/Workspace/JavaScript/parser/tree-sitter-solyrc",
    files = { "src/parser.c" },
  },
  filetype = "solyrc",
}

tree_sitter.sognasm = {
  install_info = {
    url = "/home/lingshin/Desktop/Workspace/JavaScript/parser/tree-sitter-sognasm",
    files = { "src/parser.c" },
  },
  filetype = "sognasm",
}

tree_sitter.sognac = {
  install_info = {
    url = "/home/lingshin/Desktop/Workspace/JavaScript/parser/tree-sitter-sognac",
    files = { "src/parser.c" },
  },
  filetype = "sognac",
}
