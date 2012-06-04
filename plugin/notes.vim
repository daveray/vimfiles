if exists('loaded_notes')
  finish
end

let g:loaded_notes = 1

let g:notes_dir = "~/.notes"

set path+=~/.notes

function! GetLogDate(offset)
    let t = localtime() + (a:offset * 60 * 60 * 24)
    return strftime("%Y-%m-%d", t)
endfunction

" Opens today's log in a split
nmap <silent> <Leader>nl :execute "split ~/.notes/log/" . GetLogDate(0) . ".txt" <cr>

function! EditLog(offset)
    execute "edit ~/.notes/log/" . GetLogDate(a:offset) . ".txt"
endfunction

" Open logs going back 10 days
nmap <silent> <Leader>n0 :execute EditLog(0) <cr>
nmap <silent> <Leader>n1 :execute EditLog(-1) <cr>
nmap <silent> <Leader>n2 :execute EditLog(-2) <cr>
nmap <silent> <Leader>n3 :execute EditLog(-3) <cr>
nmap <silent> <Leader>n4 :execute EditLog(-4) <cr>
nmap <silent> <Leader>n5 :execute EditLog(-5) <cr>
nmap <silent> <Leader>n6 :execute EditLog(-6) <cr>
nmap <silent> <Leader>n7 :execute EditLog(-7) <cr>
nmap <silent> <Leader>n8 :execute EditLog(-8) <cr>
nmap <silent> <Leader>n9 :execute EditLog(-9) <cr>

" open generic todo file
nmap <silent> <Leader>nn :execute "split ~/.notes/todo.txt" <cr>

function! ComposeNote()
  let title = tolower(input("Title: "))
  if title != ""
    let file = "~/.notes/" . substitute(title, '\s\+', "-", "g") . ".txt"
    execute "split " . file
  endif
endfunction

nmap <Leader>nc :execute ComposeNote() <cr>

function! FindNotes(cmd)
  silent execute a:cmd . " ~/.notes/todo.txt"
  silent execute "FufFileWithCurrentBufferDir"
endfunction

" fuzzy find over notes
nmap <silent> <Leader>nz :execute FindNotes("edit") <cr>
nmap <silent> <Leader>nZ :execute FindNotes("split") <cr>

" ack over notes
function! SearchNotes(word)
  silent execute "Ack! -i --text '" . a:word . "' ~/.notes/"
endfunction
nmap <silent> <Leader>nf :execute SearchNotes(input("Search notes: ")) <cr>
nmap <silent> <Leader>nd :execute SearchNotes("todo") <cr>

" Insert timestamp
nmap <silent> <Leader>nt a<C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR><Esc>
" Insert inline timestamp
nmap <silent> <Leader>nT i<C-R>=strftime("[%Y-%m-%d %a %I:%M %p]")<Esc>

