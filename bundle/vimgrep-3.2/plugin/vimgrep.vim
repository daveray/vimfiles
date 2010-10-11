" Language:    vim script
" Maintainer:  Dave Silvia <dsilvia@mchsi.com>
" Date:        9/1/2004
"


" Version 3.2
"   Added:
"     -  VimfindEdit/EditVimfind()
"        operates the same as
"        VimgrepEdit/EditVimgrep()
"        VimgrepEditDel functionality
"        also applies.
"
" Version 3.1
"   Enhanced:
"    -  Rewrote s:vimGrep() for
"       search optimization.
"
" Version 3.0
"   New:
"    -  Rewrote to change optional
"       arguments to switches instead
"       of positional arguments.
"       Simplifies usage.
"    -  Changed documentation to
"       reflect same.
"   Misc:
"    -  Some minor code clean up
"    -  Removed use of dummy file
"       for empty Vim session.
"
" Version 2.2
"   Fixed:
"    -  Inappropriate inclusion of
"       command/function arguments.
"   New:
"    -  Added BuiltInHelp
"    -  Added VimfindToBuf
"    -  Added VimfindList
"    -  Added VimgrepList
"    -  Added VimgrepHelpList
"    -  Added Command/Function Help
"       menu/mapped '??'
"
"       Vim[find|grep]List opens a
"       buffer listing file name
"       results from the respective
"       function.  Then simply cursor
"       to a line in the list, and
"       press 'o' to open the listed
"       file in an edit buffer.
"       
"
" Version 2.1
"   Fixed:
"    -  echo-ed results scrolling off
"       command line by adding Pause()
"    -  problem with file argument
"       being '/' would append '/*' to
"       search which always failed.
"       Now only appends extra '/' if
"       file argument does not end in
"       '/' or '\'.
"   Enhanced:
"    -  Stopped search after first match
"       if FNonly.  Do no search at all
"       if srchpat == '\%$'
"   New:
"    -  Added Vimfind
"       (inspired by email from
"         Hari Krishna Dara)
"
" Version 2.0
"   Changed script name to vimgrep.vim
"   Introduced naming convention for
"   commands and functions.  Commands
"   begin Vimgrep[\w*], functions and
"   variables begin [\w*]Vimgrep
"
"   Function MiniVimGrep() obsoleted.
"   Replaced with Vimgrep().
"   Wrapper exists to maintain
"   backward compatibility.
"
"   New:
"    -  Added opening of edit buffers
"       for successfully grep-ed files.
"    -  Added help files grep-ing.
"    -  Added delete of edit/help
"       buffers.
"    -  Added gvim menu/toolbar items
"       and key mappings for deleting.
"    -  Included documentation files.
"    -  rewrote, beefed up, made more
"       robust, and otherwise enhanced.
"
" Version 1.1
"   For grep-ing in open buffers:
"    -  Added BufVimgrep for grep-ing all open buffers
"    -  Added code to set cursor to line 1, col 1 in the file in case it is
"       being done with open buffers.  Then the cursor is set back to its
"       original position.
"    -  Added code to allow passing '%' or '' for file, meaning current buffer
"    -  Added augroup and autocmd to save the buffer number so it can be used
"       to return to the original buffer if grep-ing in open buffers
"
"   For multiple files
"    -  Added code to check for comma and newline file name separators.
"       Comma allows the user to specify 'file' argument as
"       "file1,file2,...", while newline allows 'file' argument to be
"       something like glob(expand("%:p:h")."/*") or
"       glob("<some-path>/*")
"    -  Added code to check if file is the same as the original open
"       buffer, if so, don't do bwipeout.
"    -  Added second optional argument for returning file names only.
"       If non-zero, just return file names, not the matching lines.
"
"   Misc
"    -  Added code to test for empty files
"    -  Added code to test for directories
"
" Version 1.0
"
" Original Release
"
" This script is a grep utility without an outside grep program.  It uses
" vim's native search capabilities on a single file.  It has 2 required
" arguments, the pattern and the file name, and one optional argument for
" matching case.  If the file argument does not include a full path
" specification, it is searched for in the current buffer's directory.


function! s:getHelpIsKeyWord()
	let HelpKeyWordCmd='silent! h | let g:VGHlpISK=&iskeyword | silent! bwipeout'
	execute HelpKeyWordCmd
	let g:VGHlpISK=substitute(g:VGHlpISK,'|',"\\\\|","g")
	let g:VGHlpISK=substitute(g:VGHlpISK,'"','\\\\"',"g")
endfunction

function! s:setUpVimgrep()
	if exists("g:VimgrepSetUp")
		return
	endif
	let g:VimgrepSetUp=1
" directory in which to create dummy file and grep program result file
if !exists("g:VGCreatDir")
	let g:VGCreatDir="~"
endif

" directories to search when file arguments are not fully qualified paths
if !exists("g:VGDirs")
	let g:VGDirs=expand("~").",".&runtimepath.",".getcwd()
endif

" directories to search for 'doc/*.txt' help files
if !exists("g:VGHlpDirs")
	let g:VGHlpDirs=expand("~").",".&runtimepath
endif

" defaults for optional arguments
if !exists("g:VGMCDflt")
	let g:VGMCDflt=0
endif

if !exists("g:VGFNonlyDflt")
	let g:VGFNonlyDflt=0
endif

if !exists("g:VGterseDflt")
	let g:VGterseDflt=0
endif

if !exists("g:VGdoSubsDflt")
	let g:VGdoSubsDflt=0
endif

if !exists("g:VGfpatDflt")
	let g:VGfpatDflt=''
endif

if !exists("g:VGmpatDflt")
	let g:VGmpatDflt=''
endif

"
" key mappings & GUI menu/toolbar for delete of Help/Edit buffers and Vimgrep
" command/function help
"
if !exists("g:VGdelHlpmap")
	let g:VGdelHlpmap='<F6>'
endif
if !exists("g:VGdelEdtmap")
	let g:VGdelEdtmap='<F7>'
endif
if !exists("g:VGComFuncHlpmap")
	let g:VGComFuncHlpmap='??'
endif
let s:mapIt='map '.g:VGdelHlpmap.' :call <SID>DeleteVimgrepHelp()<CR>'
execute s:mapIt
let s:mapIt='map '.g:VGdelEdtmap.' :call <SID>DeleteVimgrepEdit()<CR>'
execute s:mapIt
let s:mapIt='map '.g:VGComFuncHlpmap.' :call <SID>comFuncHlp()<CR>'
execute s:mapIt

" if gui, add to menus
if has("gui_running")
	" add 'Delete Vimgrep Help Buffers' to User Specific menu
	let s:menuIt='amenu &User\ Specific.&Vimgrep.&Vimgrep\ Buffers.Delete\ &Help\ Buffers<TAB>'.g:VGdelHlpmap.' :call <SID>DeleteVimgrepHelp()<CR>'
	execute s:menuIt
	" add 'Delete Vimgrep Edit Buffers' to User Specific menu
	let s:menuIt='amenu &User\ Specific.&Vimgrep.&Vimgrep\ Buffers.Delete\ &Edit\ Buffers<TAB>'.g:VGdelEdtmap.' :call <SID>DeleteVimgrepEdit()<CR>'
	execute s:menuIt
	" add 'Vimgrep Command/Function Help' to User Specific menu
	let s:menuIt='amenu &User\ Specific.&Vimgrep.Vimgrep\ Command/Function\ &Help<TAB>'.g:VGComFuncHlpmap.' :call <SID>comFuncHlp()<CR>'
	execute s:menuIt
	if !exists("g:VGdelHlpIco")
		let g:VGdelHlpIco='tb_close'
	endif
	if !exists("g:VGdelEdtIco")
		let g:VGdelEdtIco='tb_close'
	endif
	if !exists("g:VGcomFuncHlpIco")
		let g:VGcomFuncHlpIco='quest'
	endif
	" ditto ToolBar... if you don't want the default icons, change to your
	" preference with 'let delVG[Help|Edit]Ico=' before you source this script
	amenu 1.399 ToolBar.-399- <Nop>
	let s:menuIt='amenu icon='.g:VGdelHlpIco.' 1.400 ToolBar.Delete\ Vimgrep\ Help\ Buffers :call <SID>DeleteVimgrepHelp()<CR>'
	execute s:menuIt
	let s:menuIt='amenu icon='.g:VGdelEdtIco.' 1.401 ToolBar.Delete\ Vimgrep\ Edit\ Buffers :call <SID>DeleteVimgrepEdit()<CR>'
	execute s:menuIt
	let s:menuIt='amenu icon='.g:VGcomFuncHlpIco.' 1.403 ToolBar.Vimgrep\ Command/Function\ Help :call <SID>comFuncHlp()<CR>'
	execute s:menuIt
	amenu 1.405 ToolBar.-405- <Nop>
	" 'roll over' help...
	tmenu ToolBar.Delete\ Vimgrep\ Help\ Buffers Delete Vimgrep Help Buffers
	tmenu ToolBar.Delete\ Vimgrep\ Edit\ Buffers Delete Vimgrep Edit Buffers
	tmenu ToolBar.Vimgrep\ Command/Function\ Help Vimgrep Command/Function Help
	endif
" END if gui, add to menus
"
" END key mappings & GUI menu/toolbar for delete of Help/Edit buffers
"
call s:getHelpIsKeyWord()
endfunction

" Help:command  SUVIMGREP sets up Vimgrep variables, etc.
command! SUVIMGREP unlet! g:VimgrepSetUp | call s:setUpVimgrep()

SUVIMGREP

augroup vimgrepgrp
	autocmd!
	" set the buffer number so it can be readily gotten if needed
	autocmd BufEnter,BufNew,BufAdd,BufRead * let b:bufNo=expand("<abuf>")
	" get rid of any list files used in displays
	autocmd VimLeave * call s:deleteVGlists()
	" wipeout list buffers when they're deleted
	autocmd BufDelete s:VGlists call s:wipeoutVGlistBuf(expand("<afile>"))
augroup END

let s:VGlists=
	\expand(g:VGCreatDir.'/.vimfindlist').','.
	\expand(g:VGCreatDir.'/.vimgreplist').','.
	\expand(g:VGCreatDir.'/.builtinlist').','.
	\expand(g:VGCreatDir.'/.helpfilelist').','.
	\expand(g:VGCreatDir.'/.tokenhelplist').','.
	\expand(g:VGCreatDir.'/.vimgrepComFuncHlplist')

function! s:deleteVGlists()
	let theFile=StrListTok(s:VGlists,'g:VGlists')
	while theFile != ''
		let theFile=glob(theFile)
		if theFile != ''
			let failure=delete(theFile)
			if failure
				let theMsg=" \<NL>  Failed to delete: ".theFile
				VGMSG theMsg,2
			endif
		endif
		let theFile=StrListTok('','g:VGlists')
	endwhile
endfunction

function! s:wipeoutVGlistBuf(bname)
	if bufexists(a:bname)
		VGMSG " \<NL>Permanently deleting buffer containing <".a:fname.">",1,'Comment',1
		execute 'silent! bwipeout '.bufnr(a:fname)
	endif
	if exists("g:syntax_on") && g:syntax_on
		syntax enable
	endif
endfunction

let s:thisFileQPath=expand("<sfile>:p")
let s:thisScript=expand("<sfile>:t")


" g:VGMSGLEVEL=2  error messages only
" g:VGMSGLEVEL=1  error & warning messages only
" g:VGMSGLEVEL=0  all messages
" set in your vimrc to change default or use VMSGLVL command to set on the fly
if !exists("g:VGMSGLEVEL")
	" show warnings & errors
	let g:VGMSGLEVEL=1
endif
if !exists("g:VGMSGPAUSE")
	let g:VGMSGPAUSE=1
endif

"Help:command  VGMSGLVL lvl, sets messages level to 'lvl' (0-2)
command! -nargs=1 VGMSGLVL let g:VGMSGLEVEL=<args> | if g:VGMSGLEVEL < 0 | let g:VGMSGLEVEL=0 | elseif g:VGMSGLEVEL > 2 | let g:VGMSGLEVEL=2 | endif

command! -nargs=1 VGMSG call s:vimgrepMsg(expand("<sfile>"),<args>)

function! s:vimgrepMsg(func,msg,...)
	if a:0 | let lvl=a:1 | else | let lvl=0 | endif
	if lvl < g:VGMSGLEVEL
		return
	endif
	if a:0 > 1 | let hilite=a:2 | else | let hilite='' | endif
	if a:0 > 2 | let pause=1 | else | let pause=0 | endif
	if lvl == 1
		echohl Warningmsg
	elseif lvl > 1
		echohl Errormsg
	endif
	if hilite != '' && hilite != '""' && hilite != "''"
		execute 'echohl '.hilite
	endif
	let theMsg=a:msg
	let msgline=StrListTok(a:msg,'g:VGMSGLINES',"\<NL>\\+")
	echomsg s:thisScript."::".a:func.": ".msgline
	let msgline=StrListTok('','g:VGMSGLINES')
	while msgline != ''
		echomsg msgline
		let msgline=StrListTok('','g:VGMSGLINES')
	endwhile
	unlet g:VGMSGLINES
	if (lvl > 1 && g:VGMSGPAUSE) || pause
		echohl Cursor
		echo "          Press a key to continue"
		call getchar()
		:redraw
	endif
	echohl None
endfunction

let s:optsSet=0

function! s:dfltOpts()
	let s:MC=g:VGMCDflt
	let s:FNonly=g:VGFNonlyDflt
	let s:terse=g:VGterseDflt
	let s:doSubs=g:VGdoSubsDflt
	let s:fpat=g:VGfpatDflt
	let s:mpat=g:VGmpatDflt
endfunction

function! s:setOpts(...)
	if s:optsSet
		return
	endif
	call s:dfltOpts()
	let maxOpt=a:0
	let thisOpt=1
	while thisOpt <= maxOpt
		let optArg='a:'.thisOpt
		if {optArg}[0] == '-'
			if {optArg}[1] ==# 'M'
				let s:MC=1-s:MC
			elseif {optArg}[1] ==# 'F'
				let s:FNonly=1-s:FNonly
			elseif {optArg}[1] ==# 't'
				let s:terse=1-s:terse
			elseif {optArg}[1] ==# 'd'
				let s:doSubs=1-s:doSubs
			elseif {optArg}[1] ==# 'f'
				let thisOpt=thisOpt+1
				let optArg='a:'.thisOpt
				let s:fpat={optArg}
			elseif {optArg}[1] ==# 'm'
				let thisOpt=thisOpt+1
				let optArg='a:'.thisOpt
				let s:mpat={optArg}
			endif
		endif
		let thisOpt=thisOpt+1
	endwhile
	let s:optsSet=1
endfunction

command! -nargs=0 HILITE1st call s:hilite1st()
function! s:hilite1st()
	let saveWS=&wrapscan
	set wrapscan
	execute "normal \<C-End>"
	silent! normal n
	let &wrapscan=saveWS
endfunction

command! -nargs=0 SETOPTS
\ if a:0 |
\	let l:optNr=1 |
\	let l:soCmd='' |
\	while l:optNr <= a:0 |
\		let l:Opt='a:'.l:optNr |
\		let l:soCmd=l:soCmd.",'".{l:Opt}."'" |
\		let l:optNr=l:optNr+1 |
\	endwhile |
\	let l:soCmd=strpart(l:soCmd,1) |
\	let l:soCmd='call s:setOpts('.l:soCmd.')' |
\	execute l:soCmd |
\else |
\	call s:setOpts() |
\endif

function! s:doDummyView()
	let dummyDir=g:VGCreatDir
	let theDir=glob(dummyDir)
	execute "silent view ".theDir."/.dummyViewVimgrep"
endfunction

function! s:undoDummyView()
	let dummyDir=g:VGCreatDir
	let theDir=glob(dummyDir)
	let theDummyFile=theDir."/.dummyViewVimgrep"
	if bufexists(theDummyFile)
		execute "silent! bwipeout ".bufnr(theDummyFile)
	endif
	if glob(theDummyFile) != ''
		call delete(theDummyFile)
	endif
endfunction

function! s:validSrchPat(srchpat)
	if a:srchpat == ''
		VGMSG "empty srchpat",2
		return 0
	endif
	call s:doDummyView()
	try
		execute "silent /".a:srchpat
	catch
		let emsg=strpart(v:exception,match(v:exception,':E\d\+:')+2)
		let eNum=strpart(emsg,0,match(emsg,':'))
		silent! bwipeout
		if eNum != 385 && eNum != 486
			VGMSG "invalid srchpat\<NL>".emsg,2
			call s:undoDummyView()
			return 0
		else
			call s:undoDummyView()
			return 1
		endif
	endtry
	call s:undoDummyView()
	return 1
endfunction

function! s:isNonTextFile(file)
	let thisBuf=b:bufNo
	let holdHidden=&hidden
	set hidden
	if !buflisted(a:file)
		execute 'silent view '.a:file.' | let L2Bsize=line2byte(line("$")+1) | let GetFsize=getfsize(expand("%:p")) |	silent bwipeout'
		silent "b".thisBuf
		let &hidden=holdHidden
		if L2Bsize-GetFsize == 1
			return 0
		endif
		return 1
	endif
	return 0
endfunction

"Help:command  VimgrepEditDel deletes any edit buffers generated by VimgrepEdit
command! -nargs=0 VimgrepEditDel call s:DeleteVimgrepEdit()

function! s:DeleteVimgrepEdit()
	if !exists("g:VGEdtBufs")
		return
	endif
	let thisBufNo=StrListTok(g:VGEdtBufs,'g:VGEdtBufs',':')
	while thisBufNo != ''
		let delB='silent! b'.thisBufNo
		execute delB
		silent! bwipeout
		let thisBufNo=StrListTok('','g:VGEdtBufs')
	endwhile
	unlet! g:VGEdtBufs
endfunction

"Help:command  VimgrepHelpDel deletes any view buffers generated by VimgrepHelp
command! -nargs=0 VimgrepHelpDel call s:DeleteVimgrepHelp()

function! s:DeleteVimgrepHelp()
	if !exists("g:VGHlpBufs")
		return
	endif
	let thisBufNo=StrListTok(g:VGHlpBufs,'g:VGHlpBufs',':')
	while thisBufNo != ''
		let delB='silent! b'.thisBufNo
		execute delB
		silent! bwipeout
		let thisBufNo=StrListTok('','g:VGHlpBufs')
	endwhile
	unlet! g:VGHlpBufs
endfunction

function! s:createReadTmp()
	call s:createFile('.readtmp')
endfunction

function! s:deleteReadTmp()
	call s:deleteFile('.readtmp')
	let readTmpName=expand(g:VGCreatDir.'/.readtmp')
	let readTmpBufNr=bufnr(readTmpName)
	if readTmpBufNr != -1
		execute 'bwipeout '.readTmpBufNr
	endif
endfunction

function! s:createFile(fname)
	call s:deleteFile(a:fname)
	let tmpFile=g:VGCreatDir.'/'.a:fname
	let tmpFile=expand(tmpFile)
	execute 'silent! edit '.tmpFile
endfunction

function! s:deleteFile(fname)
	let tmpFile=g:VGCreatDir.'/'.a:fname
	let tmpName=glob(tmpFile)
	if tmpName != ''
		let failure=delete(tmpName)
		if failure
			VGMSG "Failed to delete existing <".tmpName.">",2
		endif
	endif
endfunction

function! s:comFuncHlp()
	let CFHBufName=expand(g:VGCreatDir.'/.vimgrepComFuncHlplist')
	if buflisted(CFHBufName)
		execute 'b'.bufnr(CFHBufName)
		return
	endif
	call s:createReadTmp()
	execute 'silent read '.s:thisFileQPath
	normal gg
	normal dd
	silent write
	let clnum=1
	let helpLines=''
	while clnum <= line('$')
		let thisLine=getline(clnum)
		if match(thisLine,'^"Help:') != -1
			let matchEnd=matchend(thisLine,'^"Help:')
			let helpLines=helpLines.strpart(thisLine,matchEnd)."\<NL>"
		endif
		let clnum=clnum+1
	endwhile
	call s:deleteReadTmp()
	call s:createFile('.vimgrepComFuncHlplist')
	let savez=@z
	let @z=helpLines
	normal gg
	silent normal "zP
	let @z=savez
	normal G
	normal dd
	call SortR(1,line('$'),'Strcmp')
	silent write
	setlocal readonly nomodifiable
endfunction

let s:depth=0

function! s:getDirFiles(thisFile,fileRef)
	let thisFile=glob(a:thisFile)
	let fpat=s:fpat
	let mpat=s:mpat
	let Ret=0
	if mpat != '' && match(thisFile,mpat) != -1
		return
	endif
	let theFiles=a:fileRef
	if isdirectory(thisFile)
		let trailChar=thisFile[strlen(thisFile)-1]
		if trailChar != '/' && trailChar != '\'
			let tmpFiles=glob(thisFile.'/*')
		else
			let tmpFiles=glob(thisFile.'*')
		endif
		if tmpFiles != ''
			let g:subFiles{s:depth}=tmpFiles
			let tmpFname{s:depth}="g:subFiles".s:depth
			let tmpFile{s:depth}=StrListTok(tmpFiles,tmpFname{s:depth})
			while tmpFile{s:depth} != ''
				let argFile=tmpFile{s:depth}
				if isdirectory(argFile) && s:doSubs
					let s:depth=s:depth+1
					call s:getDirFiles(argFile,a:fileRef)
					let s:depth=s:depth-1
				else
					if mpat != '' && match(argFile,mpat) != -1
						let tmpFile{s:depth}=StrListTok('',tmpFname{s:depth})
						continue
					endif
					if (fpat != '' && match(argFile,fpat) != -1) || fpat == ''
						let {theFiles}={theFiles}.argFile."\<NL>"
					endif
				endif
				let tmpFile{s:depth}=StrListTok('',tmpFname{s:depth})
			endwhile
			unlet g:subFiles{s:depth}
		endif
		return
	else
		let tmpFiles=glob(thisFile)
		if tmpFiles == ''
			return
		endif
		let g:subFiles{s:depth}=tmpFiles
		let tmpFname{s:depth}="g:subFiles".s:depth
		let tmpFile{s:depth}=StrListTok(tmpFiles,tmpFname{s:depth})
		while tmpFile{s:depth} != ''
			let argFile=tmpFile{s:depth}
			if isdirectory(argFile) && s:doSubs
				let s:depth=s:depth+1
				call s:getDirFiles(argFile,a:fileRef)
				let s:depth=s:depth-1
			else
				if mpat != '' && match(argFile,mpat) != -1
					let tmpFile{s:depth}=StrListTok('',tmpFname{s:depth})
					continue
				endif
				if (fpat != '' && match(argFile,fpat) != -1) || fpat == ''
					let {theFiles}={theFiles}.argFile."\<NL>"
				endif
			endif
			let tmpFile{s:depth}=StrListTok('',tmpFname{s:depth})
		endwhile
		unlet g:subFiles{s:depth}
		return
	endif
	VGMSG "Should not have gotten here!!!",2
	return
endfunction

let s:dirDepth=0

function! s:recurseForDirs(dir,refDirList)
	let theContents{s:dirDepth}=glob(a:dir.'/*')
	let bContents{s:dirDepth}='g:contents'.s:dirDepth
	let thisEntry{s:dirDepth}=StrListTok(theContents{s:dirDepth},bContents{s:dirDepth})
	while thisEntry{s:dirDepth} != ''
		let matchesMpat=0
		if s:mpat != ''
			if s:MC
				let matchesMpat=thisEntry{s:dirDepth} =~# s:mpat
			else
				let matchesMpat= thisEntry{s:dirDepth} =~? s:mpat
			endif
		endif
		if !matchesMpat
			if isdirectory(thisEntry{s:dirDepth})
				let {a:refDirList}={a:refDirList}.thisEntry{s:dirDepth}."\<NL>"
				let s:dirDepth=s:dirDepth+1
				call s:recurseForDirs(thisEntry{s:dirDepth-1},a:refDirList)
				let s:dirDepth=s:dirDepth-1
			endif
		endif
		let thisEntry{s:dirDepth}=StrListTok('',bContents{s:dirDepth})
	endwhile
	unlet! {bContents{s:dirDepth}}
endfunction

function! s:getVRBfname()
	if has("browse")
		let VRBfile=browse(1,'Vimgrep Result Buffer File',expand("%:p:h"),'VimgrepResultBuf.txt')
	else
		let thisDir=expand("%:p:h")
		let VRBfile=input("File Name to save results? ",thisDir.'/VimgrepResultBuf.txt')
		if !QualifiedPath(VRBfile)
			let VRBfile=thisDir.'/'.VRBfile
		endif
	endif
	return VRBfile
endfunction

function! s:createListFile(fname)
	let listFile=g:VGCreatDir.'/'.a:fname
	let listFileQPath=glob(listFile)
	if listFileQPath != ''
		let failure=delete(listFileQPath)
		if failure
			VGMSG " \<NL>Could not delete existing <".listFileQPath.">",2
		endif
	else
		let listFileQPath=fnamemodify(listFile,":p")
	endif
	let listFileQPath=expand(listFileQPath)
	return listFileQPath
endfunction

" strings to identify 'Pattern not found' return
" that won't be confused with normal return (hopefully!)
let s:PatNotFound=nr2char(16).nr2char(14).nr2char(6)."\<NL>"

"rqrd args: srchpat
" opt args: MC
"Help:command  VimgrepBufsToBuf srchpat[ -M]
command! -nargs=+ VimgrepBufsToBuf call BufsToBufVimgrep(<f-args>)

"Help:function BufsToBufVimgrep('srchpat'[,'-M'])
function! BufsToBufVimgrep(srchpat,...)
	let thisBufNr=bufnr('')
	b#
	let altBufNr=bufnr('')
	b#
	if thisBufNr == altBufNr && bufname('') == ''
		VGMSG "No buffers to search",1
		return ''
	endif
	if &modified
		VGMSG "current file has been modified - write before continuing",2
		return
	endif
	let VRBfile=s:getVRBfname()
	if VRBfile == ''
		VGMSG "Need file name for result buffer",2
		return
	endif
	let s:OrigBuf=b:bufNo
	let OrigLin=line('.')
	let OrigCol=col('.')
	let Ret=''
	SETOPTS
	bufdo let Ret=Ret.Vimgrep(a:srchpat,expand("%:p")) | let s:optsSet=1
	let s:optsSet=0
	execute "b".s:OrigBuf
	while Ret[0] == "\<NL>"
		let Ret=strpart(Ret,1)
	endwhile
	if Ret == ''
		VGMSG "No results for : ".a:srchpat,2
		execute 'b'.s:OrigBuf
		call cursor(OrigLin,OrigCol)
		return
	endif
	execute 'edit '.VRBfile
	let holdz=@z
	let @z=Ret
	normal "zP
	let @/=a:srchpat
	HILITE1st
	file
	let @z=holdz
endfunction

"rqrd args: srchpat
" opt args: MC
"Help:command  VimgrepBufs srchpat[ -M]
command! -nargs=+ VimgrepBufs call Pause(BufsVimgrep(<f-args>))

"Help:function BufsVimgrep('srchpat'[,'-M'])
function! BufsVimgrep(srchpat,...)
	let thisBufNr=bufnr('')
	b#
	let altBufNr=bufnr('')
	b#
	if thisBufNr == altBufNr && bufname('') == ''
		VGMSG "No buffers to search",1
		return ''
	endif
	let s:OrigBuf=b:bufNo
	let OrigLin=line('.')
	let OrigCol=col('.')
	let Ret=''
	SETOPTS
	bufdo let Ret=Ret.Vimgrep(a:srchpat,expand("%:p")) | let s:optsSet=1
	let s:optsSet=0
	execute 'b'.s:OrigBuf
	call cursor(OrigLin,OrigCol)
	return Ret
endfunction

"rqrd args: srchpat
" opt args: MC fpat mpat
"Help:command  VimgrepHelp srchpat[ -M][ -f <pat>][ -m <pat>]
command! -nargs=+ VimgrepHelp call HelpVimgrep(<f-args>)

"Help:function HelpVimgrep('srchpat'[,'-M'][,'-f','<pat>'][,'-m','<pat>'])
function! HelpVimgrep(srchpat,...)
	if &modified
		VGMSG "current file has been modified - write before continuing",2
		return
	endif
	if !exists("g:VGHlpBufs")
		let g:VGHlpBufs=':'
	endif
	let helpFiles=''
	let thePaths=g:VGHlpDirs
	let thisPath=StrListTok(thePaths,'g:runtimepathsVimgrep')
	while thisPath != ''
		let tmpFiles=glob(thisPath.'/doc/*.txt')
		if tmpFiles != ''
			let helpFiles=helpFiles.tmpFiles."\<NL>"
		endif
		let thisPath=StrListTok('','g:runtimepathsVimgrep')
	endwhile
	unlet g:runtimepathsVimgrep
	SETOPTS
	let s:FNonly=1
	let helpFiles=Vimgrep(a:srchpat,helpFiles)
	let thisFile=StrListTok(helpFiles,'g:helpListVimgrep')
	if thisFile == ''
		unlet! g:helpListVimgrep
		return
	endif
	if !s:MC | let mc='ignorecase' | else | let mc='noignorecase' | endif
	let @/=a:srchpat
	let tailCmd='setlocal iskeyword+='.g:VGHlpISK.' | '.
		\'setlocal '.mc.' | '.
		\"setlocal filetype=help | ".
		\"setlocal buftype=help | ".
		\"setlocal nomodifiable | ".
		\"let g:VGHlpBufs=g:VGHlpBufs.b:bufNo.':'"
	let startName=thisFile
	while thisFile != ''
		let editCmd="silent! view ".thisFile." | ".tailCmd
		execute editCmd
		HILITE1st
		b#
		let thisFile=StrListTok('','g:helpListVimgrep')
	endwhile
	let startBuf=bufnr(startName)
	execute ":b".startBuf
	HILITE1st
	file
	unlet! g:helpListVimgrep
endfunction

"rqrd args: srchpat
" opt args: MC fpat mpat
"Help:command  VimgrepHelpList srchpat[ -M][ -f <pat>][ -m <pat>]
command! -nargs=+ VimgrepHelpList call ListHelpVimgrep(<f-args>)

"Help:function ListHelpVimgrep('srchpat'[,'-M'][,'-f','<pat>'][,'-m','<pat>'])
function! ListHelpVimgrep(srchpat,...)
	if &modified
		VGMSG "current file has been modified - write before continuing",2
		return
	endif
	let helpFiles=''
	let thePaths=g:VGHlpDirs
	let thisPath=StrListTok(thePaths,'g:runtimepathsVimgrep')
	while thisPath != ''
		let tmpFiles=glob(thisPath.'/doc/*.txt')
		if tmpFiles != ''
			let helpFiles=helpFiles.tmpFiles."\<NL>"
		endif
		let thisPath=StrListTok('','g:runtimepathsVimgrep')
	endwhile
	unlet g:runtimepathsVimgrep
	SETOPTS
	let s:FNonly=1
	let helpFiles=Vimgrep(a:srchpat,helpFiles)
	while helpFiles[0] == "\<NL>"
		let helpFiles=strpart(helpFiles,1)
	endwhile
	if helpFiles == ''
		return
	endif
	let listFileQPath=s:createListFile('.helpfilelist')
	execute 'silent! bwipeout '.bufnr(listFileQPath)
	execute 'edit '.listFileQPath
	let saveWS=&wrapscan
	set wrapscan
	let savez=@z
	let @z=helpFiles
	normal "zP
	let @z=savez
	normal G
	normal dd
	execute ":w"
	map <buffer> o :execute ':help '.fnamemodify(getline('.'),":t")<CR>
	let @/=a:srchpat
	execute 'silent! /'.a:srchpat
	normal gg
	setlocal readonly
	setlocal nomodifiable
	let &wrapscan=saveWS
	file
endfunction

"Help:command  BuiltInHelp searches 'eval.txt' for Vim builtins
command! BuiltInHelp call s:builtinHlp()
function! s:builtinHlp()
	if &modified
		VGMSG "current file has been modified - write before continuing",2
		return
	endif
	" lines beginning with the name of a function, a vim variable, or a command
	let l:srchpat='^\(\h\w*(\|v:\h\w*\|:\h\w*\)'
	let builtIns=Vimgrep(l:srchpat,$VIMRUNTIME.'/doc/eval.txt')
	while builtIns[0] == "\<NL>"
		let builtIns=strpart(builtIns,1)
	endwhile
	let thisBI=StrListTok(builtIns,'g:builtInHlp',"\<NL>")
	" dump the label for this Vimgrep
	if match(thisBI,'\<eval\.txt\>: $') != -1
		let thisBI=StrListTok('','g:builtInHlp')
	endif
	let builtIns=''
	" strip off line numbers from Vimgrep
	while thisBI != ''
		let BIname=matchend(thisBI,'^\d\+:')
		let builtIns=builtIns.strpart(thisBI,BIname)."\<NL>"
		let thisBI=StrListTok('','g:builtInHlp')
	endwhile
	unlet g:builtInHlp
	let listFileQPath=s:createListFile('.builtinlist')
	execute 'silent! bwipeout '.bufnr(listFileQPath)
	execute 'edit '.listFileQPath
	let savez=@z
	let @z=builtIns
	normal "zP
	let @z=savez
	normal G
	normal dd
	call SortR(1,line('$'),'Strcmp')
	call Uniq(1,line('$'))
	execute ":w"
	let @/=l:srchpat
	execute 'silent /'.l:srchpat
	HILITE1st
	execute 'setlocal iskeyword+='.g:VGHlpISK
	setlocal filetype=help
	setlocal buftype=help
	setlocal readonly
	setlocal nomodifiable
	file
endfunction

"rqrd args: srchpat file
" opt args: MC doSubs fpat mpat
"Help:command  VimgrepEdit srchpat file[ -M][ -d][ -f <pat>][ -m <pat>]
command! -nargs=* VimgrepEdit call EditVimgrep(<f-args>)

"Help:function EditVimgrep('srchpat','file'[,'-M'][,'-d'][,'-f','<pat>'][,'-m','<pat>'])
function! EditVimgrep(srchpat,file,...)
	if &modified
		VGMSG "current file has been modified - write before continuing",2
		return
	endif
	if !exists("g:VGEdtBufs")
		let g:VGEdtBufs=':'
	endif
	SETOPTS
	let s:FNonly=1
	let editFiles=Vimgrep(a:srchpat,a:file)
	let g:editListVimgrep=''
	let thisFile=StrListTok(editFiles,'g:editListVimgrep')
	if thisFile == ''
		unlet! g:editListVimgrep
		return
	endif
	if !s:MC | let mc='ignorecase' | else | let mc='noignorecase' | endif
	let @/=a:srchpat
	let tailCmd=
		\'setlocal '.mc.' | '.
		\"let g:VGEdtBufs=g:VGEdtBufs.b:bufNo.':'"
	let startName=thisFile
	while thisFile != ''
		if !buflisted(thisFile)
			let itsPath=fnamemodify(thisFile,":p:h")
			let itsName=fnamemodify(thisFile,":t")
			let itsSwap=itsPath.'/.'.itsName.'.swp'
			let itsSwap=glob(itsSwap)
			if itsSwap == ''
				let editCmd="edit ".thisFile." | ".tailCmd
			else
				let editCmd="view ".thisFile." | setlocal nomodifiable | ".tailCmd
			endif
			execute "silent! ".editCmd
			HILITE1st
		endif
		let thisFile=StrListTok('','g:editListVimgrep')
	endwhile
	let startBuf=bufnr(startName)
	let goHome='silent b'.startBuf
	execute goHome
	HILITE1st
	file
	unlet! g:editListVimgrep
endfunction

" Thanks to Hari Krishna Dara for the idea for this one
"rqrd args: file fpat
" opt args: MC doSubs mpat
"Help:command  Vimfind file fpat[ -M][ -d][ -m <pat>]
command! -nargs=* Vimfind call Pause(Vimfind(<f-args>))

"Help:function Vimfind('file','fpat'[,'-M'][,'-d'][,'-m','<pat>'])
function! Vimfind(file,fpat,...)
	if !s:validSrchPat(a:fpat)
		return ''
	endif
	let fpat=a:fpat
	if fpat == '""' || fpat == "''"
		let fpat=''
	endif
	SETOPTS
	if fpat != ''
		if fpat[0] == '\'
			if fpat[1] != 'C' && fpat[1] != 'c'
				if s:MC | let fpat='\C'.fpat | else | let fpat='\c'.fpat | endif
			endif
		else
			if s:MC | let fpat='\C'.fpat | else | let fpat='\c'.fpat | endif
		endif
	endif
	let s:fpat=fpat
	let s:FNonly=1
	return Vimgrep('\%$',a:file)
endfunction

"rqrd args: file fpat
" opt args: MC doSubs mpat
"Help:command  VimfindToBuf file fpat[ -M][ -d][ -m <pat>]
command! -nargs=* VimfindToBuf call ToBufVimfind(<f-args>)

"Help:function ToBufVimfind('file','fpat'[,'-M'][,'-d'][,'-m','<pat>'])
function! ToBufVimfind(file,fpat,...)
	if &modified
		VGMSG "current file has been modified - write before continuing",2
		return
	endif
	if !s:validSrchPat(a:fpat)
		return ''
	endif
	let VRBfile=s:getVRBfname()
	if VRBfile == ''
		VGMSG "Need file name for result buffer",2
		return
	endif
	SETOPTS
	let Ret=Vimfind(a:file,a:fpat)
	let holdz=@z
	let @z=Ret
	execute 'edit '.VRBfile
	normal "zP
	let @z=holdz
	let @/=a:fpat
	HILITE1st
endfunction

"rqrd args: srchpat file
" opt args: MC doSubs fpat mpat
"Help:command  VimgrepList srchpat file[ -M][ -d][ -f <pat>][ -m <pat>]
command! -nargs=* VimgrepList call ListVimgrep(<f-args>)

"Help:function ListVimgrep('srchpat','file'[,'-M'][,'-d'][,'-f','<pat>'][,'-m','<pat>'])
function! ListVimgrep(srchpat,file,...)
	SETOPTS
	let s:FNonly=1
	let Ret=Vimgrep(a:srchpat,a:file)
	let lastCharIndx=strlen(Ret)-1
	while lastCharIndx == "\<NL>"
		let Ret=strpart(Ret,0,lastCharIndx-1)
		let lastCharIndx=strlen(Ret)-1
	endwhile
	while Ret[0] == "\<NL>"
		let Ret=strpart(Ret,1)
	endwhile
	let listFileQPath=s:createListFile('.vimgreplist')
	execute 'silent! bwipeout '.bufnr(listFileQPath)
	execute 'edit '.listFileQPath
	let holdz=@z
	let @z=Ret
	if s:MC == 1
		setlocal noignorecase
	else
		setlocal ignorecase
	endif
	normal "zP
	let @z=holdz
	normal G
	normal dd
	normal gg
	execute ':w'
	map <buffer> o :execute 'edit '.getline('.')<CR>
	setlocal readonly
	setlocal nomodifiable
	let @/=a:srchpat
	silent! normal n
endfunction

"rqrd args: file fpat
" opt args: MC doSubs mpat
"Help:command  VimfindList file fpat[ -M][ -d][ -m <pat>]
command! -nargs=* VimfindList call ListVimfind(<f-args>)

"Help:function ListVimfind('file','fpat'[,'-M'][,'-d'][,'-m','<pat>'])
function! ListVimfind(file,fpat,...)
	SETOPTS
	let Ret=Vimfind(a:file,a:fpat)
	let listFileQPath=s:createListFile('.vimfindlist')
	execute 'silent! bwipeout '.bufnr(listFileQPath)
	execute 'edit '.listFileQPath
	let holdz=@z
	let @z=Ret
	if s:MC == 1
		setlocal noignorecase
	else
		setlocal ignorecase
	endif
	normal "zP
	normal G
	normal dd
	let @z=holdz
	let @/=a:fpat
	HILITE1st
	normal gg
	silent! :w
	map <buffer> o :execute 'edit '.getline('.')<CR>
	setlocal readonly
	setlocal nomodifiable
endfunction

"rqrd args: file fpat
" opt args: MC doSubs mpat
"Help:command  VimfindEdit file fpat[ -M][ -d][ -m <pat>]
command! -nargs=* VimfindEdit call EditVimfind(<f-args>)

"Help:function EditVimfind('file','fpat'[,'-M'][,'-d'][,'-m','<pat>'])
function! EditVimfind(file,fpat,...)
	if !exists("g:VGEdtBufs")
		let g:VGEdtBufs=':'
	endif
	SETOPTS
	let editFiles=Vimfind(a:file,a:fpat)
	let g:editListVimgrep=''
	let thisFile=StrListTok(editFiles,'g:editListVimgrep')
	if thisFile == ''
		unlet! g:editListVimgrep
		return
	endif
	if !s:MC | let mc='ignorecase' | else | let mc='noignorecase' | endif
	let tailCmd=
		\'setlocal '.mc.' | '.
		\"let g:VGEdtBufs=g:VGEdtBufs.b:bufNo.':'"
	let startName=thisFile
	while thisFile != ''
		if !buflisted(thisFile)
			let itsPath=fnamemodify(thisFile,":p:h")
			let itsName=fnamemodify(thisFile,":t")
			let itsSwap=itsPath.'/.'.itsName.'.swp'
			let itsSwap=glob(itsSwap)
			if itsSwap == ''
				let editCmd="edit ".thisFile." | ".tailCmd
			else
				let editCmd="view ".thisFile." | setlocal nomodifiable | ".tailCmd
			endif
			execute "silent! ".editCmd
		endif
		let thisFile=StrListTok('','g:editListVimgrep')
	endwhile
	let startBuf=bufnr(startName)
	let goHome='silent b'.startBuf
	execute goHome
	file
	unlet! g:editListVimgrep
endfunction

"rqrd args: srchpat file
" opt args: MC FNonly terse doSubs fpat mpat
"Help:command  VimgrepToBuf srchpat file[ -M][ -F][ -t][ -d][ -f <pat>][ -m <pat>]
command! -nargs=* VimgrepToBuf call ToBufVimgrep(<f-args>)

"Help:function ToBufVimgrep('srchpat','file'[,'-M'][,'-F'][,'-t'][,'-d'][,'-f','<pat>'][,'-m','<pat>'])
function! ToBufVimgrep(srchpat,file,...)
	if &modified
		VGMSG "current file has been modified - write before continuing",2
		return
	endif
	let VRBfile=s:getVRBfname()
	if VRBfile == ''
		VGMSG "Need file name for result buffer",2
		return
	endif
	SETOPTS
	let holdz=@z
	let @z=Vimgrep(a:srchpat,a:file)
	while @z[0] == "\<NL>"
		let @z=strpart(@z,1)
	endwhile
	if @z == ''
		VGMSG "No results for : ".a:srchpat,2
		let @z=holdz
		return
	endif
	let @/=a:srchpat
	execute 'edit '.VRBfile
	normal "zP
	file
	HILITE1st
	let @z=holdz
endfunction

"rqrd args: srchpat file
" opt args: MC FNonly terse doSubs fpat mpat
"Help:command  Vimgrep srchpat file[ -M][ -F][ -t][ -d][ -f <pat>][ -m <pat>]
command! -nargs=* Vimgrep call Pause(Vimgrep(<f-args>))

"Help:function Vimgrep('srchpat','file'[,'-M'][,'-F'][,'-t'][,'-d'][,'-f','<pat>'][,'-m','<pat>'])
function! Vimgrep(srchpat,file,...)
	SETOPTS
	let s:optsSet=0
	if !s:validSrchPat(a:srchpat)
		return ''
	endif
	let aFile=a:file
	if aFile == '%' || aFile == '' || aFile == "''" || aFile == '""' || aFile == '.'
		if s:doSubs || s:fpat != '' || s:mpat != ''
			let aFile=expand("%:p:h")
		else
			let aFile=expand("%:p")
		endif
	endif
	if aFile == '*'
		let aFile=g:VGDirs
	endif
	let g:theArgList=''
	let theArg=StrListTok(aFile,'g:theArgs')
	VGMSG " ".
			\"\<NL>  Search Pattern: ".a:srchpat.
			\"\<NL>  s:MC=".s:MC." s:FNonly=".s:FNonly." s:terse=".s:terse." s:doSubs=".s:doSubs.
			\"\<NL>  s:fpat: ".s:fpat.
			\"\<NL>  s:mpat: ".s:mpat
	while theArg != ''
		let tmpArg=theArg
		let theArg=glob(tmpArg)
		if theArg == ''
			try
				execute 'let theArg=expand('.tmpArg.')'
			catch
				let theArg=''
			endtry
			if theArg == ''
				try
					execute 'let theArg=expand("'.{tmpArg}.'")'
				catch
					let theArg=''
				endtry
			endif
		endif
		VGMSG "theArg=".theArg
		if !QualifiedPath(theArg)
			let theArg=''
			let g:dfltDirs=g:VGDirs
			if s:doSubs
				let g:allSubs=''
				let dfltDir=StrListTok(g:dfltDirs,'g:dfltDirs')
				while dfltDir != ''
					call s:recurseForDirs(dfltDir,'g:allSubs')
					let dfltDir=StrListTok('','g:dfltDirs')
				endwhile
				let g:dfltDirs=g:VGDirs
				if g:allSubs != ''
					let g:dfltDirs=g:dfltDirs.','.g:allSubs
				endif
				unlet g:allSubs
			endif
			let dfltDir=StrListTok(g:dfltDirs,'g:dfltDirs')
			while dfltDir != ''
				let thisResult=glob(dfltDir.'/'.tmpArg)
				if thisResult != ''
					let theArg=theArg.thisResult."\<NL>"
				endif
				let dfltDir=StrListTok('','g:dfltDirs')
			endwhile
			unlet g:dfltDirs
		endif
		if theArg == ''
			VGMSG "Could not resolve file argument: ".tmpArg,1
		else
			let g:theArgList=g:theArgList.theArg."\<NL>"
		endif
		let theArg=StrListTok('','g:theArgs')
	endwhile
	VGMSG "g:theArgList:\<NL>".g:theArgList
	if g:theArgList == ''
		VGMSG "No arguments to process from file argument: ".aFile,2
		return ''
	endif
	let Ret="\<NL>"
	let g:fileListVimgrep=''
	let thisFile=StrListTok(g:theArgList,'g:theArgList')
	while thisFile != ''
		VGMSG " ".
		\"\<NL>  Getting Files from:".
		\"\<NL>    ".thisFile.
		\"\<NL>  That match the pattern: ".s:fpat.
		\"\<NL>  And don't match the pattern:".s:mpat.
		\"\<NL>  Doing subdirectories=".s:doSubs
		call s:getDirFiles(thisFile,'g:fileListVimgrep')
		let thisFile=StrListTok('','g:theArgList')
	endwhile
	VGMSG "g:fileListVimgrep:\<NL>".g:fileListVimgrep
	if g:fileListVimgrep == ''
		VGMSG "No files found from file argument: ".a:file,2
		unlet g:fileListVimgrep
		return ''
	endif
	if a:srchpat == '\%$' && s:FNonly
		let Ret=g:fileListVimgrep
		unlet g:fileListVimgrep
		VGMSG "Returning\<NL>".Ret
		return Ret
	endif
	let thisFile=StrListTok(g:fileListVimgrep,'g:fileListVimgrep')
	while thisFile != ''
		if isdirectory(thisFile)
			if !s:terse
				let Ret=Ret."Vimgrep: ".thisFile.": Directory\<NL>"
			endif
			let thisFile=StrListTok('','g:fileListVimgrep')
			continue
		endif
		if s:isNonTextFile(thisFile)
			if !s:terse
				let Ret=Ret."Vimgrep: ".thisFile.": Non Text\<NL>"
			endif
			let thisFile=StrListTok('','g:fileListVimgrep')
			continue
		endif
		if !buflisted(thisFile)
			let isEmptyCmd='silent! view '.thisFile.' | '.
				\'let zBytes=line2byte(line("$")) | let lBytes=strlen(getline(1)) | silent! bwipeout'
			execute isEmptyCmd
			let emptyFile=zBytes == -1 || (zBytes == 1 && lBytes == 0)
			if emptyFile
				if !s:terse
					let Ret=Ret."Vimgrep: ".thisFile.": Empty File\<NL>"
				endif
				let thisFile=StrListTok('','g:fileListVimgrep')
				continue
			endif
		endif
		silent let theResult=s:vimGrep(a:srchpat,thisFile)
		if (s:FNonly && theResult == "\<NL>") || !s:FNonly
			if !s:terse
				if theResult == s:PatNotFound
					let Ret=Ret."Vimgrep: ".thisFile.": Pattern not found : ".a:srchpat."\<NL>"
				else
					if s:FNonly
						let Ret=Ret.thisFile.theResult
					else
						let Ret=Ret.thisFile.": ".theResult
					endif
				endif
			elseif theResult != s:PatNotFound
				if s:FNonly
					let Ret=Ret.thisFile.theResult
				else
					let Ret=Ret.thisFile.": ".theResult
				endif
			endif
		endif
		let thisFile=StrListTok('','g:fileListVimgrep')
	endwhile
	unlet! g:fileListVimgrep
	VGMSG "Returning\<NL>".Ret
	return Ret
endfunction

function! s:vimGrep(srchpat,file)
	let origlin=line('.')
	let origcol=col('.')
	let NL="\<NL>"
	let Ret=NL
	let bufIsListed=buflisted(a:file)
	if !bufIsListed
		try
			execute 'silent :view +set\ nobuflisted\ noswapfile\ hidden '.a:file
		catch
			let Ret=Ret.s:thisScript."::".expand("<sfile>").": Could not open ".a:file." for searching".NL
			let Ret=Ret.v:errmsg.NL
			return Ret
		endtry
	else
		execute "b".bufnr(a:file)
	endif
	let thePat=a:srchpat
	if !s:MC
		let thePat=thePat.'\c'
	endif
	" Note: first line has to be checked independently as the search pattern may
	"       match line 1, col 1 and normal matches start with the first
	"       character _after_ the cursor.
	let cline=getline(1)
	if match(cline,thePat) != -1 
		if s:FNonly
			if !bufIsListed
				silent! bwipeout
			endif
			call cursor(origlin,origcol)
			return NL
		else
			let Ret=Ret.'1:'.cline.NL
		endif
	endif
	call cursor(1,col('$'))
	let slnr=search(thePat,'W')
	if slnr
		if s:FNonly
			if !bufIsListed
				silent! bwipeout
			endif
			call cursor(origlin,origcol)
			return NL
		endif
		while slnr
			let Ret=Ret.slnr.':'.getline(slnr).NL
			let slnr=search(thePat,'W')
		endwhile
	endif
	if !bufIsListed
		silent! bwipeout
	endif
	call cursor(origlin,origcol)
	if Ret == NL || match(Ret,'^\s*$') != -1
		return s:PatNotFound
	endif
	return Ret
endfunction

"Help:            Command/Function Help for Vimgrep/Vimfind
"Help:           *******************************************
"Help:    'ToBuf' generate output to a named buffer
"Help:    'List'  generate output to a listing buffer for selection using 'o'
"Help:    -------------------------------------------------------------------
