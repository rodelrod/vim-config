" Vim filetype plugin file (Complementary)
" Language:	sql
" Maintainer:	Rodrigo Rodrigues <rodrigo.rodrigues@networkcontacto.com>
" Last Change:	10/08/2005

set expandtab

" Convert SQL to VBA SQL String
function ConvertSQLToVbSqlString() range
	execute a:firstline . "," . (a:lastline - 1) . 's/\v^(.*)$/"\1 " \& _/'
	execute a:lastline . 's/\v^(.*)$/"\1 "' 
:endfunction
:command ToVB :%call ConvertSQLToVbSqlString()

" Convert VBA SQL String to SQL
function ConvertVbSqlStringToSQL() range
	execute a:firstline . "," . (a:lastline - 1) . 's/\v^\s*"(.*) " \& _$/\1'
	execute a:lastline . 's/\v^\s*"(.*) "$/\1' 
:endfunction
:command ToSQL :%call ConvertVbSqlStringToSQL()
