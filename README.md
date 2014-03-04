vim-config
==========

Vim configuration files: vimrc, plugins, syntax enhacements etc.

For now I have several alternatives to browse files. I'll probably stick with
one of them when the new usage patterns settle in. 

To browse the filesystem:
 - Winmanager + FileExplorer (CTRL-w CTRL-t)
 - NERDTree (CTRL-w CTRL-e)

To browse the open buffers:
 - Winmanager + BufExplorer (CTRL-w CTRL-b once WM is open)
 - :bn, :b1, \bs and \be

To browse the tags:
 - Winmanager + Taglist (CTRL-n on the main WM window once WM is open)
 - Tagbar

Solid plugins I feel I'll be using for a long time:
 - Fugitive
 - Powerline
 - Syntastic
 - Easytags
 - NERDcommenter
 - vim-python-pep8-indent (indent python like intelliJ Idea)

Stuff I might or might not use:
 - Ack
 - pydoc
 - Snipmate
 - Rope/Ropevim

For Ropevim, I needed to pip install rope and ropemode. After that I cloned
https://bitbucket.org/agr/ropevim into ~/dev/vendors and copied over the
ropevim.vim file to .vim/plugin. I got the documentation from another
distribution of ropevim: https://github.com/klen/rope-vim/blob/master/doc/ropevim.txt.
Klen's distribution is supposed to be a one-stop install, rope and ropemode
included, and compatible with pathogen to boot. Unfortunately it proved to be
buggy.
