---@module 'lazy'

---@class config.language.Langs
---@field get table<string,config.language.Lang>
---@field formatters table<string,string[]>
---@field lsp (string|table<string,table>)[]
---@field mason string[]
---@field treesitter string[]
---@field plugins LazySpec
---@field append fun(langs: config.language.Langs, name:string, config: config.language.Config)
---@field config fun()
---@field config_lsp fun()
---@field config_mason fun()
---@field config_treesitter fun()
---@field config_formatter fun()
---@field solve fun(langs: config.language.Langs, config:config.language.Config)

---@class config.language.Lang
---@field lsp string|table<string|string,table>?
---@field name string?
---@field treesitter? string[]
---@field formatter? string[]
---@field plugins? LazySpec
---@field pkgs? string[]
---@field get_lspnames fun(self: config.language.Lang):string

---@class config.language.Opts
---@field afterall? fun(langs: config.language.Langs)
---@field rtp? string
---@field mod? string

---@class config.language.Config
---@field [integer] string|config.language.Config
---@field lsp? string|table<string|string,table>
---@field treesitter? string|string[]|boolean
---@field formatter? string|string[]
---@field plugins? LazySpec
---@field pkgs? string[]
---@field enabled? boolean
