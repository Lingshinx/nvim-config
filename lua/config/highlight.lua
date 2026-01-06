local set = require("utils.highlight.fn").setter
local link = require("utils.highlight.fn").link

require("utils.highlight").set_highlight {
  lingshin = {
    PickerFtFormatter = link "@constant",
    PickerFtLsp = link "Special",
  },
  override = {
    DiagnosticUnnecessary = set.Comment { italic = false },
  },
}
