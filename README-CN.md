# Neovim Configuration

<img width="2516" height="1348" alt="Image" src="https://github.com/user-attachments/assets/9849a4e0-aa54-4dae-81d2-5d6e97787d73" />

## 介绍

之前一直在用 LazyVim, 挺好用的

不过在 LazyVim 的基础上改配置不是很方便，
而且总觉得产生了些许额外的性能负担，不够干净

何况已经加了许多配置了，索性从头开始。
一方面深入了解 nvim 的配置，另一方面也方便将来拓展

更主要的是，看着朋友们自己配的 nvim，用着 LazyVim 的自己总觉得**自卑**（）

现在就可以很开心地和朋友们分享自己的配置啦，
也有一两个朋友会来这里提建议和讨论呢。
当然也欢迎你随时来**参考，讨论，建议**！

## 安装

这个配置相当个性，可以会依赖一些你用不上的工具，并且也不打算讨好他人。
因此并不是很推荐你直接安装我的配置噢

不过，拿来试试 Neovim，从此基础上修改，或是在我的配置中寻求一些灵感什么的，
相信我的配置还是足以胜任的

> [!TIP]
> 如果你已经有一个 Neovim 配置的话，可以不用备份原来的配置，而是将我的配置下载到 `$XDG_CONFIG_COME/{NVIM_APPNAME}`
> NVIM_APPNAME 随便起什么都行啦，只要不和你原来的目录起冲突。比如说，你可以用 `nvim_lingshin` 来当这份配置的 APPNAME
>
> ```bash
> git clone https://github.com/Lingshinx/nvim-config.git ~/.config/nvim_lingshin
> ```
>
> 然后运行下面的命令就可以体验我的配置了
>
> ```bash
> NVIM_APPNAME=nvim_lingshin nvim
> ```

### 插件管理器（Plugins manager）

我的配置不会自动安装 [`lazy.nvim`](https://lazy.folke.io), 所以需要你手动安装一下来着

```bash
git clone --filter=blob:none --branch=stable https://github.com/folke/lazy.nvim.git ~/.local/share/nvim/lazy/lazy.nvim
```

自动安装插件管理器的确会方便一些，
但我就是不喜欢每次启动都要检查一下有没有安装 lazy.nvim。
况且手动安装更加方便排查一些网络问题呢

## Features

### Language

我把语言相关的配置都放在了一块，
这比分别在 [conform.nvim](https://github.com/stevearc/conform.nvim), [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) 和 `vim.lsp.config` 里面配置要更加方便管理一些

你可以把语言配置放在 `stdpath('config')/lua/langs`，
或者简单来说就是 `~/.config/nvim/lua/langs`

每个文件返回一张具有如下类型 `Config.LangConfig` 的表

| 值 | 类型  |描述  |
| --- | --- | -----|
| `[integer]` | `string` or `Config.LangConfig` | 你可以在语言配置里面嵌套多个语言的配置，下面会告诉你有什么用 |
| **treesitter** | `string[]` or `boolean` | 默认是 `true`，会自动安装 `treesitter-{language name}` |
| **lsp** | `string`, `string[]` or `table<string,lspconfig>` | 语言服务器的名字, 如果类型是 `table`, 就会执行 `vim.lsp.config(key, value)`  |
| **formatter** | `string` or `string[]`  | formmatter 的名字 |
| **pkgs** | `string[]` | 如果 [mason](https://github.com/mason-org/mason.nvim) 包的名字和上面使用的 lsp/formmatter 的名字不一样 , 你可以用这个来指定要安装的包 |
| **plugins** | `LazySpec` |和这个语言相关的 nvim 插件|
| **enabled** | `boolean` | 赋能传统语言文化配置 | 


关于配置语言的[示例](./Language.md)，我只写了英文版，开个翻译将就看呗

随便一提，我把我自己的语言配置放在了 `stdpath('config')/languages`, 你可以把他们复制到 `stdpath('config')/lua/langs` 里去

如果你喜欢这个功能，也可以提交一些你个人的语言配置到这里来。由于不会自动应用，所以无论什么语言都大欢迎！

### FileType Picker

用 <kbd>\<leader\>sf</kbd> 来 查找文件类型 *(search filetypes)*

https://github.com/user-attachments/assets/bbcee4b8-3e6b-42e8-ae0a-dbfd991ac677

通过上面的[语言配置功能](#language)，我还顺便展示了每个文件类型的配置情况

用 <kbd><Shift-Enter\></kbd> 来跳转到对应语言的配置文件

### Root and Cwd

我更倾向于直接将 Cwd 设置为项目根目录，LazyVim 每个快捷键都区分个 CWD 和 Root 让我感觉挺麻烦的

效果类似于 `'autochdir'`，每次进入新的 buffer 时将 CWD 切换到对应文件的项根目录

### Oil, Tabline and Harpoon

我挺赞同一些视频说：你不应该把 Neovim 定制成传统 IDE 那样

- 用 **tabline** 而不是 **bufferline**

  让 buffer 堆满你的 tabline 然后用 <kbd>H</kbd> / <kbd>L</kbd> 没头没脑地找吗? Vim 高尔夫大师是不会这样做的

- 不要依赖文件树来跳转文件，你应该用 File Picker 和 Harpoon

  不过虽然这么说，我还是在用 [snacks.explorer](https://github.com/folke/snacks.nvim/blob/main/docs/explorer.md)

  用 File Tree 来总览一下项目结构还是蛮不错的

- [**Oil.nvim**](https://github.com/stevearc/oil.nvim) 真的很好用，而且很有 Vim 的风格，我很推荐你去试一试

  在日常的文件操作里，我一般会去用 Oil 而不是 [yazi](https://github.com/sxyazi/yazi)，Oil 高效又直观

### Kitty Scrollback

我还把 Neovim 设成了 [kitty](https://github.com/kovidgoyal/kitty) 的 scrollback pager

https://github.com/user-attachments/assets/4be81a21-441a-46ea-a361-4cfe66470cbb

受 [kitty-scrollback.nvim](https://github.com/mikesmithgh/kitty-scrollback.nvim) 的启发

不过我这里就只是单纯给 scrollback 着个色，然后设几个 keymap 和 option 而已，相当轻量化

你可以在 kitty 的配置里面设置下面的选项来启用这个功能

```bash
scrollback_pager nvim -c 'set filetype=scrollback'
```

### Dashboard Header

我徒手用 Unicode 搓了一些 [Logo](./Friends-Logo.txt) 给自己和一些朋友

<img width="935" height="1080" alt="图片" src="https://github.com/user-attachments/assets/548d24cb-bbde-41fd-9d82-36060d5f62ac" />

你也可以和我交朋友呀 (∠・ω< )⌒★

给我提个 issue 或是发个 discussion 什么的，有空的话我就给你画一份

> 不过要是人太多了的话，就忙不过来了呢
>
> 我的配置被一群人围观么？我怎么会做这样的梦？ 

## 正在咕的计划

- [ ] 工作区配置

  受朋友 [@aurora](https://github.com/aurora0x27) 的 [nvim-config](https://github.com/aurora0x27/nvim-config) 启发

  我打算写一个功能，检测到根目录下有 `.nvim/` 时会自动应用一些配置，添加一些快捷键什么的
