" rodrigo rodrigues: definições pessoais vim


"-------------------------------------------------------
" terminal-specific settings {{{
"-------------------------------------------------------
colorscheme inkpot     " default colorscheme
source $VIM/vimrc
if $TERM == "screen"
	" Screen sends terminal codes transparently, so you need to tell
	" vim what is your base terminal (I was having a bug with S-<Fx>)
	set term=xterm
	colorscheme xterm16  " 16-colors colorsheme 
elseif $TERM == "xterm-256color" 
	" 256-colors colorscheme for putty
	" you have to (1) use putty 0.49, (2) install ncurses-term on debian, 
	" (3) send xterm-256color as term string 
	" (the term string is hard-coded for this one, we can't set it)
	colorscheme inkpot  
elseif $TERM == "screen-256color"
    " Make mouse smoother and more stable on tmux (esp. window resizing)
    set ttymouse=xterm2
elseif $COLORTERM == "gnome-terminal"
	" 256-colors colorscheme for gnome-terminal
	" (the term string is hard-coded for this one, we can't set it)
	set t_Co=256
endif

" Make sure we start in the correct directory when launching gvim from
" Nautilus 
if has("gui_running")
    cd %:h
endif
"}}}

"-------------------------------------------------------
" look & feel {{{
" ------------------------------------------------------
set tabstop=4
set shiftwidth=4
set expandtab		"the cases when I don't want this are much rarer
set autoindent
set fileencodings=ucs-bom,utf-8,latin1
set guioptions-=T 	"gets rid of the toolbar
set vb t_vb=		"replaces beep for flash for wrong commands
"set virtualedit=all 
set modeline
set number

" stuff that is commented out on Ubuntu by default
" ------------------------------------------------
set mouse=a       " better than nh for copy/paste
set showcmd
set showmatch
set ignorecase
set smartcase
set incsearch
set hidden

" more natural window splitting
set splitbelow
set splitright
"}}}

"----------------------------------------------------
" file browsing {{{
"----------------------------------------------------
" with these settings we can use find, * and tab for fuzzy-matching
set wildmenu        "I feel embarrassed how long it took me to find out about this
set wildignore+=*.pyc,*.pyo,__pycache__,*.swp,*.swo
set path+=**        "have file commands search in sub-directories too

" Have Vim jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Have Vim load indentation rules and plugins according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif
"}}}

"-------------------------------------------------------
" fold {{{
" -----------------------------------------------
:nmap <f2> za
:imap <f2> <esc>zali
:nnoremap <s-f2> zA
:inoremap <s-f2> <esc>zAli
"}}}

"-------------------------------------------------------
" parenthesis/bracket expanding {{{1
"-------------------------------------------------------
" Adapted from http://amix.dk/
" This version's better because it uses a Python list to produce a character
" stack
"
" 2018-04-15: the backslash vnoremaps are no longer necessary because I can 
"             now use the S mappings from vim-surround.
if has("python3")
  command! -nargs=1 Py py3 <args>
else
  command! -nargs=1 Py py <args>
