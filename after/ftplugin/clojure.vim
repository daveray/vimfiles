" If not explicitly set, default to port to 9999
if !exists('nreplPort')
  let nreplPort='9999'
endif

" Load current buffer
nnoremap <buffer> <Leader>cl :%Eval<cr>

" Call user/reset for reloaded workflow
nnoremap <buffer> <Leader>cr :call fireplace#eval('(reset)', {'ns':'user'})<cr>

" run tests appropriate for current ns
function! RunTestsAnywhere()
  let ns = fireplace#ns()
  if ns !~ "-test$"
    let testns = ns . '-test'
  else
    let testns = ns
  endif
  call fireplace#eval('(clojure.test/run-tests)', {'ns':testns})
endfunction

nnoremap <buffer> <Leader>ct :call RunTestsAnywhere()<cr>

" Using current value of nreplPort and current directory, connect to nrepl
nnoremap <buffer> <Leader>cc :execute "Connect" "nrepl://localhost:" . nreplPort "."<cr>

" Print last stacktrace.
nnoremap <buffer> <Leader>ce :execute "Eval (clojure.repl/pst)"<cr>
nnoremap <buffer> <Leader>cE :execute "Pipe Eval (clojure.repl/pst)"<cr>

" Show previous results
nnoremap <buffer> <Leader>c0 :Last<cr>
nnoremap <buffer> <Leader>c1 :Last2<cr>
nnoremap <buffer> <Leader>c2 :Last3<cr>

" pretty print last result
nnoremap <buffer> <Leader>cp :execute "Eval (do (require 'clojure.pprint) (clojure.pprint/pp))"<cr>

nnoremap <Tab> ==

" Remove all symbols from the current namespace
nnoremap <buffer> cpK :execute "Eval (count (mapv #(ns-unmap *ns* %) (keys (ns-interns *ns*))))"<cr>
" Remove symbol under the cursor from the current namespace
nnoremap <buffer> cpk :execute "Eval (ns-unmap *ns* '" . expand("<cword>") . ")"<cr>

function! CopyInNs()
  let ns = fireplace#ns()
  let cmd = "(in-ns '" . ns . ")"
  echo cmd
  let @+ = cmd
endfunction

" Copy an in-ns expression for current namespace to system clipboard
nnoremap <buffer> <Leader>ci :call CopyInNs()<cr>

" Evaluate the current expression and insert the result after
" as a comment.
nmap <buffer> <Leader>c! yab)A<cr><esc>pc!ab

" Snippets
command! -buffer -nargs=0 SchemaUseFixture :normal i(clojure.test/use-fixtures :once schema.test/validate-schemas)<cr>

" Add to ns :require
command! -buffer -nargs=1 -complete=customlist,fireplace#ns_complete NSRequire :normal gg/(:require [<cr>%i<cr>[<args> :as ]

