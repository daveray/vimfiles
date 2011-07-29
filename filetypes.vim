" File types
au! BufRead,BufNewFile *.json setfiletype json 

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
   set nowrap
endfunction

" common c/c++ settings
function! FT_ccpp()
   set formatoptions=coql cindent comments=sr:/*,mb:*,el:*/,://
endfunction

function! FT_txt()
   set linebreak
endfunction

" C language settings
function! FT_c()

   " decalare a struct
   " map <C-s> <ESC>otypedef struct {<cr>} ;<esc>^%hi 
   map ,s <ESC>otypedef struct {<cr>} ;<esc>^%hi 
   " declare an enum
   " map <C-e> <ESC>otypedef enum {<cr><cr>};<esc>^%hi 
   map ,e <ESC>otypedef enum {<cr><cr>};<esc>^%hi 

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
   set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://

   call FT_allcode()
endfunction

" Because MAKE files do not like expandtab, I set noexapandtab for
" makefiles
"-----------------------------------------------------------------------
function! FT_make()
   set noexpandtab tabstop=8
   call FT_allcode()
endfunction

"Perl language settings
function! FT_perl()
   call FT_allcode()
endfunction

" HTML language settings
function! FT_html()
   " expand "keywords" for URL prefixes ( >= 5.7 )
   se isk+=:,/,~
   call FT_allcode()
endfunction

function! FT_tcl()
   call FT_allcode()
   set autoindent
   set cinkeys-=0#
   set indentkeys-=0#
   set indentexpr=
endfunction

function! FT_ruby()
   call FT_allcode()
   set nocindent
   set autoindent
   set smartindent
   set cinkeys-=0#
   set indentkeys-=0#
   set indentexpr=
   set tabstop=2
   set shiftwidth=2
   set expandtab
   set smarttab
endfunction

function! FT_python()
   call FT_allcode()
   set nocindent
   set autoindent
   set smartindent
   set cinkeys-=0#
   set indentkeys-=0#
   set indentexpr=
   set tabstop=4
   set softtabstop=4
   set expandtab
   set smarttab
   set shiftwidth=4
endfunction

