" Source vim config (from https://neovim.io/doc/user/nvim.html#nvim-from-vim)
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" Neovim-specific settings
set inccommand=nosplit
