
" Short description of keys definitions (Command mode only):


" TAB			- indent current block of code
" SPACE			- fold / unfold current func
" Control + n 		- toggles Lines numbering ON / OFF (see 'nums' variable below)
" Control + DOWN	- jump to next function 
" Control + UP		- jump to prev function
" Control + RIGHT	- jump to the end of line
" Control + LEFT	- jump to the beginning of line
" ALT + RIGHT		- jump to a keyword definition (if tag file exists)
" ALT + LEFT		- jump back from a keyword definition (if tag file exists)
" Control + a		- add line to default buffer ( I mean @" ) without deleting its content
" Control + f		- clean default buffer @"

" Is Lines numbering is ON / OFF?
" 1 - ON by default
" 0 - OFF by defailt
let nums = 0


" TAB - indent current block of code / function
nnoremap <TAB> =i}

" Sometimes I need to copy multiple lines from different places of code.
" I want to gather thes  lines and later to paste it where I need it.
" This function intended to to this:
" Add line into default buffer 
function! CopyLineIntoBuf()
	" Count bumber of lines in @" buffer
	let lines=len(split(@", '\n'))

	" Insert \n into buffer
	call setreg('"',"\n", 'A')
	" Copy current line into fuffer
	call setreg('"', getline('.') ,'A')
	
	" Show how many lines in the buffer
	if lines == 0
		echo "Copied first line"
	else
		echo "Lines in register:" len(split(@", '\n'))
	endif
	return 0
endfunction

function! CleanDefaultBuffer()
	call setreg('"', [])
	echo "Cleaned buffer, you may start Ctrl + a"
endfunction

" Map Ctr + a to line adding function
nnoremap <C-a> :call CopyLineIntoBuf()<CR>
" Clean default buffer @" (need it before Ctrl + a 
"nnoremap <C-f> :call setreg('"', [])<CR> call echo "Cleaned buffer"
nnoremap <C-f> :call CleanDefaultBuffer()<CR>

" Control + DOWN key - jump to the next function
map <C-down> ]]
" Control + UP key - jump to the prev function
map <C-up> [[
" Control + RIGHT - jump to the end of line
map <C-right> W
" Control + LEFT - jump to the beginning of the line
map <C-left> b

" Alt + RIGHT key - jump to keyword definition (tag)
nnoremap <A-right> <C-]>
" Alt + LEFT key - jump back from the keyword (tag)
nnoremap <A-left> <C-t>

" SPACE in command - fold / unfold current function 
set foldmethod=syntax
set foldlevel=0

" Fold the whole function
nnoremap <space> zA
" Fold only current block
nnoremap <C-o> za

" Highligh the search result (also when you use Ctrl + * or Ctrl + #
set hlsearch
" Remove highliting of the search results
nnoremap <F3> :set hlsearch!<CR>

" Save and restore the state of the window
au BufWinLeave * mkview
au BufWinEnter * silent loadview

" Always show at least 3 lines below the cusrsor
:set scrolloff=3
:set laststatus=2

" =============== Lines numbereng ON / OFF support ================

" This function toggles Lines numbering ON / OFF
" Called it on start with var == 1
" Called by user with var == 0
function! LineNums(var)
   " If arg == 1 it called on vim start
   " In this case we do not toggle the 'nums' variable, only set Lines numbering
   if a:var == 1
      if g:nums == 1
        set number
      else
        set nonumber
      endif
   return 0
   endif

   " Else if arg != 1 it called by user

   if g:nums == 0
      let g:nums = 1
      set number
   else
      let g:nums = 0
      set nonumber
   endif
endfunction


" Control + n toggles Lines numbering ON / OFF
nnoremap <C-n> :call LineNums('0')<CR>

" Set Lines numbering on / off according to 'nums' variable
autocmd VimEnter * :call LineNums(1)
