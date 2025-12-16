# Workspace Usage

## Configuration

```lua
-- lua/config/workspace/init.lua
require("utils.workspace").setup {
    dir = ".nvim",
    handlers = {
        directory = {
            langs = require("utils.workspace.langs").handle_dir,
        },
        file = {
            lang = require("utils.workspace.langs").handle_file,
            options = require("utils.workspace.options").handle_file,
            debug = function(value) vim.print(value) end,
        },
    }
},
```

It's the default configuration.
You don't need to edit anything.
After all, this is a **nvim-config** repo, not a **nvim-plugin** repo.

Each handler is just a function.

## Basic Usage

### Options

Create a file `.nvim/options.lua` at the root of your project.

```lua
return {
    spell = false,
    compiler = "fish",
    errorformat = {
        "%Afish: %m",
        "%Z%f (line %l): ",
        "%f (line %l): %m",
    }
}
```

And this options will be applied to buffers attached to files in your project.
Files outside won't be affected, don't worry.

### Languages

You can also put [Language](./Language.md) config files in `.nvim/langs`.
Or `.nvim/langs.lua` simply.

I recommend you to use this feature to set language-specific options.
[Like This](./Language.md#Kotlin)

### Init

You can also use `.nvim/init.lua` to achieve some features more flexible.

> [!Info]
> `.nvim` will only be loaded once for each project.
> So you maybe should create some autocmds instead of doing something directly.

## Write Your Own Handlers

### File Handler

The file handlers are:

```kotlin
class Opts { val root: string, val dir: string, val path: string }
fun file_handlers(value: Any, opts: Opts)
```

Let's assume that the absolute path of `file.lua` is `~/Desktop/Foo/.nvim/file.lua`.


| var | val |
|-|-|
| root | `~/Desktop/Foo` |
| dir | `.nvim` |
| path | `~/Desktop/Foo/.nvim/file.lua` |


`value` is the value returned by the file.

#### File Handler Example

```lua
function(options, opts)
  if not options then return end
  local callback = function(event)
    -- maybe another good choice to get filename...
    local file = vim.api.nvim_buf_get_name(event and event.buf or 0)
    -- exit when this file is not child file of the directory where the `.nvim` is located in
    if not is_file_in(opts.root, file) then return end
    for opt, value in pairs(options or {}) do -- set local options
      vim.opt_local[opt] = value
    end
  end
  -- call it at the first time in case that file is load earlier than `.nvim`
  callback()
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
    desc = string.format("Set options in workspace %s", opts.root),
    callback = callback,
  })
end,
```

### Directory Handler

The directory handlers are:

```kotlin
fun directory_handlers(dir: string, opts: Opts)
```

### No Example

It's complex, and I consider you don't need it.