endif
Py charstack = []
Py import vim
vnoremap \( <esc>`>a)<esc>`<i(<esc>
vnoremap \[ <esc>`>a]<esc>`<i[<esc>
vnoremap \{ <esc>`>a}<esc>`<i{<esc>
vnoremap \" <esc>`>a"<esc>`<i"<esc>
vnoremap \' <esc>`>a'<esc>`<i'<esc>
vnoremap \{{ <esc>`>a}}<esc>`<i{{<esc>
vnoremap \` <esc>`>a`<esc>`<i`<esc>

inoremap (( ()<esc>:Py charstack.append(")")<cr>i
inoremap [[ []<esc>:Py charstack.append("]")<cr>i
inoremap {{ {}<esc>:Py charstack.append("}")<cr>i
inoremap {{{{ {{}}<esc>:Py charstack.append("}}")<cr>hi
inoremap {{%% {%%}<esc>:Py charstack.append("%}")<cr>hi
inoremap "" ""<esc>:Py charstack.append('"')<cr>i
inoremap '' ''<esc>:Py charstack.append("'")<cr>i
inoremap `` ``<esc>:Py charstack.append("`")<cr>i
inoremap << <><esc>:Py charstack.append(">")<cr>i

" Protect useful sequences from the mappings defined above 
inoremap {{{ {{{
inoremap """ """
inoremap <<< <<<

function! GoOutOfBlock()
Py << EOL
if len(charstack) > 0:
    vim.command('normal f%s<cr>' % charstack.pop())
EOL
endfunction
imap <silent> <C-L> <esc>:call GoOutOfBlock()<cr>a

"}}}1

"-------------------------------------------------------
" Indenting {{{
"-------------------------------------------------------
vnoremap > >gv
vnoremap < <gv

"}}}1

"-------------------------------------------------------
" OTHER MAPPINGS {{{
"-------------------------------------------------------

"Map copy-paste to OS clipboard using shift-ctrl-c and shift-ctrl-v
" (não funciona no gnome-terminal, só gvim)
vmap <S-C-C> "+y
imap <S-C-V> <Esc>"+p
vmap <S-C-V> "+p

" Insert date and time stamp 
" 28/02/2008 changed from <F11> to <S-F11> because <F11> is taken over
" by the terminal in xfce-terminal
imap <S-F11> <C-R>=strftime("%d/%m/%Y")<CR>
nmap <S-F11> i<C-R>=strftime("%d/%m/%Y")<CR><Esc> 

"  Remove search results highlighting
" 'a' and 'h' return to original cursor position
map <F3> :set hls!<CR>
imap <F3> <Esc>:set hls!<CR>a
vmap <F3> <Esc>:set hls!<CR>gv

" Quick toggle paste mode, which disables auto-indenting when pasting.
set pastetoggle=<F6>


" Shortcuts for buffer switching
" Inspired by Screen's <C-A> shortcuts.
" RER 22/10/2012
" Switch to next buffer
nnoremap <C-w><C-n> :bn<CR>
" Switch to previous buffer
nnoremap <C-w><C-p> :bp<CR>

" Add separate line when splitting tags. Example:
"
" <div>|</div>
"
"  converts to 
"
" <div>
"   |
" </div>
if has("gui_running")
    inoremap <C-Enter> <CR><Esc>O
else
    " in gnome-terminal, <C-Enter> is interpreted as NL, same as <C-J>
    inoremap <C-J> <CR><Esc>O
endif

"}}}

"-------------------------------------------------------
" PLUGINS {{{
"------------------------------------------

" NERDTree
" --------
nnoremap <silent> <c-w><c-e> :NERDTreeToggle<cr>
let NERDTreeRespectWildIgnore=1
let NERDTreeWinSize = 30

" Tagbar
" ------
nnoremap <silent> <c-w><c-r> :TagbarToggle<CR>
let g:tagbar_width = 30
let g:tagbar_autofocus = 1
" Sort according to order in file instead of name.
let g:tagbar_sort = 0
" Compact version
"let g:tagbar_compact = 1

" Pathogen
" --------
execute pathogen#infect()

" vim-airline
" --------
if has('win32')
	let g:airline_powerline_fonts = 0
else
	let g:airline_powerline_fonts = 1
endif
" turn off warnings for trailing whitespace ('trailing')
let g:airline#extensions#whitespace#checks = [ 'indent', 'long' ]
set laststatus=2

" NERDcommenter
" -------------
"  toggle comment/uncomment
map <f8> <Leader>c<space>

" Syntastic
" ---------
nnoremap <silent> <f9> :SyntasticToggleMode<cr>
"When set to 1 the error window will be automatically opened when errors are
"detected, and closed when none are detected.
let g:syntastic_auto_loc_list=1
let g:syntastic_mode_map = { 'mode': 'passive',
						   \ 'active_filetypes': [],
						   \ 'passive_filetypes': [] }

" Easytags
" --------
" Dynamic highlighting seems worthless to me
let g:easytags_auto_highlight = 0

" Jedi
" ----
" Let's only complete when I ask him to
let g:jedi#popup_on_dot = 0
" Show call signatures on the command line ("2") instead of the popup, 
" which tends to get stuck. We need to also set noshowmode so that the mode
" doesn't cobble over the signatures.
let g:jedi#show_call_signatures = "2"
set noshowmode
" Prevent the documentation window from automatically opening. It makes the
" text go up and down all the time. I can open it explicitely with K.
autocmd FileType python setlocal completeopt-=preview


" Vim-Pyenv
" ---------
" Allows Jedi to work with the correct Python version under pyenv and virtualenv
if jedi#init_python()
  function! s:jedi_auto_force_py_version() abort
    let major_version = pyenv#python#get_internal_major_version()
    call jedi#force_py_version(major_version)
  endfunction
  augroup vim-pyenv-custom-augroup
    autocmd! *
    autocmd User vim-pyenv-activate-post   call s:jedi_auto_force_py_version()
    autocmd User vim-pyenv-deactivate-post call s:jedi_auto_force_py_version()
  augroup END
endif


" Ctrlp
" -----
" Skip big directories full of junk that I never want to edit
let g:ctrlp_custom_ignore = 'node_modules\|git'


" Vim-Ansible-YAML
" ----------------
" Use Ansible YAML plugin for normal YAML files (default indent is total crap)
autocmd BufNewFile,BufRead *.yml,*.yaml set filetype=ansible


" Vim-Flow
" --------
" If this is set to 1, the quickfix window will not be opened when there are
" no errors, and will be automatically closed when previous errors are
" cleared. 
let g:flow#autoclose = 1


" vim:fdm=marker
