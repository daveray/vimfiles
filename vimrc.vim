""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Setup
"
" $ cat "runtime vimrc.vim" > ~/.vimrc

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

" set fairly common path stuff
set path+=src,test,resources

" Make sure things look nice in the terminal. This requires that the term
" report itself as xterm-256-color. csapprox requires gui support, so
" start with gvim -v
" I don't thins this is necessary...
"set t_Co=256

" Load plugins from .vim/bundles using .vim/autoload/pathogen.vim
execute pathogen#infect()
syntax on
filetype plugin indent on

runtime! macros/matchit.vim

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
set autoread
set fileformats+=mac

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

" In the command-line ctrl-j and ctrl-k go up/down. Slightly different from
" ctrl-p and ctrl-n since it takes what's already been typed into account.
cnoremap <c-j> <down>
cnoremap <c-k> <up>

inoremap <C-U> <C-G>u<C-U>

" Swap ` and ' for jumping to a mark.
nnoremap ' `
nnoremap ` '

set showmatch        " show matching brackets

set scrolloff=3      " keep a buffer around the cursor by scrolling the window
set sidescrolloff=3
set whichwrap=<,>,h,l,b,s  "cursor keys "wrap"
set display+=lastline

" I want to be able to select rectangles
set virtualedit=block

" Status line related settings
set showcmd
set showmode         " shows what mode you are in.  Useful for block cmds.
set ruler            " This shows the current position at lower left.
set laststatus=2

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
let NERDTreeIgnore=['^\.gradle$[[dir]]', '^classes$[[dir]]', '^target$[[dir]]', '^bin$[[dir]]', '^build$[[dir]]', '\.pyc$', '\~$', '^__pycache__$[[dir]]']

" Toggle nerd tree
nnoremap <silent> <Leader>t :NERDTreeToggle<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Line number stuff

set number  " Show line numbers
if exists('+relativenumber')
  set relativenumber
endif

" Toggle between absolute and relative line numbers
nnoremap <silent> <Leader>ln :set relativenumber!<cr>

" Remove trailing whitespace
nnoremap <silent> <Leader>ls :FixWhitespace<cr>

" Toggle line wrapping
nnoremap <silent> <Leader>lw :set wrap!<cr>

" Insert a horizontal rule
nnoremap <silent> <Leader>lh 080i#<esc>
nnoremap <silent> <Leader>lH 080i-<esc>

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
let g:ScreenImpl='GnuScreen'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" git bindings
nmap <silent> <leader>gs :Git<cr>
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
command -nargs=* Hg !hg <args>
command -nargs=* Hgstatus !hg status <args>
command -nargs=* Hgcommit !hg commit <args>
command -nargs=* Hgadd    !hg add <args>
command -nargs=* Hgpull   !hg pull <args>
command -nargs=* Hgpush   !hg push <args>
command -nargs=* Hglog    !hg log <args>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" p4 bindings
command -nargs=* P4 !p4 <args>

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
" Markdown
autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" misc

" Load other files
runtime subs.vim

