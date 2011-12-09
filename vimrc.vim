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
   \ vimfiles."/lib/*",
   \ vimfiles."/lib"
   \], 
   \ sep)

let java_opts = ""

" Load plugins from .vim/bundles using .vim/autoload/pathogen.vim
call pathogen#runtime_append_all_bundles()

filetype off " On some Linux systems, this is necessary to make sure pathogen
             " picks up ftdetect directories in plugins! :(
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

set number  " Show line numbers

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

" Settings for rails.vim
let g:rails_menu = 2 " Show Rails menu at top level

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

" Clear search highlighting
nmap <silent> <Leader>8 :nohlsearch<cr>

" Typing :q and :w is too much work
nmap <Leader>q :q<cr>
nmap <Leader>Q :qall<cr>
nmap <Leader>w :w<cr>

" Semi-colon enters command window in insert mode
nmap ; q:
au CmdwinEnter * startinsert

" Hit k and then j for escape
inoremap kj <Esc>
" Ctrl-space for omni-complete
inoremap <c-Space> <c-x><c-o>

" Space-space goes to end of file and starts editing.
nnoremap <Leader><Space> G$a

" In visual line mode, I always accidently keep the shift key down
" which causes me to join lines (or lookup a keyword) instead of highlight 
" them.
vnoremap K k
vnoremap J j

" keep selection when changing indention level
vnoremap < <gv
vnoremap > >gv
" or use tab...
vmap <tab> >gv
vmap <s-tab> <gv

" Swap ` and ' for jumping to a mark.
nnoremap ' `
nnoremap ` '

set showmatch        " show matching brackets

set scrolloff=4      " keep a buffer around the cursor by scrolling the window
set whichwrap=<,>,h,l,b,s  "cursor keys "wrap"

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
vmap <Leader>c "+y
map <Leader>v "+gp
map <Leader>V "+gP

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

" 
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
    return "**/*"
  endif
endf

" <Leader>f* to recursively search all files for the word under the cursor
map <silent> <Leader>f* :execute Vimgrep_cmd(expand("<cword>"), "**") <Bar> cwindow<CR>
" <Leader>ff to recursively search all files of same type for the word under the cursor
map <silent> <Leader>fw :execute Vimgrep_cmd(expand("<cword>"), Vimgrep_file_patterns()) <Bar> cwindow<CR>
map <silent> <Leader>fi :execute Vimgrep_cmd(input("Enter a search pattern: ", expand("<cword>")), Vimgrep_file_patterns()) <Bar> cwindow<CR>

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
nmap <silent> <leader>ge :Gedit<cr>
nmap <silent> <leader>gd :Gdiff<cr>
nmap <silent> <leader>gp :Git push<cr>
let g:Gitv_OpenHorizontal = 1
nmap <silent> <leader>gv :Gitv<cr>
nmap <silent> <leader>gV :Gitv --all<cr>


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
" fuzzy finder bindings
let g:fuf_coveragefile_exclude = 
      \'\v\~$|'.
      \'\.(class|jar|o|exe|dll|so|pyc|bak|orig|swp|swo|tif|gif)$|'.
      \'(^|[/\\])\.(hg|git|bzr|svn|CVS|settings)($|[/\\])|'.
      \'(^|[/\\])(images|autodoc|classes|3rd-party|build|input_data|QA)($|[/\\])'
nmap <silent> <Leader>Z :FufBuffer<cr>
nmap <silent> <Leader>z :FufCoverageFile<cr>
nmap <silent> <Leader><C-Z> :FufRenewCache<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" conqueterm stuff
let g:ConqueTerm_ReadUnfocused = 1
if windows
else
  nmap <silent> <Leader>h :ConqueTermSplit bash<cr>
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vimclojure stuff
" Settings for VimClojure
let vimclojureRoot = vimfiles."/bundle/vimclojure-2.3.0"
let vimclojure#FuzzyIndent=1
let vimclojure#HighlightBuiltins=1
let vimclojure#HighlightContrib=1
let vimclojure#DynamicHighlighting=1
let vimclojure#ParenRainbow=1
let vimclojure#WantNailgun = 1
let vimclojure#SplitSize = 7
let vimclojure#NailgunClient = vimclojureRoot."/lib/nailgun/ng"
if windows
    " In stupid windows, no forward slashes, and tack on .exe
    let vimclojure#NailgunClient = substitute(vimclojure#NailgunClient, "/", "\\", "g") . ".exe"
endif

" Start vimclojure nailgun server (uses screen.vim to manage lifetime)
nmap <silent> <Leader>sc :execute Screen_java("vimclojure.nailgun.NGServer 127.0.0.1", [vimclojureRoot . "/lib/*"]) <cr>
" Start a generic Clojure repl (uses screen.vim)
nmap <silent> <Leader>sC :execute Screen_java("clojure.main", []) <cr>

" Add lazytest words
autocmd FileType clojure setlocal lispwords+=describe,it,testing

" Load other files
runtime filetypes.vim
runtime subs.vim

