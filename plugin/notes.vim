if exists('loaded_notes')
  finish
end

let g:loaded_notes = 1

" Opens today's log
nmap <silent> <Leader>nl :execute "split ~/.notes/log/" . strftime("%Y-%m-%d") . ".txt" <cr>
nmap <silent> <Leader>nn :execute "split ~/.notes/todo.txt" <cr>

function! ComposeNote()
  let title = tolower(input("Title: "))
  let file = "~/.notes/" . substitute(title, '\s\+', "-", "g") . ".txt"
  execute "split " . file
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

