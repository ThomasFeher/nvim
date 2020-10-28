# Install instructions

```bash
    zypper in python2-neovim python3-neovim ShellCheck
    cd ~/.config # goto config directory ($XDG_CONFIG_HOME)
    git clone https://github.com/ThomasFeher/nvim.git
    nvim --headless +PlugUpgrade +PlugInstall +qa
```
