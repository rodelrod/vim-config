" rodrigo rodrigues: definições pessoais vim




"-------------------------------------------------------
" terminal-specific settings {{{
"-------------------------------------------------------
if has('win32')
	source $vim/_vimrc
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
		colorscheme inkpot  
	endif
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
" comments {{{
" -----------------------------------------------------
" 07/05/2004 newsgroups script to comment/uncomment
" 03/03/2006 adapted to adapt to current filetype commentstring
au BufNewFile,BufRead * let b:comment_string = strpart(&l:commentstring, 0, stridx(&l:commentstring, '%s'))

map ,_comment 0i<c-r>=b:comment_string<cr><esc>
map ,_ncomment :normal ,_comment<nl>
map ,_fcomment i<c-r>=b:comment_string<cr><esc>

map ,_nfcomment :normal ,_fcomment<nl>
map ,_uncomment :let @z = @/<cr>:s/^\(\s*\)<c-r>=escape(b:comment_string, '/')<cr>/\1/e<nl>:let @/ = @z<cr>:<bs>
map ,_nuncomment :normal ,_uncomment<nl>

map <f8>  ,_ncomment
map <s-f8>  ,_nuncomment
map <m-f8>  ,_nfcomment
"}}}

"-------------------------------------------------------
" fold {{{
" -----------------------------------------------
:nmap <f2> za
:imap <f2> <esc>zali
:nmap <s-f2> zA
:imap <s-f2> <esc>zAli
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

inoremap (( ()<esc>:py charstack.append(")")<cr>i
inoremap [[ []<esc>:py charstack.append("]")<cr>i
inoremap {{ {}<esc>:py charstack.append("}")<cr>i
inoremap {{{{ {{}}<esc>:py charstack.append("}}")<cr>hi
inoremap {{%% {%%}<esc>:py charstack.append("%}")<cr>hi
inoremap "" ""<esc>:py charstack.append('"')<cr>i
inoremap '' ''<esc>:py charstack.append("'")<cr>i
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
if has('unix')
	imap <Nul> <Esc>
	vmap <Nul> <Esc>
else
	imap <C-space> <Esc>
	vmap <C-space> <Esc>
endif

" Insert date and time stamp <F2>
imap <F11> <C-R>=strftime("%d/%m/%Y")<CR>
nmap <F11> i<C-R>=strftime("%d/%m/%Y")<CR><Esc> 

"  Remove search results highlighting
" 'a' and 'h' return to original cursor position
" RER 19/05/2004
imap <F3> <Esc>:nohls<CR>a
nmap <F3> :nohls<CR>h 

" <s-tab> auto-complete
" 19/05/2004
imap <s-tab> <C-N>

" <F12> edit _vimrc
" 08/11/2006 Não preciso disto, tenho o menu Edition\Startup Settings
"nmap <F12> :sp $HOME/_vimrc<CR>
"imap <F12> <Esc>:sp $HOME/_vimrc<CR>


" <C-H> com uma selecção para inserir tag HREF com o URL no clipboard
" windows 
vmap <c-h> "ldi<a href="<Esc>"+pa"><Esc>"lpa</a><Esc>
"}}}

"-------------------------------------------------------
" PLUGINS {{{
"------------------------------------------

" WinManager mappings
" -------------------
""RER 02/04/2005
map <c-w><c-t> :WMToggle<cr>
map <c-w><c-f> :FirstExplorerWindow<cr>
map <c-w><c-b> :BottomExplorerWindow<cr>
"let g:persistentBehaviour=0
let g:defaultExplorer=1

" Taglist
" ----------------
if has('win32')
	let Tlist_Ctags_Cmd = 'h:/bin/ctags.exe' 
endif
let g:winManagerWindowLayout = 'FileExplorer,TagList|BufExplorer'
nnoremap <silent> <S-F12> :Tlist<CR>

" Project settings
" ----------------
"  g flag: map <F12> to toggle project window
"  The other flags are the default settings
let g:proj_flags ='gimst'

"}}}

" vim:fdm=marker
