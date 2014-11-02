""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Setup
"
" $ cat "runtime vimrc.vim" > ~/.vimrc
"
" Gist:
" $ git config --global github.user username
" $ git config --global github.token token

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tips
"
" :Vedit vimrc.vim - Edit this file
" http://vim.wikia.com/wiki/Best_Vim_Tips
" I            Insert at start of line
" A            Insert at end of line
" * or #       Search for word under cursor (forward/back)
" :sp <file>   Split and open file (i in Nerdtree)
" H, M, L      Jump to top/middle/bottom of window
" <C-f><C-b>   PageUp/PageDown
" g; or g,     Jump to last/next change position (:changes)
" gi           Insert at last edited position
" gf           Open file under cursor
" gq           Wrap lines using textwidth setting
" t{char}      Move to before {char}
" ~            Invert case of current char
" <C-o><C-i>   Walk through jump list
" <C-a><C-x>   Inc/Dec number under cursor
" <C-r><C-a>   Bring word under cursor into command line
" <C-r>%       Bring current file name into command line
" yiw          Yank current word
" yfX          Yank from current position to first instance of X
" daw          Delete word under cursor
"
" To log vim stuff: $ vim -V9log.txt ...

set nocompatible

" Let's remember some things, like where the .vim folder is.
if has("win32") || has("win64")
    let windows=1
    let vimfiles=$HOME . "/vimfiles"
    let sep=";"
else
    let windows=0
    let vimfiles=$HOME . "/.vim"
    let sep=":"
endif

" Build a reasonable classpath for most Maven, Leiningen, or whatever projects
" This is used by the Clojure and Rhino repls below. Note that lib/* is last
" so it can be overridden by project-local versions. Assumes working directory
" is the project root because that's the right way to use vim :)
let classpath = join(
   \[".",
   \ "src", "src/main/clojure", "src/main/resources",
   \ "test", "src/test/clojure", "src/test/resources",
   \ "resources",
   \ "classes", "target/classes",
   \ "lib/*", "lib/dev/*",
   \ "bin",
   \ vimfiles."/lib/*",
   \ vimfiles."/lib"
   \],
   \ sep)

let java_opts = ""

" set fairly common path stuff
set path+=src,test,resources

" Make sure things look nice in the terminal. This requires that the term
" report itself as xterm-256-color. csapprox requires gui support, so
" start with gvim -v
" I don't thins this is necessary...
"set t_Co=256

" Load plugins from .vim/bundles using .vim/autoload/pathogen.vim
call pathogen#infect()
syntax on
filetype plugin indent on

" Default to UTF-8
set encoding=utf-8

" Use option key as alt/meta on ridiculous MBP keyboard.
if has("mac")
  set macmeta
end

colorscheme desertEx

set cursorline
" Force cursorline to be an underline. Otherwise, it's hard to distinguish
" between cursorline and inactive window borders.
hi CursorLine term=underline ctermbg=8 gui=underline guibg=bg

"if exists('$TMUX')
  "let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  "let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
"else
  "let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  "let &t_EI = "\<Esc>]50;CursorShape=0\x7"
"endif

set number  " Show line numbers
if exists('+relativenumber')
  set relativenumber
endif

" Backup file related settings
set backup
set backupdir=$HOME/vimbak
set autowrite        " automatically writes when changing files.

let mapleader=" "
let maplocalleader=","

" Settings for gist.vim
" If there's no git, don't try to load gist.vim. It handles it less gracefull
" than I'd like.
if !executable("git")
  let g:loaded_gist_vim = 1
end

" Settings for slimv/paredit
let g:paredit_leader=","
let g:paredit_smartjump=1

" Search related settings
set magic            " activates the pattern matching characters.
set wrapscan         " wrap back to top of file on search.
set hlsearch         " highlight search matches.
set incsearch        " shows incremental searches.
set ignorecase
set smartcase

" Command history settings
set history=1000
set viminfo='10,\"20,ra:,rb:

" Always save session with forward slashes. More portable.
set sessionoptions+=unix,slash

" smartindent causes annoying comment handling in lanugages that
" use # as the comment delimiter (Python, Tcl, etc)
" http://vim.wikia.com/wiki/Restoring_indent_after_typing_hash
" set smartindent
" set cindent
set autoindent
set shiftwidth=2
set tabstop=2
set shiftround       " round indents to multiples of shiftwidth
set expandtab        " replace tabs with spaces (stupid tabs)
set smarttab
set formatoptions=tcoq2l
set showbreak=…\     " put a little ... in wrapped lines
set bs=2		         " allow backspacing over everything in insert mode

