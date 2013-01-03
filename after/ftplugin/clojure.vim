
function! s:RunTests(bang)
  let req = (a:bang ? 'Require!' : 'Require')
  execute req
  execute 'Eval (clojure.test/run-tests)'
endfunction

" Command that runs tests in the current namespace
command! -buffer -bar -bang RunTests :execute s:RunTests(<bang>0)

function! s:KillNamespace()
  let ns = foreplay#ns()
  let cmd = "(in-ns 'clojure.core)(remove-ns '" . ns . ")(ns " . ns . ")"
  echo cmd
  try
    call foreplay#eval(cmd)
  catch /^Clojure:.*/
    return ''
  endtry
endfunction

" Command that brutally kills a namespace.
command! -buffer -bar KillNamespace :execute s:KillNamespace()
