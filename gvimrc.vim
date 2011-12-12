" GUI related settings
set mousehide
set guioptions=agrb
set guioptions-=m       " No menubar
set guioptions-=T       " No toolbar
set winaltkeys=no       "alt doesn't do window menus
set lines=65
set columns=90

" http://dejavu-fonts.org/wiki/Download
if has("win32") || has("win64")
  set guifont=DejaVu_Sans_Mono:h12:cANSI
else
  set guifont=DejaVu\ Sans\ Mono\ 12
endif

