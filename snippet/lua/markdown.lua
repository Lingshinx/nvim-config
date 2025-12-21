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

--- just Text
local function latext(trig, ...) return s(auto_trig(trig), t(...)) end

--- Pattern
local function latexp(pattern, node) return s(auto_pattern(pattern), node) end

--- Capture
local function latexc(pattern, replace, ...)
  return latexp(pattern, fmta(replace, vim.tbl_map(function(index) return capture(index) end, { ... })))
end

--- Insert points
local function latexi(trig, replace, ...)
  return latex_(
    trig,
    fmta(
      replace,
      vim.tbl_map(function(index) return type(index) == "number" and i(index) or i(unpack(index)) end, { ... })
    )
  )
end

--- add Slash
local function latexs(trig, replace) return s(auto_trig(trig), t("\\" .. (replace or trig))) end
local function latexS(trig) return s(vim_pattern([[\v\\@<!]] .. trig), t("\\" .. trig)) end

--- Begin end
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

--- Left and right
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
  latexs("@a", "alpha"),
  latexs("@b", "beta"),
  latexs("@c", "chi"),
  latexs("@d", "delta"),
  latexs("@D", "Delta"),
  latexs("@e", "epsilon"),
  latexs(":e", "varepsilon"),
  latexs("@f", "phi"),
  latexs("@F", "Phi"),
  latexs(":f", "varphi"),
  latexs("@g", "gamma"),
  latexs("@G", "Gamma"),
  latexs("@h", "eta"),
  latexs("@i", "iota"),
  latexs("@k", "kappa"),
  latexs("@K", "Kappa"),
  latexs(":k", "varkappa"),
  latexs("@l", "lambda"),
  latexs("@L", "Lambda"),
  latexs("@m", "mu"),
  latexs("@n", "nu"),
  latexs("@o", "omega"),
  latexs("@O", "Omega"),
  latexs("@p", "pi"),
  latexs("@P", "Pi"),
  latexs("@r", "rho"),
  latexs("@R", "Rho"),
  latexs(":r", "varrho"),
  latexs("@s", "sigma"),
  latexs("@S", "Sigma"),
  latexs(":s", "varsigma"),
  latexs("@t", "theta"),
  latexs("@T", "Theta"),
  latexs(":t", "vartheta"),
  latexs("@u", "upsilon"),
  latexs("@U", "Upsilon"),
  latexs("@x", "xi"),
  latexs("@X", "Xi"),
  latexs("@y", "psi"),
  latexs("@Y", "Psi"),
  latexs("@z", "zeta"),
  latexi("@@", "\\boldsymbol{ @<> }", 1),

  latexs "tau",
  latexs "Tau",

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
  latexs("Re", "mathrm{Re}"),
  latexs("Im", "mathrm{Im}"),
  latexs("Tr", "mathrm{Tr}"),
  latexs("rmd", "mathrm{d}"),
  latexi("bf", "\\mathbf{<>}", 1),
  latexs "exp",
  latexs "log",
  latexs "ln",

  -- Linear algebra
  latexS "det",

  latexi("ddot", "\\ddot{<>}", 1),
  latexs("cdot", "cdot"),
  latexi("dot", "\\dot{<>}", 1),
  latexi("hat", "\\hat{<>}", 1),
  latexi("bar", "\\bar{<>}", 1),
  latexi("tilde", "\\tilde{<>}", 1),
  latexi("und", "\\underline{<>}", 1),
  latexi("vec", "\\vec{<>}", 1),
  latexc("(\\hat{%a})(%d)", "<>_{<>}", 1, 2),
  latexc("(\\vec{%a})(%d)", "<>_{<>}", 1, 2),
  latexc("(\\mathbf{%a})(%d)", "<>_{<>}", 1, 2),

  latexc("(%a)hat", "\\hat{<>}", 1),
  latexc("(%a)bar", "\\bar{<>}", 1),
  latexc("(%a)dot", "\\dot{<>}", 1),
  latexc("(%a)ddot", "\\ddot{<>}", 1),
  latexc("(%a)tilde", "\\tilde{<>}", 1),
  latexc("(%a)und", "\\underline{<>}", 1),
  latexc("(%a)vec", "\\vec{<>}", 1),

  latext("xnn", "x_{n}"),
  latext("xii", "x_{i}"),
  latext("xjj", "x_{j}"),
  latext("xp1", "x_{n+1}"),
  latext("ynn", "y_{n}"),
  latext("yii", "y_{i}"),
  latext("yjj", "y_{j}"),

  -- Symbols
  latexs("ooo", "infty"),
  latexS "sum",
  latexS "prod",
  latexi("\\sum", "\\sum_{<>=<>}^{<>}", 1, 2, 3),
  latexi("\\prod", "\\prod{<>=<>}^{<>}", 1, 2, 3),
  latexi("lim", "\\lim_{<> \\to <>}", 1, 2),
  latexs("+-", "pm"),
  latexs("-+", "mp"),
  latexs("...", "dots"),
  latexs("nabl", "nabla"),
  latexs("xx", "times"),
  latexs("**", "cdot"),
  latexs("===", "equive"),
  latexs("!=", "neq"),
  latexs(">=", "geq"),
  latexs("<=", "leq"),
  latexs(">>", "gg"),
  latexs("<<", "ll"),
  latexs("~=", "approx"),
  latexs("ssim", "sim"),
  latexs("sim=", "simeq"),
  latexs("prop", "propto"),

  latexs("<->", "leftrightarrow"),
  latexs("->", "to"),
  latexs("!>", "mapsto"),
  latexs("=>", "implies"),
  latexs("=<", "impliedby"),
  latexs("and", "cap"),
  latexs("orr", "cup"),
  latexs("inn", "in"),
  latext("notin", "\\not\\in"),
  latexs("\\\\\\", "setminus"),
  latexs("sub=", "subseteq"),
  latexs("sup=", "supseteq"),
  latexs("eset", "emptyset"),
  latexi("set", "\\{ <> \\}", 1),
  latexs("exis", "exists"),

  latexs("LL", "mathcal{L}"),
  latexs("HH", "mathcal{H}"),
  latexs("CC", "mathcal{C}"),
  latexs("RR", "mathcal{R}"),
  latexs("ZZ", "mathcal{Z}"),
  latexs("NN", "mathcal{N}"),

  latexi("prt", "\\frac{\\partial <>}{\\partial <>}", { 1, "x" }, { 2, "y" }),
  latexc("pr(%a)(%a)", "\\frac{\\partial <>}{\\partial <>}", 1, 2),
  latexi("ddx", "\\frac{\\mathrm d<>}{\\mathrm dx}", 1),
  latexi("ddy", "\\frac{\\mathrm d<>}{\\mathrm dy}", 1),
  latexi("ddz", "\\frac{\\mathrm d<>}{\\mathrm dz}", 1),
  latexc("md(%a)", "\\mathrm d<>", 1),
  latexi("\\int", "\\int <> \\, \\mathrm d<>", 1, { 2, "x" }),
  latexi("dint", "\\int^{<>}_{<>} <> \\, \\mathrm d<>", { 1, "1" }, { 2, "0" }, 3, { 4, "x" }),
  latexS "oint",
  latexS "int",
  latexi("iint", "\\iint\\limits_{<>}", { 1, "D" }),
  latexi("iiint", "\\iiint\\limits_{<>}", { 1, "D" }),
  latext("oinf", "\\int_{0}^{\\infty}"),
  latexi("iinf", "\\int_{0}^{\\infty} <> \\, \\mathrm d<>", 1, { 2, "x" }),

  latexS "sinh",
  latexS "cosh",
  latexS "tanh",
  latexS "coth",

  latexS "arcsin",
  latexS "sin",
  latexS "arccos",
  latexS "cos",
  latexS "arctan",
  latexS "tan",
  latexS "csc",
  latexS "sec",
  latexS "cot",

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
