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

" map ,h i<c-r>=toupper(substitute(expand("%"), "\\.", "_", ""))

" common c/c++ settings
function! FT_ccpp()
   set formatoptions=coql cindent comments=sr:/*,mb:*,el:*/,://

   " Comment out a block
   vmap C <esc>`<O/*<esc>`>o*/<esc>
   vmap T <esc>`<dd`>dd

   " declare #ifndef header idiom
   map ,h <ESC>0i#ifndef _H<cr>#define _H<cr>#endif<esc>kkkwi

   " declare main
   map ,m <ESC>oint main(int argc, char *argv[])<cr>{<cr>return 0;<cr>}<ESC>%o

   if has("win32")
      " Insert a new UUID at the cursor
      map <M-u> <ESC>:r !uuidgen<cr>^i<BS><ESC>$
      imap <M-u> <ESC>:r !uuidgen<cr>^i<BS><ESC>$a
   elseif has("unix")
   endif

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
   " Alt-h forces fieltype to C.  Since .h files default to cpp.
   map <M-h> <ESC>:set filetype=c<cr>

   " include common c/c++ stuff
   call FT_ccpp()
   call FT_allcode()
endfunction

" Java language settings
function! FT_java()
   set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://

   " declare main
   " map <C-m> <ESC>opublic static void main(String[] args) {<cr>}<ESC>%o
   map ,m <ESC>opublic static void main(String[] args) {<cr>}<ESC>%o

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
   "Start tag
   imap <C-t> <><ESC>i
   "End a tag
   imap <C-g> </><ESC>i
   "Skip to end of tag
   "imap <C-l> <end>

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

