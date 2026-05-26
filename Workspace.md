# Workspace Usage

## Basic Usage

### Trust

To protect against running untrusted code accidentally,
you need to confirm to trust the `.nvim` directory the first time it is detected.
the trusted files or directories are recorded at `~/.local/state/nvim/trust`

> [!WARNING]
> Since there's almost no chance that a normal repo contains a `.nvim` directory,
> I do not varify if the directory has been modified after being trusted.  
> Just in case that the `.nvim` is from remote, please be cautious.


### Languages

You can also put [Language](./Language.md) config files in `.nvim/langs`.

I recommend you to use this feature to set language-specific options.
[Like This](./Language.md#Kotlin)

Of course you can just use `ftplugin`
