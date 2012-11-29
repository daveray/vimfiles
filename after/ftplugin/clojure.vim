" enable paredit in vimclojure repl
if exists('b:vimclojure_repl')
  call PareditInitBuffer()
endif
