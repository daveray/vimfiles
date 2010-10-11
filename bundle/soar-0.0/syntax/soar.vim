" Vim syntax file for the Soar production language
"
" Language:    Soar
" Maintainer:  Joseph Xu (jzxu@umich.edu)
" Last Change: Dec 03,  2008 (rewrote it again, it now works correctly with
"                             embedded parentheses on the rhs and {} tests)
"              Apr 23,  2007 (pretty much rewrote it, folding now working)
"              Apr  3,  2007 (using hi link instead of assigning colors)
"              Sept 07, 2006 (first version)

if version < 600
  syn clear
elseif exists("b:current_syntax")
  finish
endif

setlocal iskeyword+=-
"setlocal iskeyword+=*

syn keyword soarCommand pushd popd source multi-attributes learn watch indifferent-selection epmem rl

syn keyword soarState state

syn region soarProd matchgroup=soarProdBraces start=/^\s*sp\s*{/ end=/}/ contains=soarProdName,soarDoc,soarProdFlag,soarLHS,soarRHS fold

syn region soarGProd matchgroup=soarProdBraces start=/^\s*gp\s*{/ end=/}/ contains=soarProdName,soarDoc,soarProdFlag,soarLHS,soarRHS fold

syn region soarGenProd matchgroup=soarGenProdBraces start=/^\s*gp\s*{/ end=/}/ contains=soarProdName,soarDoc,soarProdFlag,soarLHS,soarRHS fold

syn match  soarProdName /[-_\*[:alnum:]]\+\s*$/ nextgroup=soarLHS,soarDoc,soarProdFlag contained skipwhite skipempty

syn region soarDoc start=/"/ end=/"/ nextgroup=soarLHS,SoarProdFlag contained skipwhite skipempty

syn match  soarProdFlag /:\(o-support\|i-support\|chunk\|template\|default\)/ nextgroup=soarLHS contained skipwhite skipempty

syn region soarLHS start=/(\|{/ end=/-->/me=s-1 contains=soarCond,soarCondConj contained nextgroup=soarArrow

syn region soarCond start=/-\?(/ms=e+1 end=/)/ contains=soarState,soarConjTest,soarAttribConjTest contained skipwhite skipempty

syn region  soarAttribConjTest matchgroup=soarAttribConjTestBraces start=/-\?\^{/ end=/}/ contained

syn region soarCondConj start=/-\?{/ms=e+1 end=/}/me=s-1 contains=soarCond,soarCondConj contained skipwhite skipempty

syn region soarConjTest start=/{/ end=/}/ contained skipwhite skipempty

syn match  soarArrow /-->/ nextgroup=soarRHS skipwhite skipempty contained

syn region soarRHS start=/(/ end=/}/me=s-1 contains=SoarAction contained skipempty skipwhite

syn region soarAction start=/(/ end=/)/ contains=soarAction contained skipwhite skipempty

syn match soarOpProposal /\^operator\s\+<[-_\*[:alnum:]]\+>\s\++/ containedin=soarCond contained

syn keyword soarRhsFun write crlf halt interrupt div mod abs atan2 sqrt sin cos int float timestamp make-constant-symbol capitalize-symbol exec cmd containedin=soarAction contained

syn match soarOperator /(\s*\(+\|-\|\*\|\/\)\>/ containedin=soarAction contained

syn cluster soarEnclosures contains=soarCond,soarAction,soarConjTest,soarAttribConjTest

syn match  soarNum /\<-\?[0-9]*\.\?[0-9]\+\>/ containedin=@soarEnclosures contained
syn region soarString start=/|/ end=/|/ skip=/\\|/ containedin=@soarEnclosures contained oneline
syn match  soarVar /<[-_\*[:alnum:]]\+>/ containedin=@soarEnclosures contained

syn match  soarAttrib  /-_\?\^\([-\*[:alnum:]]\+\|<[-_\*[:alnum:]]\+>\)\(\.\([-_\*[:alnum:]]\+\|<[-+\*[:alnum:]]\+>\)\)*/ contains=soarVar containedin=soarCond,soarAction contained

syn match soarComment /#.*/ containedin=ALLBUT,jinjaRegion

syn region jinjaRegion start=/#{/ end=/}#/ containedin=ALL

hi soarProdBraces     guifg=Red          ctermfg=Red
hi soarGenProdBraces  guifg=Yellow       ctermfg=Yellow
hi soarArrow          guifg=Red          ctermfg=Red

hi link soarAttrib                Type
hi link soarAttribConjTestBraces  Type

hi link soarNum       Number
hi link soarString    String

hi link soarRhsFun    Operator
hi link soarOperator  Operator

hi link soarCommand   Keyword
hi link soarState     Keyword
hi link soarProdName  Function
hi link soarProdFlag  Keyword
hi link soarDoc       String
hi link soarVar       Identifier
hi link soarComment   Comment

hi link jinjaRegion PreProc

" Some other random highlights
syn match soarOpAttrib /\^operator\>/ containedin=soarAttrib contained
hi link soarOpAttrib Special

" A common mistake is to use <s> for the state variable and then also for
" something else. Make it more obvious so that these mistakes don't happen.
syn match soarStateVar /<s>/ containedin=ALL
hi soarStateVar       guifg=Yellow       ctermfg=Yellow

" Synchronization
syn sync minlines=50
syn sync maxlines=500
syn sync match prodsync grouphere soarProd /\<sp\>/

let b:current_syntax = "soar"

" only for debugging
"hi soarCondConj ctermbg=Blue
"hi soarLHS ctermbg=Red
"hi soarRHS ctermbg=Blue
"hi soarProd ctermbg=Red
"hi soarProdName ctermbg=Yellow
"hi soarCond ctermbg=Gray
"hi soarTestGroup ctermbg=White
"hi soarFunc ctermbg=Red
"hi soarAction ctermbg=Yellow
"hi soarMathExp ctermbg=Red
