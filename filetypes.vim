" File types
au! BufRead,BufNewFile *.json set filetype=json

" .md is much more often Markdown than modula2 for me
au! BufRead,BufNewFile *.md set filetype=markdown

" Treat these files as zips
au BufReadCmd *.jar,*.war,*.ear,*.sar,*.rar,*.ndp   call zip#Browse(expand("%"))


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" AutoCommands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType txt   call FT_txt()
autocmd FileType c   call FT_c()
autocmd FileType cpp   call FT_cpp()
autocmd FileType java   call FT_java()
autocmd FileType make   call FT_make()
autocmd FileType perl   call FT_perl()
autocmd FileType lisp   call FT_lisp()
autocmd FileType html,xml   call FT_html()
autocmd FileType tcl   call FT_tcl()
autocmd FileType ruby   call FT_ruby()
autocmd FileType python   call FT_python()

" common settings for any source code editing
function! FT_allcode()
   setl nowrap
endfunction

" common c/c++ settings
function! FT_ccpp()
   setl formatoptions=coql cindent comments=sr:/*,mb:*,el:*/,://
endfunction

function! FT_txt()
   setl linebreak
endfunction

" C language settings
function! FT_c()
   " include common c/c++ stuff
   call FT_ccpp()
   call FT_allcode()
endfunction

" C++ language settings
function! FT_cpp()
   " include common c/c++ stuff
   call FT_ccpp()
   call FT_allcode()
endfunction

" Java language settings
function! FT_java()
   setl formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://

   call FT_allcode()
endfunction

" Because MAKE files do not like expandtab, I set noexpandtab for
" makefiles
"-----------------------------------------------------------------------
function! FT_make()
   setl noexpandtab tabstop=8
   call FT_allcode()
endfunction

"Perl language settings
function! FT_perl()
   call FT_allcode()
endfunction

" HTML language settings
function! FT_html()
   " expand "keywords" for URL prefixes ( >= 5.7 )
   setl isk+=:,/,~
   call FT_allcode()
endfunction

function! FT_tcl()
   call FT_allcode()
endfunction

function! FT_ruby()
   call FT_allcode()
endfunction

function! FT_python()
   call FT_allcode()
   setl tabstop=4
   setl softtabstop=4
   setl shiftwidth=4
endfunction

