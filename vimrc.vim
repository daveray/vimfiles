""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tips
"
" http://vim.wikia.com/wiki/Best_Vim_Tips
" I            Insert at start of line
" A            Insert at end of line
" * or #       Search for word under cursor (forward/back)
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
"
" To log vim stuff: $ vim -V9log.txt ...

set nocompatible

" I just want paredit
let g:slimv_loaded = 1
let g:slimv_clojure_loaded = 1

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
   \ vimfiles."/lib/*"
   \], 
   \ sep)

let java_opts = ""

" Load plugins from .vim/bundles using .vim/autoload/pathogen.vim
call pathogen#runtime_append_all_bundles()

filetype off " On some Linux systems, this is necessary to make sure pathogen
             " picks up ftdetect directories in plugins! :(
syntax on
filetype plugin indent on

"colorscheme desert
colorscheme vividchalk
set cursorline
set number

" Backup file related settings
set backup
set backupdir=$HOME/vimbak
set autowrite        " automatically writes when changing files.

" GUI related settings
if has("gui")
   set mousehide
   set guioptions=agmrb
   set winaltkeys=no          "alt doesn't do window menus
   set lines=65
   set columns=90
endif

let mapleader=" "
let maplocalleader=","

" Settings for slimv/paredit
let g:paredit_leader=","

" Settings for rails.vim
let g:rails_menu = 2 " Show Rails menu at top level

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
set shiftwidth=2
set tabstop=2
set shiftround       " round indents to multiples of shiftwidth
set expandtab        " replace tabs with spaces (stupid tabs)
set formatoptions=tcoq2l 
set showbreak=X\        " put a little string in wrapped lines
set bs=2		         " allow backspacing over everything in insert mode

