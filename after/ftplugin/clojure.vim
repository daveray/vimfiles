
" Command that runs tests in the current namespace
command! -buffer -bar -bang RunTests :Require<bang><bar>Eval (clojure.test/run-tests)

function! s:ResetNamespace()
  let ns = foreplay#ns()
  " switch to neutral ground, kill the ns, switch back to the ns.
  let cmd = "(in-ns 'clojure.core)(remove-ns '" . ns . ")(in-ns '" . ns . ")"
  echo cmd
  try
    call foreplay#eval(cmd)
  catch /^Clojure:.*/
    return ''
  endtry
endfunction

" Command that brutally guts a namespace.
command! -buffer -bar ResetNamespace :call s:ResetNamespace()

nnoremap <buffer> cpt :RunTests<cr>
nnoremap <buffer> cpT :RunTests!<cr>

" Using current value of nreplPort and current directory, connect to nrepl
nnoremap <buffer> <Leader>cc :execute "Connect" "nrepl://localhost:" . nreplPort "."<cr>

" Print last stacktrace.
nnoremap <buffer> <Leader>ce :execute "Eval (clojure.repl/pst)"<cr>
nnoremap <buffer> <Leader>cE :execute "Pipe Eval (clojure.repl/pst)"<cr>

nnoremap <Tab> ==