" Clear search highlighting
nmap <silent> <Leader>/ :nohlsearch<cr>

" Typing :q and :w is too much work
nmap <Leader>q :q<cr>
nmap <Leader>Q :qall<cr>
nmap <Leader>w :w<cr>
nmap <Leader>W :wall<cr>

nmap <F5> :e %<cr>

" Semi-colon enters command window in insert mode
nmap ; q:
au CmdwinEnter * startinsert

" Hit j and then k for escape
inoremap jk <Esc>

" Ctrl-space for omni-complete
inoremap <c-Space> <c-x><c-o>

" Space-space goes to end of file and starts editing.
nnoremap <Leader><Space> G$a

" In visual line mode, I always accidently keep the shift key down
" which causes me to join lines (or lookup a keyword) instead of highlight
" them.
vnoremap K k
vnoremap J j
"
" keep selection when changing indention level
vnoremap < <gv
vnoremap > >gv
" or use tab...
vmap <tab> >gv
vmap <s-tab> <gv

" Make command line act like it has readline bindings
cnoremap <C-a>  <Home>
cnoremap <C-b>  <Left>
cnoremap <C-e>  <End>
cnoremap <C-f>  <Right>
cnoremap <C-d>  <Delete>
cnoremap <M-b>  <S-Left>
cnoremap <M-f>  <S-Right>
cnoremap <M-d>  <S-right><Delete>
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>
cnoremap <Esc>d <S-right><Delete>
cnoremap <C-g>  <C-c>
"
" In the command-line ctrl-j and ctrl-k go up/down. Slightly different from
" ctrl-p and ctrl-n since it takes what's already been typed into account.
cnoremap <c-j> <down>
cnoremap <c-k> <up>

" Make insert mode act like it has readline bindings
" I know some of these things have other meanings, but it's just too much to
" remember.
inoremap <C-a>  <Home>
inoremap <C-b>  <Left>
inoremap <C-e>  <End>
inoremap <C-f>  <Right>
inoremap <C-d>  <Delete>
inoremap <M-b>  <S-Left>
inoremap <M-f>  <S-Right>
inoremap <M-d>  <S-right><Delete>
inoremap <Esc>b <S-Left>
inoremap <Esc>f <S-Right>
inoremap <Esc>d <S-right><Delete>
inoremap <C-g>  <C-c>