" Typing :q and :w is too much work
nmap <Leader>q :q<cr>
nmap <Leader>w :w<cr>
" Hit k and then j for escape
inoremap kj <Esc>
" Ctrl-space for omni-complete
inoremap <c-Space> <c-x><c-o>

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
set statusline+=\ %{exists('g:loaded_fugitive')?fugitive#statusline():''}

set cmdheight=2
set wildmenu
set wildchar=<TAB>
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

" I frequently still have the shift key down when I hit the e or w
" after I enter ':'.  This way they still work the same way as their
" lower case versions.
cab W w
cab E e

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Clipboard copy/paste
vmap <Leader>c "+y
map <Leader>v "+gP

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

" Window resizing
map <silent> <A-h> <C-w><
map <silent> <A-j> <C-W>-
map <silent> <A-k> <C-W>+
map <silent> <A-l> <C-w>>

" In insert mode, C-o and C-b open lines below and above
imap <C-o> <end><cr>
imap <C-b> <home><cr><Up>

" Switch to alternate file
map <C-Tab> :bnext<cr>
map <C-S-Tab> :bprevious<cr>

" file name completion
inoremap <C-f> <C-x><C-f>
" line completion
inoremap <C-l> <C-x><C-l>
" macro completion
inoremap <C-d> <C-x><C-d>

" Toggle nerd tree
nnoremap <silent> <Leader>t :NERDTreeToggle<cr>

" Map <Leader>y to show yankring
nnoremap <silent> <Leader>y :YRShow<cr>

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
nmap <Leader>m :make<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vimgrep bindings and stuff

function Vimgrep_cmd(word, file_patterns)
  return "noautocmd vimgrep /" . a:word . "/j " . a:file_patterns
endf

function Vimgrep_file_patterns()
  let ext = expand("%:e")
  if ext == "c" || ext == "h" || ext == "cpp" || ext == "cc"
    return "**/*.h **/*.cpp **/*.c **/*.cc"
  else
    return "**/*." . ext
  endif
endf

" <Leader>f* to recursively search all files for the word under the cursor
map <silent> <Leader>f* :execute Vimgrep_cmd(expand("<cword>"), "**") <Bar> cwindow<CR>
" <Leader>ff to recursively search all files of same type for the word under the cursor
map <silent> <Leader>fw :execute Vimgrep_cmd(expand("<cword>"), Vimgrep_file_patterns()) <Bar> cwindow<CR>
map <silent> <Leader>fi :execute Vimgrep_cmd(input("Enter a search pattern: ", expand("<cword>")), Vimgrep_file_patterns()) <Bar> cwindow<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" scratch.vim bindings

" <Leader>b opens the scratch buffer. In visual mode, copy and paste to the
" end of the scratch buffer
map <Leader>b :Sscratch<CR>
vmap <Leader>b y:Sscratch<CR>Gp

function! Screenshell_prefix()
    return "ScreenShell cd \"" . fnamemodify(".",":p") . "\""
endf

function Screen_java(class, more_cp)
    let cp = g:classpath
    if !empty(a:more_cp)
        let cp .= g:sep . join(a:more_cp, g:sep)
    endif
    return Screenshell_prefix() . "; java -Xmx512M " . g:java_opts . " -cp \"" . cp . "\" " . a:class
endf


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" screen.vim bindings
" Start a vanilla shell
"nmap <silent> <Leader>so :execute "ScreenShell cd \"" . fnamemodify(".",":p") . "\"" <cr>
nmap <silent> <Leader>so :execute Screenshell_prefix() <cr>
" Quit the screen session
nmap <silent> <Leader>sq :ScreenQuit<cr>
" Start a Rhino JavaScript repl
nmap <silent> <Leader>sj :execute Screen_java("org.mozilla.javascript.tools.shell.Main", []) <cr>
" Start a Ruby repl
nmap <silent> <Leader>sr :execute Screenshell_prefix() . "; jirb" <cr>
nmap <silent> <Leader>sR :execute Screenshell_prefix() . "; irb" <cr>
" Start a Python repl
nmap <silent> <Leader>sp :execute Screenshell_prefix() . "; python" <cr>
nmap <silent> <Leader>sP :execute Screenshell_prefix() . "; jython" <cr>
" Send current file for visual selection to screen
nmap <silent> <Leader>ss :ScreenSend<cr>
vmap <silent> <Leader>ss :ScreenSend<cr>
" Start a Haskell repl
nmap <silent> <Leader>sh :execute Screenshell_prefix() . "; ghci" <cr>
" Don't forget about clojure (<Leader>sc) below!


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" git bindings
nmap <silent> <leader>gs :Gstatus<cr>
nmap <silent> <leader>gc :Gcommit -a<cr>
nmap <silent> <leader>gp :Git push<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" fuzzy finder bindings
let g:fuf_coveragefile_exclude = '\v\~$|\.(jar|o|exe|dll|bak|orig|swp|tif|class|gif)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])|(^|[/\\])(autodoc|classes|3rd-party|build|input_data|QA)($|[/\\])'
nmap <silent> <Leader>Z :FufBuffer<cr>
nmap <silent> <Leader>z :FufCoverageFile<cr>
nmap <silent> <Leader><C-Z> :FufRenewCache<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vimclojure stuff
" Settings for VimClojure
let vimclojureRoot = vimfiles."/bundle/vimclojure-2.2.0"
let vimclojure#HighlightBuiltins=1
let vimclojure#HighlightContrib=1
let vimclojure#DynamicHighlighting=1
let vimclojure#ParenRainbow=1
let vimclojure#WantNailgun = 1
let vimclojure#NailgunClient = vimclojureRoot."/lib/nailgun/ng"
if windows
    " In stupid windows, no forward slashes, and tack on .exe
    let vimclojure#NailgunClient = substitute(vimclojure#NailgunClient, "/", "\\", "g") . ".exe"
endif

" Start vimclojure nailgun server (uses screen.vim to manage lifetime)
nmap <silent> <Leader>sc :execute Screen_java("vimclojure.nailgun.NGServer 127.0.0.1", [vimclojureRoot . "/lib/*"]) <cr>
" Start a generic Clojure repl (uses screen.vim)
nmap <silent> <Leader>sC :execute Screen_java("clojure.main", []) <cr>

" Load other files
runtime filetypes.vim
runtime subs.vim

