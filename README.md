# Install instructions

```bash
    zypper in python2-neovim python3-neovim ShellCheck
    cd ~/.config # goto config directory ($XDG_CONFIG_HOME)
    git clone https://github.com/ThomasFeher/nvim.git
    nvim --headless +PlugUpgrade +PlugInstall +qa
```

For building Neovim from source do:

```bash
zypper in libtool gcc-c++ gettext-tools python38-devel
git clone https://github.com/neovim/neovim.git
cd neovim
make "CMAKE_INSTALL_PREFIX=$HOME/bin/neovim" "CMAKE_BUILD_TYPE=RelWithDebInfo"
make install
hash -r # in case the system nvim is still executed although ~/bin is placed in
        # front of /bin in $PATH
```