" Swap ` and ' for jumping to a mark.
nnoremap ' `
nnoremap ` '

set showmatch        " show matching brackets

set scrolloff=4      " keep a buffer around the cursor by scrolling the window
set whichwrap=<,>,h,l,b,s  "cursor keys "wrap"

" I want to be able to select rectangles
set virtualedit=block

" Status line related settings
set showcmd
set showmode         " shows what mode you are in.  Useful for block cmds.
set ruler            " This shows the current position at lower left.
set laststatus=2

" set statusline=%F%m%r%h\ %y\ \ %=%(%l\/%L%)\ %c
" set statusline+=\ %{exists('g:loaded_fugitive')?fugitive#statusline():''}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" statline.vim stuff
" disable syntastic on the statusline
let g:statline_syntastic = 0
" enable fugitive statusline
let g:statline_fugitive = 1
let g:statline_no_encoding_string = 'n/a'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set title
set cmdheight=2

set wildmode=longest,list,full
if exists('&wildignorecase')
  set wildignorecase
endif
set wildmenu

set shellslash       " use / rather than \ for filenames

set shortmess=atoOTA " This formats the responses at the bottom so that
                     " long file-names do not ask for a return.

set visualbell
set noerrorbells     " stupid bells

" These are the file extensions to ignore when matching filenames.
set suffixes=.bak,.exe
set suffixes+=.o,.obj,.swp,~,.ncb,.opt,.plg,.aps,.pch,.pdb,.clw
set suffixes+=.class
set suffixes+=.pyc

set tags=./tags,./TAGS,tags,TAGS,../tags,../TAGS,.../tags,.../TAGS

set splitbelow       " open new window below current one on split
set splitright       " open new window to right current one on split

" When window is resized, resize splits. Not totally ideal, but better
" than the alternative.
au VimResized * exe "normal! \<c-w>="

" I frequently still have the shift key down when I hit the e or w
" after I enter ':'.  This way they still work the same way as their
" lower case versions.
cab W w
cab E e

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Clipboard copy/paste
vmap <Leader>y "+y
map <Leader>p "+gp
map <Leader>P "+gP

" Move by screen lines rather than actual lines
map j gj
map k gk
map <S-Down> <Down>
"map <S-j> j
"map <S-k> k

" In insert mode, hold down control to do movement, cursor keys suck.
imap <C-h> <Left>
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-l> <Right>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Window management

" Map ctrl-cursor keys to window switching
map <C-k> <C-w><Up>
map <C-j> <C-w><Down>
map <C-l> <C-w><Right>
map <C-h> <C-w><Left>

" Window resizing
map <silent> <A-h> <C-w><
map <silent> <A-H> 7<C-w><

map <silent> <A-j> <C-W>-
map <silent> <A-J> 7<C-W>-

map <silent> <A-k> <C-W>+
map <silent> <A-K> 7<C-W>+

map <silent> <A-l> <C-w>>
map <silent> <A-L> 7<C-w>>

" Close everything but the current window
nmap <silent> <Leader>o :only<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tab management
" Use gt and gT to move through tabs
map <silent> <A-t> :tabnew<cr>

" In insert mode, alt-o and alt-shift-o open lines below and above
imap <A-o> <end><cr>
imap <A-O> <home><cr><Up>

" move current line up
nmap <A-s> ddp
nmap <A-S> yyp

" move current line up
nmap <A-w> ddkP
nmap <A-W> yyP

" Cycle through buffers
nmap <C-n> :bnext<cr>
nmap <C-p> :bprevious<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree config
let NERDTreeIgnore=['^\.gradle$[[dir]]', '^classes$[[dir]]', '^target$[[dir]]', '^bin$[[dir]]', '^build$[[dir]]', '\.pyc$', '\~$']

" Toggle nerd tree
nnoremap <silent> <Leader>t :NERDTreeToggle<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Line number stuff

" Toggle between normal and relative line numbering
function ToggleNumberStyle()
  if &number
    set relativenumber
  else
    set number
  endif
endf

" Toggle between absolute and relative line numbers
nnoremap <silent> <Leader>ln :call ToggleNumberStyle()<cr>
" Remove trailing whitespace
nnoremap <silent> <Leader>ls :FixWhitespace<cr>
" Toggle line wrapping
nnoremap <silent> <Leader>lw :set wrap!<cr>
" Insert a horizontal rule
nnoremap <silent> <Leader>lh 080i#<esc>
nnoremap <silent> <Leader>lH 080i-<esc>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" openurl.vim bindings
nnoremap <silent> <Leader>ou :OpenUrlInBrowser<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Make bindings

" http://vim.wikia.com/wiki/Automatically_open_the_quickfix_window_on_:make
" Automatically open, but do not go to (if there are errors) the quickfix /
" location list window, or close it when is has become empty.
"
" Note: Must allow nesting of autocmds to enable any customizations for quickfix
" buffers.
" Note: Normally, :cwindow jumps to the quickfix window if the command opens it
" (but not if it's already open). However, as part of the autocmd, this doesn't
" seem to happen.
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" Map \m to run this make command
nmap <Leader>m :make!<cr>

" if there's an error in a header file, stupid gcc includes a bunch of
" 'In file included from ...' lines that quickfix doesn't like. Ignore
" them.
"  http://stackoverflow.com/questions/6747337/using-vim-make-with-quickfix-ends-up-creating-a-new-file-when-error-is-in-heade
set errorformat^=%-GIn\ file\ included\ %.%#

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ack bindings and stuff

function Ack_cmd(options, word)
  return "Ack! -Q ". a:options . " '" . a:word . "'"
endf

" <Leader>f* to recursively search all files for the word under the cursor
map <silent> <Leader>f* :execute Ack_cmd("--unrestricted", expand("<cword>"))<CR>
" <Leader>fw to recursively search source files for the word under the cursor
map <silent> <Leader>fw :execute Ack_cmd("", expand("<cword>"))<CR>
map <silent> <Leader>fi :execute Ack_cmd("", input("Enter a search pattern: "))<CR>
map <silent> <Leader>ff :cnext<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pipe to buffer

function! PipeToBuffer(cmd)
  redir => message
  silent execute a:cmd
  redir END
  "tabnew
  new
  silent put=message
  set nomodified
endfunction

" Run an ex command and pipe the result to a new scratch buffer
"   e.g. :Pipe !hg log
command! -nargs=+ -complete=command Pipe call PipeToBuffer(<q-args>)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" scratch.vim bindings

" <Leader>b opens the scratch buffer. In visual mode, copy and paste to the
" end of the scratch buffer
map <Leader>b :Sscratch<CR>
vmap <Leader>b y:Sscratch<CR>Gp


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" screen.vim bindings
" Send current file or visual selection to screen
nmap <silent> <Leader>ss :ScreenSend<cr>
vmap <silent> <Leader>ss :ScreenSend<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" git bindings
nmap <silent> <leader>gs :Gstatus<cr>
nmap <silent> <leader>ge :Gedit<cr>
nmap <silent> <leader>gd :Gdiff<cr>
nmap <silent> <leader>gP :Git push<cr>
nmap <silent> <leader>gp :Git pull<cr>
nmap <silent> <leader>gv :Gitv --all<cr>
nmap <silent> <leader>gV :Gitv! --all<cr>
vmap <silent> <leader>gV :Gitv! --all<cr>

let g:Gitv_OpenHorizontal = 1
" The ctrl key mapping in gitv really chap my hide
let g:Gitv_DoNotMapCtrlKey = 1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" hg bindings
command -nargs=* H !hg <args>
command -nargs=* Hstatus !hg status <args>
command -nargs=* Hcommit !hg commit <args>
command -nargs=* Hadd    !hg add <args>
command -nargs=* Hpull   !hg pull <args>
command -nargs=* Hpush   !hg push <args>
command -nargs=* Hlog    !hg log <args>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" p4 bindings
command -nargs=* P4 !p4 <args>
nmap <silent> <leader>ra :P4 add %<cr>
nmap <silent> <leader>re :P4 edit %<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" fuzzy finder bindings
let g:fuf_coveragefile_exclude =
      \'\v\~$|'.
      \'\.(class|jar|o|exe|dll|so|pyc|bak|orig|swp|swo|tif|gif)$|'.
      \'(^|[/\\])\.(hg|git|bzr|svn|CVS|settings)($|[/\\])|'.
      \'(^|[/\\])(images|autodoc|classes|3rd-party|bin|build|dist|target|input_data|QA)($|[/\\])'
nmap <silent> <Leader>zb :FufBuffer<cr>
nmap <silent> <Leader>zB :FufBuffer!<cr>
nmap <silent> <Leader>zf :FufCoverageFile<cr>
nmap <silent> <Leader>zF :FufCoverageFile!<cr>
nmap <silent> <Leader>zd :FufDir<cr>
nmap <silent> <Leader>zD :FufDir!<cr>
nmap <silent> <Leader>zh :FufHelp<cr>
nmap <silent> <Leader>zH :FufHelp!<cr>
nmap <silent> <Leader>zr :FufRenewCache<cr>

autocmd FileType fuf imap <buffer> <Tab>   <C-n>
autocmd FileType fuf imap <buffer> <S-Tab> <C-p>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" rainbow paren stuff

" This sets rainbow parens to match the colors from vimclojure
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'purple1'],
    \ ['brown',       'magenta1'],
    \ ['gray',        'slateblue1'],
    \ ['black',       'cyan1'],
    \ ['darkmagenta', 'springgreen1'],
    \ ['Darkblue',    'green1'],
    \ ['darkgreen',   'greenyellow'],
    \ ['darkcyan',    'yellow1'],
    \ ['darkred',     'orange1'],
    \ ['red',         'green2'],
    \ ]

" always on
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-fireplace and friends stuff
" I'd rather start the repl myself, plus this fixes checkout deps issues
" https://github.com/tpope/vim-leiningen/issues/3
let g:leiningen_no_auto_repl = 1

" Further clojure settings are in .vim/after/indent/clojure.vim

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" syntastic stuff

" syntastic doesn't know about my c setup so tell it to shutup.
"let g:syntastic_mode_map = { 'mode': 'active',
"                            \ 'active_filetypes': [],
"                            \ 'passive_filetypes': ['c', 'cpp', 'html'] }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" haskell stuff
" also in after/ftplugin/haskell.vim
let g:haskell_enable_quantification = 1
let g:haskell_enable_recursivedo = 1
let g:haskell_enable_arrowsyntax = 1
let g:haskell_enable_pattern_synonyms = 1
let g:haskell_enable_typeroles = 1

let g:haskell_indent_if = 3
let g:haskell_indent_case = 5
let g:haskell_indent_let = 4
let g:haskell_indent_where = 6
let g:haskell_indent_do = 3
let g:haskell_indent_in = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" misc

" Load other files
runtime filetypes.vim
runtime subs.vim

