local function is_mathblock() return require("nvim-treesitter.ts_utils").get_node_at_cursor():type() == "latex_block" end
local function auto_trig(trig)
  return { trig = trig, snippetType = "autosnippet", wordTrig = false, hidden = true, condition = is_mathblock }
end

local function auto_pattern(trig)
  return {
    trig = trig,
    snippetType = "autosnippet",
    regTrig = true,
    wordTrig = false,
    hidden = true,
    condition = is_mathblock,
  }
end

local function vim_pattern(trig)
  return {
    trig = trig,
    snippetType = "autosnippet",
    trigEngine = "vim",
    wordTrig = false,
    hidden = true,
    condition = is_mathblock,
  }
end

local function capture(n)
  return f(function(_, snip) return snip.captures[n] end)
end

local function latex_(trig, node) return s(auto_trig(trig), node) end
local function latext(trig, ...) return s(auto_trig(trig), t(...)) end
local function latexp(pattern, node) return s(auto_pattern(pattern), node) end

local function latexc(pattern, replace, ...)
  return latexp(pattern, fmta(replace, vim.tbl_map(function(index) return capture(index) end, { ... })))
end
local function latexi(trig, replace, ...)
  return latex_(
    trig,
    fmta(
      replace,
      vim.tbl_map(function(index) return type(index) == "number" and i(index) or i(unpack(index)) end, { ... })
    )
  )
end

local function latexr(trig) return s(vim_pattern([[\v\\@<!]] .. trig), t("\\" .. trig)) end

local function latexb(trig, replace)
  return latexi(
    trig,
    ([[
\begin{%s}
<>
\end{%s}
]]):format(trig, replace or trig),
    1
  )
end

---@param lr string
local function latexl(lr)
  local l = lr:sub(1, 1)
  local r = lr:sub(2, 2)
  return latexi("lr" .. l, ("\\left%s <> \\right%s"):format(l, r), 1)
end

