# Neovim Configuration

<img width="2516" height="1348" alt="Image" src="https://github.com/user-attachments/assets/9849a4e0-aa54-4dae-81d2-5d6e97787d73" />

## Introduction [zh_CN](./README-CN.md)

I used to use [LazyVim](https://www.lazyvim.org/). It's awesome.
But I found it kind of hard to keep tweaking Neovim on top of LazyVim.
It's more convenient to manage if I have a LazyVim in `stdpath('config')` instead of `stdpath('data')`.
And most importantly — It's really cool to have my own Neovim configuration, isn't it?

## Installation

Honestly, I wouldn't recommend using my configuration directly.
It's quite personal. Some CLI tools integrated might be useless to you.
Also, I'm not using DAP or NeoTest currently.

Still, I think it will serve as a good reference or starting point for you to build your own configuration alongside LazyVim (which is also my reference).
I'll even brag a bit that I have injected some **ingenuity** inside my configuration — Let me show you below:

> [!TIP]
> If you already have a Neovim setup in your environment, You don't need to move the current one away as a backup.
> You can clone this repo to `$XDG_CONFIG_COME/{NVIM_APPNAME}`.
> Any appname as `NVIM_APPNAME` is okay as long as it won't conflict with your existing directories.
> For example, you can choose *nvim_lingshin* as NVIM_APPNAME for my configuration.
>
> ```bash
> git clone https://github.com/Lingshinx/nvim-config.git ~/.config/nvim_lingshin
> ```
>
> then, try mine by running:
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

### Plugins manager

You have to install [`lazy.nvim`](https://lazy.folke.io) manually because I didn't include the process to install.

```bash
git clone --filter=blob:none --branch=stable https://github.com/folke/lazy.nvim.git ~/.local/share/nvim/lazy/lazy.nvim
```

I know it'd be more convenient if this command ran automatically when lazy.nvim is not installed,
but I just feel a little bit uncomfortable checking a condition every time for a task only executed for once,
although I know it won't take any noticeable time

## Features

### Language

It's convenient to treat Language configurations as packages and manage them together instead of scattering them around.

You can put language configurations at `stdpath('config')/lua/langs` or just `~/.config/nvim/lua/langs`.

Each file should returns a table of type `Config.LangConfig`.

| Property | Type  |Description |
| --- | --- | -----|
| `[integer]` | `string` or `Config.LangConfig` | you can nest multiple languages inside a language. Parent configurations are inherited, I will show you the usage below |
| **treesitter** | `string[]` or `boolean` | default to true, treesitter-{language name} will be installed |
| **lsp** | `string`, `string[]` or `table<string,lspconfig>` | name of **Language Server Protocol**, when `table`, `vim.lsp.config(key, value)` will be called |
| **formatter** | `string` or `string[]`  | name of formatters |
| **pkgs** | `string[]` | if the package name in [mason](https://github.com/mason-org/mason.nvim) is different with name of LSP and formatter, you can set `pkgs` to tell to mason to install it |
| **plugins** | `LazySpec` | plugin configurations related to this language |
| **options** | `table<string,any>` | language-specific options |
| **enabled** | `boolean` | no need to explain | 


[Example](./Language.md) about how to configure languages.

Also, my own language configurations are placed in `stdpath('config')/languages`, You can copy some of them to `stdpath('config')/lua/langs` to enable.

Feel free to PR your own language configuration to me if you like this functionality.
Since those configuration aren't applied automatically, so I'd really appreciate your contribution whatever the language is.

### FileType Picker

Use <kbd>\<leader\>sf</kbd> to *search filetypes*.

https://github.com/user-attachments/assets/bbcee4b8-3e6b-42e8-ae0a-dbfd991ac677

Thanks to the [feature](#language) above that I can display informations of formatter, Tree-sitter, and LSP for each language.

Use <kbd><Shift-Enter\></kbd> to edit language configuration.

### Root and Cwd

I prefer not to make difference between `cwd` and `root`.
When you enter to a buffer attached to a file, My Neovim will change current directory to the root of that file.
When root directory cannot be detected, default to parent directory.

### Oil, Tabline and Harpoon

<img width="1396" height="919" alt="图片" src="https://github.com/user-attachments/assets/55bd0614-69d7-4a2e-9b60-95f36ed6173a" />

I agree with the opinion that *you should not turn your Neovim into a traditional IDE*.

- Use **tabline** instead of **bufferline**.

  Stack your buffers to overflowing and navigate with <kbd>H</kbd> / <kbd>L</kbd>? A true Vim ninja wouldn't do that.

- Don't rely on **File Tree Explorer**, Instead, use **File Fuzzy Picker** and **Harpoon** to jump around files.

  Actually, I still use [snacks.explorer](https://github.com/folke/snacks.nvim/blob/main/docs/explorer.md).
  It's not bad to have a file tree for a quick overview of the project's structure.

- [**Oil.nvim**](https://github.com/stevearc/oil.nvim) is awesome, powerful and vim-like. You should try.

  **Oil.nvim** is even more effective at filesystem editing than [yazi](https://github.com/sxyazi/yazi) in my practice.

### Kitty Scrollback

I use Neovim as [kitty](https://github.com/kovidgoyal/kitty) scrollback pager.

https://github.com/user-attachments/assets/4be81a21-441a-46ea-a361-4cfe66470cbb

Inspired by [kitty-scrollback.nvim](https://github.com/mikesmithgh/kitty-scrollback.nvim)

It just colorize the buffer and set some keymaps and options, more lightweight.

To enable, please add this options in kitty configuration.

```bash
scrollback_pager nvim -c 'set filetype=scrollback'
```

### Workspace Config

Use the `./.nvim` directory to store local configurations. Refer to [Workspace](./Workspace.md) for more details.

### Overseer

> Vim has a special mode to speedup the **edit-compile-edit** cycle.

I would like to use `:make` to compiler or run my codes.
But `:make` is synchronous.
So I do nothing but checking my phone while compiling my codes.

[Overseer](https://github.com/stevearc/overseer.nvim) is a powerful plugin to manage tasks.

- Convenient to launch a task from files like `Makefile`, `JustFile`, `package.json`, `tasks.json`, etc.
- Easy to restart a process.
- Dynamically tweak functionality by editing components.
- Notify when task finish or failed.
- Even able to watch file changes and then restart automatically.
- Interoperable with `vim.quickfix` and `vim.diagnostic`.

#### Usage

`:Make` to run programs determined by `vim.o.makeprg`.
Parse the error message with `vim.o.errorformat` and display it with [trouble.nvim](https://github.com/folke/trouble.nvim).

`:Grep` to search keyworks with quickfix interactively.
I use [ripgrep](https://github.com/BurntSushi/ripgrep) as `vim.o.grepprg`.
So no need to worry about performance.

<kbd>\<leader\>oo</kbd> to restart lastest tasks [^1].

<kbd>\<leader\>os</kbd> to run a shell command.

[^1]: Choose a task generated by task templates when no lastest available.

https://github.com/user-attachments/assets/9325d15e-a4e9-4292-9022-b570e625042e

### LaTeX Suite

https://github.com/user-attachments/assets/d117ab08-c766-45c9-a294-b65614349734

Obsidian-like LaTeX Suite powered by [LuaSnip](https://github.com/L3MON4D3/LuaSnip).

> [!NOTE]
> Only available in Markdown math blocks, since I'm not using LaTeX.  
> <kbd>\<leader\>ut</kbd> to toggle **Auto Snippets Trigger**.

### Dashboard Header

I manually painted a few [Logo](./Friends-Logo.txt) with unicode for me and friends of mine.

<img width="935" height="1080" alt="图片" src="https://github.com/user-attachments/assets/548d24cb-bbde-41fd-9d82-36060d5f62ac" />

You can also be friend of mine.
And feel free to open an issue if interested in my **nvim-config**.
I'll draw a custom Logo for you when I have time.

> I'm unable to make so many friends. So, hurry up?
>
> Okay, take it easy, I think there is no chance that I will be followed by 100+ friends.
