""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tips
"
" http://vim.wikia.com/wiki/Best_Vim_Tips
" I            Insert at start of line
" A            Insert at end of line
" * or #       Search for word under cursor
" :sp <file>   Split and open file (i in Nerdtree)
" H, M, L      Jump to top/middle/bottom of window
" g; or g,     Jump to last/next change position (:changes)
" gi           Insert at last edited position
" gf           Open file under cursor
" gq           Wrap lines using textwidth setting
" t{char}      Move to before {char}
" ~            Invert case of current char
" <C-o><C-i>   Walk through jump list
" <C-a><C-x>   Inc/Dec number under cursor
" <C-r><C-a>   Bring word under cursor into command line
" <C-r>%       Bring word under cursor into command line
" yiw          Yank current word
" yfX          Yank from current position to first instance of X
" daw          Delete word under cursor

set nocompatible

" Load plugins from .vim/bundles using .vim/autoload/pathogen.vim
call pathogen#runtime_append_all_bundles()

syntax on
filetype plugin on
filetype plugin indent on

"colorscheme desert
colorscheme vividchalk
set cursorline
set number

let st_no_folding = 1

let vimrc='$HOME/.vimrc'

" Backup file related settings
set backup
set backupdir=$HOME/vimbak
set autowrite        " automatically writes when changing files.

" GUI related settings
if has("gui")
   set mousehide
   set guioptions=agmrtTb
   set winaltkeys=no          "alt doesn't do window menus
   set lines=65
   set columns=80
endif

"let maplocalleader=','
let mapleader=" "

let g:rails_menu = 2 " Show Rails menu at top level

" Settings for VimClojure
let vimclojure#HighlightBuiltins=1
let vimclojure#HighlightContrib=1
let vimclojure#ParenRainbow=1

" Search related settings
set magic            " activates the pattern matching characters.
set wrapscan         " wrap back to top of file on search.
set nohlsearch       " don't highlight search matches.
set incsearch        " shows incremental searches.
set ignorecase
set smartcase

" Command history settings
set history=100
set viminfo='10,\"20,ra:,rb:
" Remember more stuff in viminfo so rail.vim will remember projects
set viminfo^=!

" smartindent causes annoying comment handling in lanugages that
" use # as the comment delimiter (Python, Tcl, etc)
" set smartindent
set cindent
set autoindent
set shiftwidth=4
set tabstop=4        " 3 is a nice round number
set shiftround       " round indents to multiples of shiftwidth
set expandtab        " replace tabs with spaces (stupid tabs)
set formatoptions=tcoq2l 
set showbreak=X\        " put a little string in wrapped lines
set bs=2		         " allow backspacing over everything in insert mode

inoremap kj <Esc>

" keep selection when changing indention level
vnoremap < <gv
vnoremap > >gv
" or use tab...
vmap <tab> >gv
vmap <s-tab> <gv

set showmatch        " show matching brackets

set scrolloff=4      " keep a buffer around the cursor by scrolling the window
set whichwrap=<,>,h,l,b,s  "cursor keys "wrap"

" Status line related settings
set showcmd
set showmode         " shows what mode you are in.  Useful for block cmds.
set ruler            " This shows the current position at lower left.
set laststatus=2
set statusline=%F%m%r%h\ %y\ \ %=%(%l\/%L%)\ %c
set cmdheight=2
set wildmenu
set wildchar=<TAB>
set shellslash       " use / rather than \ for filenames

set shortmess=atoOTA " This formats the responses at the bottom so that
                     " long file-names do not ask for a return.

set visualbell
set noerrorbells     " stupid bells

" These are the file extensions to ignore when mathing filenames.
set suffixes=.bak,.exe
set suffixes+=.o,.obj,.swp,~,.ncb,.opt,.plg,.aps,.pch,.pdb,.clw
set suffixes+=.class

set tags=./tags,./TAGS,tags,TAGS,../tags,../TAGS,.../tags,.../TAGS

set splitbelow       " open new window below current one on split

" Command Make will call make and then cwindow which 
" opens a 5 line error window if any errors are found. 
" if no errors, it closes any open cwindow. 
command -nargs=* Make make <args> | cwindow 5

" Map \m to run this make command
map <M-m> :Make<cr> 
map <C-M-m> :Make clean<cr> 

" I frequently still have the shift key down when I hit the e or w
" after I enter ':'.  This way they still work the same way as their
" lower case versions.
cab W w
cab E e

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Move by screen lines rather than actual lines
map j gj
map k gk
map <S-Down> <Down>
map <S-j> j
map <S-k> k

" In insert mode, hold down control to do movement, cursor keys suck.
imap <C-h> <Left>
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-l> <Right>

" Map ctrl-cursor keys to window switching
map <C-k> <C-w><Up>
map <C-j> <C-w><Down>
map <C-l> <C-w><Right>
map <C-h> <C-w><Left>

" Map alt-cursor keys to scrolling window a line at a time
noremap <M-j> <C-e>
noremap <M-k> <C-y>

nmap <C-e> :Explore<cr>
nmap <C-S-e> :Sexplore<cr>

" In insert mode, C-o and C-b open lines below and above
imap <C-o> <end><cr>
imap <C-b> <home><cr><Up>

" Alt-space skips next character in insert mode
imap <M-Space> <esc>la
imap <C-Space> <esc>lwi

" Toggle nerd tree
nnoremap <silent> <Leader>t :NERDTreeToggle<cr>

" Map shift-Y to show yankring
nnoremap <silent> <Leader>y :YRShow<cr>

" edit vimrc
nnoremap <silent> <F5> :e <C-R>=vimrc<cr><cr>
" reload vimrc
nnoremap <silent> <F6> :source <C-R>=vimrc<cr><cr>

" Switch to alternate file
map <C-Tab> :bnext<cr>
map <C-S-Tab> :bprevious<cr>

" file name completion
inoremap <C-f> <C-x><C-f>

" macro completion
inoremap <C-d> <C-x><C-d>

" a map to delete a word up to the next underscore or capital letter:
map ,w d/[_A-Z]<ESC>
map ,W c/[_A-Z]<ESC>

runtime filetypes.vim

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Substitutions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
iab cant can't
iab Cant Can't
iab dont don't
iab Dont Don't
iab wont won't
iab Wont Won't
iab alos      also
iab aslo      also
iab becuase   because
iab bianry    binary
iab bianries  binaries
iab charcter  character
iab charcters characters
iab exmaple   example
iab exmaples  examples
iab shoudl    should
iab seperate  separate
iab teh       the
iab tpyo      typo
iab optino    option
iab udpate    update
iab typdef typedef
iab flase false
iab /} //}}}
iab /{ //{{{

" Some geeky numbers
iab Npi 3.1415926535897932384626433832795028841972
iab Ne  2.7182818284590452353602874713526624977573

