if exists('g:loaded_iawriter_plugin')
	finish
endif
let g:loaded_iawriter_plugin = 1
let s:vim_iawriter_enabled = 0
fun! vim_iawriter#check_configs()
	let s:saved_colorscheme = 'default'
	if exists('g:colors_name')
		let s:saved_colorscheme = g:colors_name
	endif
	let s:saved_scrolloff = &scrolloff
	if !exists('g:goyo_width')
		let g:goyo_width = '70%'
	endif
	if !exists('g:limelight_paragraph_span')
		let g:limelight_paragraph_span = 0
	endif
	if !exists('g:limelight_default_coefficient')
		let g:limelight_default_coefficient = 0.7
	endif

	if !exists('g:iawriter_change_underline')
		let g:iawriter_change_underline = 1
	endif
	if !exists('g:iawriter_change_cursorline')
		let g:iawriter_change_cursorline = 1
	endif
	if !exists('g:iawriter_center_cursor')
		let g:iawriter_center_cursor = 0
	endif
endfun

fun! vim_iawriter#pre_enter()
	if exists('#goyo')
		Goyo!
	endif
	let s:airline_exists = 0
	if exists('#airline') && &statusline =~ 'airline'
		" For some reason, airline needs THREE toggles to turn completely off
		AirlineToggle
		AirlineToggle
		AirlineToggle
		let s:airline_exists = 1
	endif
	augroup iawriter_enter
		au!
		au User GoyoEnter nested ++once call vim_iawriter#post_enter()
		au User GoyoEnter nested ++once call <SID>iawriter_enter()
	augroup end
	call vim_iawriter#check_configs()
	colo pencil
endfun

fun! vim_iawriter#post_enter()
	Limelight
	augroup iawriter_leave
		au!
		au User GoyoLeave nested ++once call vim_iawriter#leave()
		au User GoyoLeave nested ++once call <SID>iawriter_leave()
	augroup end
	if g:iawriter_change_cursorline
		set nocursorline
	endif
	if g:iawriter_change_underline
		hi CursorLine gui=NONE
	endif
	if g:iawriter_center_cursor
		set scrolloff=9999
	endif
	augroup iawriter_silent_cmdline
		au!
		autocmd CmdlineLeave : echo ''
	augroup end
	let s:vim_iawriter_enabled = 1
	mode
	redraw
endfun

fun! vim_iawriter#leave()
	Limelight!
	execute('colo ' . s:saved_colorscheme)
	execute('set scrolloff=' . s:saved_scrolloff)
	augroup iawriter_silent_cmdline
		au!
	augroup end
	if s:airline_exists
		AirlineToggle
		AirlineRefresh
	endif
endfun

fun! vim_iawriter#toggle()
	if exists('#goyo') && s:vim_iawriter_enabled
		Goyo!
	else
		call vim_iawriter#pre_enter()
		Goyo
	endif
endfun

" Close vim when only window open is iAwriter
" Taken from https://github.com/junegunn/goyo.vim/wiki/Customization#ensure-q-to-quit-even-when-goyo-is-active
function! s:iawriter_enter()
	let b:quitting = 0
	let b:quitting_bang = 0
	augroup iawriter_only_window
		au!
		autocmd QuitPre <buffer> let b:quitting = 1
	augroup end
	cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
endfunction

function! s:iawriter_leave()
	" Quit Vim if this is the only remaining buffer
	if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
		if b:quitting_bang
			qa!
		else
			qa
		endif
	endif
endfunction

command! Iawriter call vim_iawriter#toggle()
