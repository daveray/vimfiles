" If not explicitly set, default to port to 9999
if !exists('nreplPort')
  let nreplPort='9999'
endif

" Command that runs tests in the current namespace
command! -buffer -bar -bang RunTests :Require<bang><bar>Eval (clojure.test/run-tests)

nnoremap <buffer> cpt :RunTests<cr>
nnoremap <buffer> cpT :RunTests!<cr>

" Using current value of nreplPort and current directory, connect to nrepl
nnoremap <buffer> <Leader>cc :execute "Connect" "nrepl://localhost:" . nreplPort "."<cr>

" Print last stacktrace.
nnoremap <buffer> <Leader>ce :execute "Eval (clojure.repl/pst)"<cr>
nnoremap <buffer> <Leader>cE :execute "Pipe Eval (clojure.repl/pst)"<cr>

nnoremap <Tab> ==

" Remove all symbols from the current namespace
nnoremap <buffer> cpK :execute "Eval (count (mapv #(ns-unmap *ns* %) (keys (ns-interns *ns*))))"<cr>
" Remove symbol under the cursor from the current namespace
nnoremap <buffer> cpk :execute "Eval (ns-unmap *ns* '" . expand("<cword>") . ")"<cr>

function! CopyInNs()
  let ns = fireplace#ns()
  " switch to neutral ground, kill the ns, switch back to the ns.
  let cmd = "(in-ns '" . ns . ")"
  echo cmd
  let @+ = cmd
endfunction

" Copy an in-ns expression for current namespace to system clipboard
nnoremap <buffer> <Leader>ci :call CopyInNs()<cr>

