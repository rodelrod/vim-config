" Vim filetype plugin file (Complementary)
" Language:	python
" Maintainer:	Rodrigo Rodrigues <rodrigo.rodrigues@networkcontacto.com>
" Last Change:	25/06/2004
"
" Note: don't forget to check python.vim file in the /after directory 
"       (Complementary 2)

" insert comment character automatically on newline
set formatoptions+=or

" Activate highlight options on the downloaded python syntax file
" 10/07/2012 Now using ubuntu's vim distribution syntax file
"let python_highlight_all = 1
"let python_highlight_string_formatting = 0
"let python_highlight_space_errors= 0

set foldmethod=indent
set expandtab

" ---------------------------------
"  Run/Debug/Profile
" ---------------------------------
python << EOF
import vim
def SetBreakpoint():
    import re
 
    nLine = int( vim.eval( 'line(".")'))
 
    strLine = vim.current.line
    strWhite = re.search( '^(\s*)', strLine).group(1)
 
    vim.current.buffer.append(
       "%(space)simport pdb; pdb.set_trace() %(mark)s Breakpoint %(mark)s" %
         {'space':strWhite, 'mark': '#' * 15}, nLine - 1)
 
 
def RemoveBreakpoints():
    import re
 
    nCurrentLine = int( vim.eval( 'line(".")'))
 
    nLines = []
    nLine = 1
    for strLine in vim.current.buffer:
        if strLine.lstrip()[:27] == 'import pdb; pdb.set_trace()':
            nLines.append( nLine)
        nLine += 1
 
    nLines.reverse()
 
    for nLine in nLines:
        vim.command( 'normal %dG' % nLine)
        vim.command( 'normal dd')
        if nLine < nCurrentLine:
            nCurrentLine -= 1
 
    vim.command( 'normal %dG' % nCurrentLine)

EOF

map <f7> :py SetBreakpoint()<cr>
map <s-f7> :py RemoveBreakpoints()<cr>

map <F4> :w<CR>:!python "%"<CR>
map <S-F4> :w<CR>:!start python "%"<CR>
map <C-F4> :w<CR>:!start python -m pdb "%"<CR>
map <M-F4> :w<CR>:!start python -m profile "%"<CR>

" 01/03/2006 The following compile settings seem quite useless, delete 
" them in the next 6 months if you indeed end up never using them
" Actually, this quickfix thing may be really useeful with unit testing
set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

" ---------------------------------
"  Text substitution
" ---------------------------------
"  10/07/2012 IMAP no longer installed
"inorea <buffer> cdef <c-r>=IMAP_PutTextWithMovement("def <++>(<++>):\n<++>\nreturn <++>")<cr>
"inorea <buffer> cclass <c-r>=IMAP_PutTextWithMovement("class <++>:\n<++>")<cr>
"inorea <buffer> cfor <c-r>=IMAP_PutTextWithMovement("for <++> in <++>:\n<++>")<cr>
"inorea <buffer> cif <c-r>=IMAP_PutTextWithMovement("if <++>:\n<++>")<cr>
"inorea <buffer> cifelse <c-r>=IMAP_PutTextWithMovement("if <++>:\n<++>\nelse:\n<++>")<cr>


" RER 01/04/2005
" plugin pydoc.vim
:map K \pW

" RER 04/04/2005
" inclui '.' nas palavras para tab-complete
"set iskeyword+=.

