---@module 'lazy'

---@class Config.Langs
---@field get table<string,Config.Lang>
---@field formatters table<string,string[]>
---@field lsp (string|table<string,table>)[]
---@field mason string[]
---@field treesitter string[]
---@field plugins LazySpec
---@field append fun(langs: Config.Langs, name:string, config: Config.LangConfig)
---@field config fun()
---@field solve fun(langs: Config.Langs, config:Config.LangConfig)

---@class Config.Lang
---@field lsp string|table<string|string,table>?
---@field name string?
---@field treesitter? string[]
---@field formatter? string[]
---@field plugins? LazySpec
---@field pkgs? string[]
---@field get_lspnames fun(self: Config.Lang):string

---@class Config.LangConfig
---@field [integer] string|Config.LangConfig
---@field lsp? string|table<string|string,table>
---@field treesitter? string[]|boolean
---@field formatter? string[]|string
---@field plugins? LazySpec
---@field pkgs? string[]
---@field enabled? boolean
