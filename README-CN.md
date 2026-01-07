# Neovim Configuration

<img width="2516" height="1348" alt="图片" src="https://github.com/user-attachments/assets/a92379ab-223b-4a2e-9cec-d4ece66af217" />

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

## Requirements

- 尽可能新的 Neovim，顺便一提我用 Arch
- [ripgrep](https://github.com/BurntSushi/ripgrep) 用来查找内容，for [snacks](https://github.com/folke/snacks.nvim) and [grug-far](https://github.com/MagicDuck/grug-far.nvim)
- [fd](https://github.com/sharkdp/fd) 用来搜索文件，for [snacks](https://github.com/folke/snacks.nvim)
- 随便一款 [Nerd Fonts](https://www.nerdfonts.com/font-downloads)
- [github-cli](https://cli.github.com/)，用来在 dashboard 上查看 github 通知
- [lazygit](https://github.com/jesseduffield/lazygit)，好用
- C 编译器，比如说 [gcc](https://www.gnu.org/software/gcc/) 或者 [clang](https://clang.llvm.org/)，给 [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter/tree/main?tab=readme-ov-file#requirements) 用

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

### Nix

#### Flake

```nix
inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvim = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:lingshinx/nvim-config/unstable";
    };
}
```

#### Module

```nix
{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.nvim-config.homeModules.default];
  programs.neovim = {
    enable = true;
    lingshin-config = {
      enable = true;
      # Enable Language Configurations In Directory `Langs`
      languages = ["nix" "fish" "lua"];
      # Extra Language Configuration Files
      extraLanguages = [];
      dashboardCommand = "echo hello world"; 
    };

    extraPackages = with pkgs; [
      stylua
      luajitPackages.lua-lsp

      fish-lsp

      alejandra
      nixd
    ];
  };
}
```

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
| **options** | `table<string,any>` | 语言特定的选项 |
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

#### 用 **tabline** 而不是 **bufferline**

让 buffer 堆满你的 tabline 然后用 <kbd>H</kbd> / <kbd>L</kbd> 没头没脑地找吗? Vim 高尔夫大师是不会这样做的

可以在 Oil, Grapple, Overseer 上用 <kbd>Tab</kbd> 打开一个新的 Tab
也可以在 Snacks Picker 里用 <kbd>Ctrl-Enter</kbd>  
[fatten.nvim](https://github.com/willothy/flatten.nvim) 也会用 Tab 打开在内置终端中打开的文件

顺便一提，Vim 用 <kbd>\<Ctrl-w\>T</kbd> 将当前窗口移动到新的 Tab

> [!NOTE]
> 状态栏和标签栏我都是用 [heirline](https://github.com/rebelot/heirline.nvim) 写的噢

##### 参考

[为什么 Vim 专家更喜欢使用缓冲区而不是制表符？ - Stack Overflow](https://stackoverflow.com/questions/26708822/why-do-vim-experts-prefer-buffers-over-tabs/26710166#26710166)

#### 不要依赖文件树来跳转文件，你应该用 File Picker 和 Harpoon

不过虽然这么说，我还是在用 [snacks.explorer](https://github.com/folke/snacks.nvim/blob/main/docs/explorer.md)

用 File Tree 来总览一下项目结构还是蛮不错的

#### [**Oil.nvim**](https://github.com/stevearc/oil.nvim) 真的很好用，而且很有 Vim 的风格，我很推荐你去试一试

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

### Workspace Config

你可以在 `./.nvim` 放一些文件，进行项目级别的配置
参见 [Workspace](./Workspace.md)

### Overseer

> Vim has a special mode to speedup the **edit-compile-edit** cycle.
> Vim 有一个特殊的模式来加速 **编辑-编译-编辑** 的循环

我用 `:make` 命令来编译运行
但它是同步运行的，所以它在编译时我就只能回消息水群 <del>然后忘记自己干什么</del>

[Overseer](https://github.com/stevearc/overseer.nvim) 是很强的一个任务管理插件

- 可以从 `Makefile`, `JustFile`, `package.json`, `tasks.json` 等文件中生成任务
- 可以很方便地重启任务
- 可以通过修改任务组件动态根据需求调整功能
- 任务结束或者失败之后会发送通知（*当然是可选的*）
- 当检测到文件变化时自动重启任务（*同上*）
- 可以和 `vim.quickfix` 与 `vim.diagnostic` 互操作

#### Usage

用 `:Make` 命令来运行程序，该程序由 `vim.o.makeprg` 决定
并由 `vim.o.errorformat` 解析错误信息，并展示在 [trouble.nvim](https://github.com/folke/trouble.nvim) 中

`:Grep` 可以交互式搜索关键字
你不用担心性能问题
因为我的 `vim.o.grepprg` 是 [ripgrep](https://github.com/BurntSushi/ripgrep)

`<leader>oo` 重启最近使用的命令 [^1]

`<leader>os` 运行一个 shell 命令

[^1]: 如果没有最近一次命令，从生成的任务中选择一个执行

https://github.com/user-attachments/assets/9325d15e-a4e9-4292-9022-b570e625042e

### LaTeX Suite

https://github.com/user-attachments/assets/d117ab08-c766-45c9-a294-b65614349734

用 [LuaSnip](https://github.com/L3MON4D3/LuaSnip) 整了个类似 [Obsidian](https://github.com/artisticat1/obsidian-latex-suite) 的 LaTex Suite

> [!NOTE]
> 仅在 Markdown 的公式块里面可用，因为我不用破 LaTeX  
> 用 <kbd>\<leader\>ut</kbd> 来切换启用 **Auto Snippets Trigger**

### Dashboard Header

我徒手用 Unicode 搓了一些 [Logo](./Friends-Logo.txt) 给自己和一些朋友

<img width="935" height="1080" alt="图片" src="https://github.com/user-attachments/assets/548d24cb-bbde-41fd-9d82-36060d5f62ac" />

你也可以和我交朋友呀 (∠・ω< )⌒★

给我提个 issue 或是发个 discussion 什么的，有空的话我就给你画一份

> 不过要是人太多了的话，就忙不过来了呢
>
> 我的配置被一群人围观么？我怎么会做这样的梦？