return {
  s({ trig = "mk", desc = "Inline Math Block" }, { t "$ ", i(1), t " $" }),
  s(
    { trig = "dm", desc = "Math Block" },
    fmta(
      [[
      $$
      <>
      $$
    ]],
      { i(1) }
    )
  ),

  latext("  ", "\\;"),

  -- Greek letters
  latext("@a", "\\alpha"),
  latext("@b", "\\beta"),
  latext("@g", "\\gamma"),
  latext("@G", "\\Gamma"),
  latext("@d", "\\delta"),
  latext("@D", "\\Delta"),
  latext("@e", "\\epsilon"),
  latext(":e", "\\varepsilon"),
  latext("@z", "\\zeta"),
  latext("@t", "\\theta"),
  latext("@T", "\\Theta"),
  latext(":t", "\\vartheta"),
  latext("@i", "\\iota"),
  latext("@k", "\\kappa"),
  latext("@l", "\\lambda"),
  latext("@L", "\\Lambda"),
  latext("@s", "\\sigma"),
  latext("@S", "\\Sigma"),
  latext("@u", "\\upsilon"),
  latext("@U", "\\Upsilon"),
  latext("@o", "\\omega"),
  latext("@O", "\\Omega"),

  latext("ome", "\\omega"),
  latext("Ome", "\\Omega"),

  latexi('"', [[\text{<>}]], { 1, "hello world" }),

  -- Basic operations
  latext("sr", "^{2}"),
  latext("cb", "^{3}"),
  latexi("rd", "^{<>}", { 1, "4" }),
  latexi("_", "_{<>}", { 1, "1" }),
  latexi("sq", "\\sqrt{ <> }", { 1, "x" }),
  latexi("//", "\\frac{ <> }{ <> }", { 1, "x" }, { 2, "y" }),
  latexi("ee", "e^{ <> }", { 1, "x" }),
  latext("invs", "^{-1}"),
  latexc("(%a)(%d)", "<>_{<>}", 1, 2),
  latext("conj", "^{*}"),
  latext("Re", "\\mathrm{Re}"),
  latext("Im", "\\mathrm{Im}"),
  latext("Tr", "\\mathrm{Tr}"),
  latext("rmd", "\\mathrm{d}"),
  latexi("bf", "\\mathbf{<>}", 1),

  -- Linear algebra
  latexr "det",

  latexc("(%a)hat", "\\hat{<>}", 1),
  latexc("(%a)bar", "\\bar{<>}", 1),
  latexc("(%a)dot", "\\dot{<>}", 1),
  latexc("(%a)ddot", "\\ddot{<>}", 1),
  latexc("(%a)tilde", "\\tilde{<>}", 1),
  latexc("(%a)und", "\\underline{<>}", 1),
  latexc("(%a)vec", "\\vec{<>}", 1),

  latexi("hat", "\\hat{<>}", 1),
  latexi("bar", "\\bar{<>}", 1),
  latexi("dot", "\\dot{<>}", 1),
  latexi("ddot", "\\ddot{<>}", 1),
  latext("cdot", "\\cdot"),
  latexi("tilde", "\\tilde{<>}", 1),
  latexi("und", "\\underline{<>}", 1),
  latexi("vec", "\\vec{<>}", 1),
  latexc("(\\hat{%a})(%d)", "<>_{<>}", 1, 2),
  latexc("(\\vec{%a})(%d)", "<>_{<>}", 1, 2),
  latexc("(\\mathbf{%a})(%d)", "<>_{<>}", 1, 2),

  latext("xnn", "x_{n}"),
  latext("xii", "x_{i}"),
  latext("xjj", "x_{j}"),
  latext("xp1", "x_{n+1}"),
  latext("ynn", "y_{n}"),
  latext("yii", "y_{i}"),
  latext("yjj", "y_{j}"),

  -- Symbols
  latext("ooo", "\\infty"),
  latexr "sum",
  latexr "prod",
  latexi("\\sum", "\\sum_{<>=<>}^{<>}", 1, 2, 3),
  latexi("\\prod", "\\prod{<>=<>}^{<>}", 1, 2, 3),
  latexi("lim", "\\lim_{<> \\to <>}", 1, 2),
  latext("+-", "\\pm"),
  latext("-+", "\\mp"),
  latext("...", "\\dots"),
  latext("nabl", "\\nabla"),
  latext("xx", "\\times"),
  latext("**", "\\cdot"),
  latext("===", "\\equive"),
  latext("!=", "\\neq"),
  latext(">=", "\\geq"),
  latext("<=", "\\leq"),
  latext(">>", "\\gg"),
  latext("<<", "\\ll"),
  latext("~=", "\\approx"),
  latext("ssim", "\\sim"),
  latext("sim=", "\\simeq"),
  latext("prop", "\\propto"),

  latext("<->", "\\leftrightarrow"),
  latext("->", "\\to"),
  latext("!>", "\\mapsto"),
  latext("=>", "\\implies"),
  latext("=<", "\\impliedby"),
  latext("and", "\\cap"),
  latext("orr", "\\cup"),
  latext("inn", "\\in"),
  latext("notin", "\\not\\in"),
  latext("\\\\\\", "\\setminus"),
  latext("sub=", "\\subseteq"),
  latext("sup=", "\\supseteq"),
  latext("eset", "\\emptyset"),
  latexi("set", "\\{ <> \\}", 1),
  latext("exis", "\\exists"),

  latext("LL", "\\mathcal{L}"),
  latext("HH", "\\mathcal{H}"),
  latext("CC", "\\mathcal{C}"),
  latext("RR", "\\mathcal{R}"),
  latext("ZZ", "\\mathcal{Z}"),
  latext("NN", "\\mathcal{N}"),

  latexi("prt", "\\frac{\\partial <>}{\\partial <>}", { 1, "x" }, { 2, "y" }),
  latexc("pr(%a)(%a)", "\\frac{\\partial <>}{\\partial <>}", 1, 2),
  latexi("ddx", "\\frac{\\mathrm d<>}{\\mathrm dx}", 1),
  latexi("ddy", "\\frac{\\mathrm d<>}{\\mathrm dy}", 1),
  latexi("ddz", "\\frac{\\mathrm d<>}{\\mathrm dz}", 1),
  latexc("md(%a)", "\\mathrm d<>", 1),
  latexr "int",
  latexi("\\int", "\\int <> \\, \\mathrm d<>", 1, { 2, "x" }),
  latexi("dint", "\\int^{<>}_{<>} <> \\, \\mathrm d<>", { 1, "1" }, { 2, "0" }, 3, { 4, "x" }),
  latexr "oint",
  latexi("iint", "\\iint\\limits_{<>}", { 1, "D" }),
  latexi("iiint", "\\iiint\\limits_{<>}", { 1, "D" }),
  latext("oinf", "\\int_{0}^{\\infty}"),
  latexi("iinf", "\\int_{0}^{\\infty} <> \\, \\mathrm d<>", 1, { 2, "x" }),

  latexr "sinh",
  latexr "cosh",
  latexr "tanh",
  latexr "coth",

  latexr "arcsin",
  latexr "sin",
  latexr "arccos",
  latexr "cos",
  latexr "arctan",
  latexr "tan",
  latexr "csc",
  latexr "sec",
  latexr "cot",

  latexc("\\arcsin([A-Za-gi-z])", "\\arcsin <>", 1),
  latexc("\\sin([A-Za-gi-z])", "\\sin <>", 1),
  latexc("\\arccos([A-Za-gi-z])", "\\arccos <>", 1),
  latexc("\\cos([A-Za-gi-z])", "\\cos <>", 1),
  latexc("\\arctan([A-Za-gi-z])", "\\arctan <>", 1),
  latexc("\\tan([A-Za-gi-z])", "\\tan <>", 1),
  latexc("\\csc([A-Za-gi-z])", "\\csc <>", 1),
  latexc("\\sec([A-Za-gi-z])", "\\sec <>", 1),
  latexc("\\cot([A-Za-gi-z])", "\\cot <>", 1),

  latexb("pmat", "pmatrix"),
  latexb("bmat", "bmatrix"),
  latexb("Bmat", "Bmatrix"),
  latexb("vmat", "vmatrix"),
  latexb("Vmat", "Vmatrix"),
  latexb "matrix",
  latexb "cases",
  latexb("dcases", "dcases"),
  latexb "align",
  latexb "array",

  latexi("avg", "\\langle <> \\rangle", 1),
  latexi("norm", "\\lvert <> \\rvert", 1),
  latexi("Norm", "\\lVert <> \\rVert", 1),
  latexi("ceil", "\\lceil <> \\rceil", 1),
  latexi("floor", "\\lfloor <> \\rfloor", 1),
  latexi("mod", "|<>|", 1),

  latexl "()",
  latexl "{}",
  latexl "[]",
  latexl "||",
  latex_("lra", fmt("\\left< {} \\right>", { i(1) })),
}
