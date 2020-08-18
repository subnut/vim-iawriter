if exists('g:loaded_iawriter_plugin')
	finish
endif
let g:loaded_iawriter_plugin = 1
let s:vim_iawriter_enabled = 0
fun! vim_iawriter#check_configs()
	" Non-config, basic checks n' saves
	" ---------------------------------
	let s:saved_colorscheme = 'default'
	if exists('g:colors_name')
		let s:saved_colorscheme = g:colors_name
	endif
	let s:saved_scrolloff = &scrolloff
	let s:saved_signcolumn= &signcolumn

	" Overrides
	" ---------
	if exists('g:iawriter_goyo_width')
		if exists('g:goyo_width')
			let s:saved_goyo_width = g:goyo_width
		endif
		let g:goyo_width = g:iawriter_goyo_width
	endif
	if exists('g:iawriter_goyo_height')
		if exists('g:goyo_height')
			let s:saved_goyo_height = g:goyo_height
		endif
		let g:goyo_height = g:iawriter_goyo_height
	endif
	if exists('g:iawriter_goyo_linenr')
		if exists('g:goyo_linenr')
			let s:saved_goyo_linenr = g:goyo_linenr
		endif
		let g:goyo_linenr = g:iawriter_goyo_linenr
	endif
	if exists('g:iawriter_limelight_coefficient')
		if exists('g:limelight_coefficient')
			let s:saved_limelight_coefficient = g:limelight_coefficient
		endif
		let g:limelight_coefficient = g:iawriter_limelight_coefficient
	endif
	if exists('g:iawriter_limelight_paragraph_span')
		if exists('g:limelight_paragraph_span')
			let s:saved_limelight_paragraph_span = g:limelight_paragraph_span
		endif
		let g:limelight_paragraph_span = g:iawriter_limelight_paragraph_span
	endif

	" Default config
	" -----------------------------
	if !exists('g:iawriter_force_defaults')
		let g:iawriter_force_defaults = 0
	endif
	if g:iawriter_force_defaults
		let g:goyo_width = '70%'
		let g:goyo_height = '85%'
		let g:limelight_paragraph_span = 0
		let g:limelight_default_coefficient = 0.7
		let g:iawriter_change_underline = 1
		let g:iawriter_change_cursorline = 1
		let g:iawriter_center_cursor = 0
		let g:iawriter_show_signcolumn = 0
		return
	endif
	if !exists('g:goyo_width')
		let g:goyo_width = '70%'
	endif
	if !exists('g:goyo_height')
		let g:goyo_height = '85%'
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
	if !exists('g:iawriter_show_signcolumn')
		let g:iawriter_show_signcolumn = 0
	endif
endfun

fun! vim_iawriter#pre_enter()
	doautocmd <nomodeline> User IawriterPrePreEnter
	if exists('#goyo')
		Goyo!
	endif
	let s:airline_exists = 0
	if exists('#airline') && &statusline =~? 'airline'	" ? = case-insensitive	# = case-sensitive
		set eventignore+=FocusGained
		let s:airline_exists = 1
	endif
	augroup iawriter_enter
		au!
		au User GoyoEnter nested ++once call vim_iawriter#post_enter()
		au User GoyoEnter nested ++once call <SID>iawriter_enter()
	augroup end
	call vim_iawriter#check_configs()
	colo pencil
	doautocmd <nomodeline> User IawriterPostPreEnter
endfun

fun! vim_iawriter#post_enter()
	doautocmd <nomodeline> User IawriterPrePostEnter
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
	if !g:iawriter_show_signcolumn
		set signcolumn=no
	endif
	augroup iawriter_silent_cmdline
		au!
		autocmd CmdlineLeave : echo ''
	augroup end
	let s:vim_iawriter_enabled = 1
	mode
	redraw
	doautocmd <nomodeline> User IawriterPostPostEnter
endfun

fun! vim_iawriter#leave()
	doautocmd <nomodeline> User IawriterPreLeave
	Limelight!
	execute('colo ' . s:saved_colorscheme)
	execute('set scrolloff=' . s:saved_scrolloff)
	execute('set signcolumn=' . s:saved_signcolumn)
	augroup iawriter_silent_cmdline
		au!
	augroup end
	if s:airline_exists
		set eventignore-=FocusGained
	endif
	silent! unlet g:goyo_width
	if exists('s:saved_goyo_width')
		let g:goyo_width = s:saved_goyo_width
	endif
	silent! unlet g:goyo_height
	if exists('s:saved_goyo_height')
		let g:goyo_height = s:saved_goyo_height
	endif
	silent! unlet g:goyo_linenr
	if exists('s:saved_goyo_linenr')
		let g:goyo_linenr = s:saved_goyo_linenr
	endif
	silent! unlet g:limelight_coefficient
	if exists('s:saved_limelight_coefficient')
		let g:limelight_coefficient = s:saved_limelight_coefficient
	endif
	silent! unlet g:limelight_paragraph_span
	if exists('s:saved_limelight_paragraph_span')
		let g:limelight_paragraph_span = s:saved_limelight_paragraph_span
	endif
	doautocmd <nomodeline> User IawriterPostLeave
endfun

fun! vim_iawriter#toggle()
	doautocmd <nomodeline> User IawriterToggleTriggered
	if exists('#goyo') && s:vim_iawriter_enabled
		Goyo!
	else
		call vim_iawriter#pre_enter()
		Goyo
	endif
	doautocmd <nomodeline> User IawriterToggleFinished
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
