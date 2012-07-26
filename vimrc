" rodrigo rodrigues: definições pessoais vim


"-------------------------------------------------------
" terminal-specific settings {{{
"-------------------------------------------------------
if has('win32')
	source $vim/_vimrc
	let g:pydoc_cmd = 'python c:/Python24/Lib/pydoc.py'
else
	source $VIM/vimrc
	if !has('gui_running')
		" Use mouse to resize windows in normal/help mode but never on insert
		" mode, to preserve mouse copy-paste on the terminal
		set mouse=nh
	endif
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
	elseif $COLORTERM == "gnome-terminal"
		" 256-colors colorscheme for gnome-terminal
		" (the term string is hard-coded for this one, we can't set it)
		set t_Co=256
		colorscheme inkpot  
	endif
    let g:pydoc_cmd = "/usr/bin/pydoc" 
	" filetype plugin was disabled by default in Debian/Ubuntu
	filetype plugin on
endif
"}}}

"-------------------------------------------------------
" look & feel {{{
" ------------------------------------------------------
if has('win32')
	set guifont=Bitstream_Vera_Sans_Mono:h10:cANSI
	colors desert
endif
set tabstop=4
set shiftwidth=4
set autoindent
set fileencodings=ucs-bom,utf-8,latin1
set guioptions-=T 	"gets rid of the toolbar
set vb t_vb=		"replaces beep for flash for wrong commands
"set virtualedit=all 
set modeline
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
" acentos através do ù {{{
"-------------------------------------------------------
" acentos agudos no teclado francês
imap ùa <c-k>'a
imap ùo <c-k>'o
imap ùi <c-k>'i
imap ùe <c-k>'e
imap ùu <c-k>'u
imap ùa <c-k>'a
imap ùo <c-k>'o
imap ùi <c-k>'i
imap ùe <c-k>'e
imap ùu <c-k>'u
"}}}

"-------------------------------------------------------
" parenthesis/bracket expanding {{{1
"-------------------------------------------------------
" Adapted from http://amix.dk/
" This version's better because it uses a Python list to produce a character
" stack
py charstack = []
py import vim
vnoremap \( <esc>`>a)<esc>`<i(<esc>
vnoremap \[ <esc>`>a]<esc>`<i[<esc>
vnoremap \{ <esc>`>a}<esc>`<i{<esc>
vnoremap \" <esc>`>a"<esc>`<i"<esc>
vnoremap \' <esc>`>a'<esc>`<i'<esc>
vnoremap \{{ <esc>`>a}}<esc>`<i{{<esc>
vnoremap \` <esc>`>a`<esc>`<i`<esc>

inoremap (( ()<esc>:py charstack.append(")")<cr>i
inoremap [[ []<esc>:py charstack.append("]")<cr>i
inoremap {{ {}<esc>:py charstack.append("}")<cr>i
inoremap {{{{ {{}}<esc>:py charstack.append("}}")<cr>hi
inoremap {{%% {%%}<esc>:py charstack.append("%}")<cr>hi
inoremap "" ""<esc>:py charstack.append('"')<cr>i
inoremap '' ''<esc>:py charstack.append("'")<cr>i
inoremap `` ``<esc>:py charstack.append("`")<cr>i
inoremap << <><esc>:py charstack.append(">")<cr>i

" Protect useful sequences from the mappings defined above 
inoremap {{{ {{{
inoremap """ """
inoremap <<< <<<

function! GoOutOfBlock()
python << EOL
if len(charstack) > 0:
    print charstack
    vim.command('normal f%s<cr>' % charstack.pop())
EOL
endfunction
imap <silent> <C-L> <esc>:call GoOutOfBlock()<cr>a

"}}}1

"-------------------------------------------------------
" OTHER MAPPINGS {{{
"-------------------------------------------------------
"Map ESCAPE into something within reach
" (remap Caps-Lock to Control using AutoHotKey for maximum punch)
" Linux note: On linux, <C-Space> == <Nul>
if has('unix') && !has('gui_running')
	imap <Nul> <Esc>
	vmap <Nul> <Esc>
else
	imap <C-space> <Esc>
	vmap <C-space> <Esc>
endif

"Map copy-paste to OS clipboard using shift-ctrl-c and shift-ctrl-v
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
" RER 19/05/2004
imap <F3> <Esc>:nohls<CR>a
nmap <F3> :nohls<CR>h 

" <C-H> com uma selecção para inserir tag HREF com o URL no clipboard
" windows 
" 10/07/2012 I don't use this anymore. When it gets serious with the HTML
" coding, I should try out Sparkup/Zen Coding
"vmap <c-h> "ldi<a href="<Esc>"+pa"><Esc>"lpa</a><Esc>
"}}}

"-------------------------------------------------------
" PLUGINS {{{
"------------------------------------------

" WinManager mappings
" -------------------
""RER 02/04/2005
nnoremap <silent> <c-w><c-t> :WMToggle<cr>
nnoremap <silent> <c-w><c-f> :FirstExplorerWindow<cr>
nnoremap <silent> <c-w><c-b> :BottomExplorerWindow<cr>
"let g:persistentBehaviour=0
let g:defaultExplorer=1

" Taglist
" ----------------
if has('win32')
	let Tlist_Ctags_Cmd = 'h:/bin/ctags.exe' 
endif
let g:winManagerWindowLayout = 'FileExplorer,TagList|BufExplorer'

" NERDTree
" --------
nnoremap <silent> <c-w><c-e> :NERDTreeToggle<cr>
let NERDTreeIgnore = ['\.pyc$']
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
call pathogen#infect()

" Powerline
" --------
if has('win32')
	let g:Powerline_symbols = 'compatible' 
else
	let g:Powerline_symbols = 'fancy' 
endif
set laststatus=2

" NERDcommenter
" -------------
"  toggle comment/uncomment
map <f8> <Leader>c<space>

" Ctrlp
" -----
"  use unix find instead of vim's internal search
if has('win32')
	let g:ctrlp_user_command = 'find %s -type f'
endif

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

"}}}

" vim:fdm=marker
