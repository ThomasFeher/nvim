# Install instructions

```bash
    zypper in python2-neovim python3-neovim ShellCheck
    cd ~/.config # goto config directory ($XDG_CONFIG_HOME)
    git clone https://github.com/ThomasFeher/nvim.git
    nvim # open neovim and type:
    :PlugUpgrade # update plugin manager to latest version
    :PlugInstall # install all plugins (this can take some time)
    :qa # quit neovim (needs to restart in order to make plugins work correctly)
```
