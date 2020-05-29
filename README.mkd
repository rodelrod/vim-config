vim-config
==========

Vim configuration files: vimrc, plugins, syntax enhacements etc.

Installation
------------

I use [Vundle](https://github.com/VundleVim/Vundle.vim) to manage plugins. Git clone Vundle.vim into `bundle/`, then run vim and `:PluginInstall`

```bash
git clone https://github.com/VundleVim/Vundle.vim.git bundle/Vundle.vim
```

Usage
-----

For Syntastic to do its job, install `flake8` in the virtualenv, the start
active mode with <F9>.

```bash
pip install flake8
```

Alternatively you can also you pylint (heavier and more verbose).

Plugins
-------

To browse the filesystem:
 - NERDTree (CTRL-w CTRL-e)

To browse the tags:
 - Tagbar (CTRL-w CTRL-r)

Solid plugins I feel I'll be using for a long time:
 - Fugitive
 - Surround
 - Airline
 - Syntastic
 - Easytags
 - NERDcommenter
 - vim-python-pep8-indent (indent python like intelliJ Idea)
 - Ack
 - CtrlP
 - Emmet
 - Easytags

Stuff I might or might not use:
 - Snipmate

Stuff I ended up uninstalling because I didn't really use:
 - Rope/Ropevim

