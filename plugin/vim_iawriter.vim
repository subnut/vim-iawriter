if exists('g:loaded_iawriter_plugin')
	finish
endif
let g:loaded_iawriter_plugin = 1

fun! vim_iawriter#check_configs()
	let s:saved_colorscheme = "default"
	if exists('g:colors_name')
		let s:saved_colorscheme = g:colors_name
	endif
	let s:saved_scrolloff = &scrolloff
	if !exists('g:goyo_width')
		let g:goyo_width = '70%'
	endif
	if !exists('g:limelight_paragraph_span')
		let g:limelight_paragraph_span = 1
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
		let g:iawriter_center_cursor = 1
	endif
endfun!

fun! vim_iawriter#pre_enter()
	if exists('#goyo')
		Goyo!
	endif
	au User GoyoEnter nested ++once call vim_iawriter#post_enter()
	call vim_iawriter#check_configs()
	colo pencil
	AirlineToggle
endfun!

fun! vim_iawriter#post_enter()
	let g:limelight_paragraph_span = 1
	Limelight
	au User GoyoLeave nested ++once call vim_iawriter#leave()
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
	mode
endfun!

fun! vim_iawriter#leave()
	Limelight!
	AirlineToggle
	execute('colo ' . s:saved_colorscheme)
	AirlineRefresh
	execute('set scrolloff=' . s:saved_scrolloff)
	augroup iawriter_silent_cmdline
		au!
	augroup end
endfun!

fun! vim_iawriter#toggle()
	if exists('#goyo')
		Goyo!
	else
		call vim_iawriter#pre_enter()
		Goyo
	endif
endfun!
