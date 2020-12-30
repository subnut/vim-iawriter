if exists('g:loaded_iawriter_plugin')	" {{{1
	finish
endif	" }}}

let g:loaded_iawriter_plugin = 1
let s:vim_iawriter_enabled = 0

fun! s:check_configs()	" {{{1
	" Non-config, basic checks n' saves
	" ---------------------------------
	let s:saved_colorscheme = 'default'
	if exists('g:colors_name')	" {{{2
		let s:saved_colorscheme = g:colors_name
	endif	" }}}
	let s:saved_scrolloff = &scrolloff
	let s:saved_signcolumn= &signcolumn
	if exists('g:airline_theme')	" {{{2
		let s:saved_airline_theme = g:airline_theme
	endif	" }}}

	" Overrides
	" ---------
	if exists('g:iawriter_goyo_width')	"{{{2
		if exists('g:goyo_width')
			let s:saved_goyo_width = g:goyo_width
		endif
		let g:goyo_width = g:iawriter_goyo_width
	endif
	if exists('g:iawriter_goyo_height')	"{{{2
		if exists('g:goyo_height')
			let s:saved_goyo_height = g:goyo_height
		endif
		let g:goyo_height = g:iawriter_goyo_height
	endif
	if exists('g:iawriter_goyo_linenr')	"{{{2
		if exists('g:goyo_linenr')
			let s:saved_goyo_linenr = g:goyo_linenr
		endif
		let g:goyo_linenr = g:iawriter_goyo_linenr
	endif
	if exists('g:iawriter_limelight_default_coefficient')	"{{{2
		if exists('g:limelight_default_coefficient')
			let s:saved_limelight_default_coefficient = g:limelight_default_coefficient
		endif
		let g:limelight_default_coefficient = g:iawriter_limelight_default_coefficient
	endif
	if exists('g:iawriter_limelight_paragraph_span')	"{{{2
		if exists('g:limelight_paragraph_span')
			let s:saved_limelight_paragraph_span = g:limelight_paragraph_span
		endif
		let g:limelight_paragraph_span = g:iawriter_limelight_paragraph_span
	endif	" }}}

	" Default config
	" -----------------------------
	if !exists('g:iawriter_force_defaults')	"{{{2
		let g:iawriter_force_defaults = 0
	endif
	if g:iawriter_force_defaults	"{{{2
		let g:goyo_width = '70%'
		let g:goyo_height = '85%'
		let g:limelight_paragraph_span = 0
		let g:limelight_default_coefficient = 0.7
		let g:iawriter_change_underline = 1
		let g:iawriter_change_cursorline = 1
		let g:iawriter_center_cursor = 0
		let g:iawriter_show_signcolumn = 0
		return
	endif	" }}}

	if !exists('g:goyo_width')	"{{{2
		let g:goyo_width = '70%'
	endif
	if !exists('g:goyo_height')	"{{{2
		let g:goyo_height = '85%'
	endif
	if !exists('g:limelight_paragraph_span')	"{{{2
		let g:limelight_paragraph_span = 0
	endif
	if !exists('g:limelight_default_coefficient')	"{{{2
		let g:limelight_default_coefficient = 0.7
	endif

	if !exists('g:iawriter_change_underline')	"{{{2
		let g:iawriter_change_underline = 1
	endif
	if !exists('g:iawriter_change_cursorline')	"{{{2
		let g:iawriter_change_cursorline = 1
	endif
	if !exists('g:iawriter_center_cursor')	"{{{2
		let g:iawriter_center_cursor = 0
	endif
	if !exists('g:iawriter_show_signcolumn')	"{{{2
		let g:iawriter_show_signcolumn = 0
	endif
endfun	" }}}

fun! s:pre_enter()	" {{{1
	silent! doautocmd <nomodeline> User IawriterPrePreEnter
	if exists('#goyo')	"{{{2
		Goyo!
	endif	" }}}
	let s:airline_exists = 0
	if exists('#airline') && &statusline =~? 'airline'	" ? = case-insensitive	# = case-sensitive	{{{2
		set eventignore+=FocusGained
		let s:airline_exists = 1
	endif
	augroup iawriter_enter	"{{{2
		au!
		au User GoyoEnter nested ++once call <SID>post_enter()
		au User GoyoEnter nested ++once call <SID>iawriter_autoleave_enter()
	augroup end	" }}}
	call <SID>check_configs()
	call <SID>set_colorscheme('pencil')
	silent! doautocmd <nomodeline> User IawriterPostPreEnter
endfun

fun! s:post_enter()	" {{{1
	silent! doautocmd <nomodeline> User IawriterPrePostEnter
	Limelight
	augroup iawriter_leave	"{{{2
		au!
		au User GoyoLeave nested ++once call <SID>leave()
		au User GoyoLeave nested ++once call <SID>iawriter_autoleave_leave()
	augroup end
	if g:iawriter_change_cursorline	"{{{2
		set nocursorline
	endif
	if g:iawriter_change_underline	"{{{2
		hi CursorLine gui=NONE
	endif
	if g:iawriter_center_cursor	"{{{2
		set scrolloff=9999
	endif
	if !g:iawriter_show_signcolumn	"{{{2
		set signcolumn=no
	endif
	augroup iawriter_silent_cmdline	"{{{2
		au!
		autocmd CmdlineLeave : echo ''
	augroup end	" }}}
	let s:vim_iawriter_enabled = 1
	mode
	redraw
	silent! doautocmd <nomodeline> User IawriterPostPostEnter
endfun

fun! s:leave()	" {{{1
	silent! doautocmd <nomodeline> User IawriterPreLeave
	Limelight!
	call <SID>set_colorscheme(s:saved_colorscheme)
	execute('set scrolloff=' . s:saved_scrolloff)
	execute('set signcolumn=' . s:saved_signcolumn)
	augroup iawriter_silent_cmdline	"{{{2
		au!
	augroup end
	if s:airline_exists	"{{{2
		set eventignore-=FocusGained
		AirlineRefresh
	endif	" }}}
	silent! unlet g:goyo_width

	" Restore configs
	" ---------------
	if exists('s:saved_airline_theme')	" {{{2
		let g:airline_theme = s:saved_airline_theme
	endif
	if exists('s:saved_goyo_width')	"{{{2
		let g:goyo_width = s:saved_goyo_width
	endif
	silent! unlet g:goyo_height
	if exists('s:saved_goyo_height')	"{{{2
		let g:goyo_height = s:saved_goyo_height
	endif
	silent! unlet g:goyo_linenr
	if exists('s:saved_goyo_linenr')	"{{{2
		let g:goyo_linenr = s:saved_goyo_linenr
	endif
	silent! unlet g:limelight_default_coefficient
	if exists('s:saved_limelight_default_coefficient')	"{{{2
		let g:limelight_default_coefficient = s:saved_limelight_default_coefficient
	endif
	silent! unlet g:limelight_paragraph_span
	if exists('s:saved_limelight_paragraph_span')	"{{{2
		let g:limelight_paragraph_span = s:saved_limelight_paragraph_span
	endif	" }}}

	if s:airline_exists		" Refresh airline one last time	{{{2
		AirlineRefresh
	endif	" }}}
	silent! doautocmd <nomodeline> User IawriterPostLeave
endfun

fun! s:toggle(dimension)	" {{{1
	silent! doautocmd <nomodeline> User IawriterToggleTriggered
	if exists('#goyo') && s:vim_iawriter_enabled
		Goyo!
	else
		call <SID>pre_enter()
		if a:dimension is v:none
			Goyo
		else
			execute 'Goyo' a:dimension
		endif
	endif
	silent! doautocmd <nomodeline> User IawriterToggleFinished
endfun	" }}}

fun! vim_iawriter#toggle(dimension=v:none)	" {{{1
	call <SID>toggle(a:dimension)
endfun	" }}}
command! -nargs=? Iawriter call vim_iawriter#toggle(<f-args>)

" Close vim when only window open is iAwriter	" {{{1
" Taken from https://github.com/junegunn/goyo.vim/wiki/Customization#ensure-q-to-quit-even-when-goyo-is-active
function! s:iawriter_autoleave_enter()	" {{{2
	let b:quitting = 0
	let b:quitting_bang = 0
	augroup iawriter_only_window
		au!
		autocmd QuitPre <buffer> let b:quitting = 1
	augroup end
	cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
endfunction

function! s:iawriter_autoleave_leave()	" {{{2
	" Quit Vim if this is the only remaining buffer
	if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
		if b:quitting_bang
			qa!
		else
			qa
		endif
	endif
endfunction	" }}}
	" }}}
" Toggling colorschemes messes up syntax (vim issue)	" {{{1
" See: https://github.com/vim/vim/issues/4405
" Workaround: https://github.com/altercation/solarized/issues/102#issuecomment-275269574
if !exists('s:known_colorscheme_links')	" {{{2
  let s:known_colorscheme_links = {}
endif

function! s:find_colorscheme_links() " {{{2
  " find and remember links between highlighting groups.
  redir => listing
  try
    silent highlight
  finally
    redir END
  endtry
  for line in split(listing, "\n")
    let tokens = split(line)
    " We're looking for lines like "String xxx links to Constant" in the
    " output of the :highlight command.
    if len(tokens) ==# 5 && tokens[1] ==# 'xxx' && tokens[2] ==# 'links' && tokens[3] ==# 'to'
      let fromgroup = tokens[0]
      let togroup = tokens[4]
      let s:known_colorscheme_links[fromgroup] = togroup
    endif
  endfor
endfunction

function! s:restore_colorscheme_links() " {{{2
  " restore broken links between highlighting groups.
  redir => listing
  try
    silent highlight
  finally
    redir END
  endtry
  let num_restored = 0
  for line in split(listing, "\n")
    let tokens = split(line)
    " We're looking for lines like "String xxx cleared" in the
    " output of the :highlight command.
    if len(tokens) ==# 3 && tokens[1] ==# 'xxx' && tokens[2] ==# 'cleared'
      let fromgroup = tokens[0]
      let togroup = get(s:known_colorscheme_links, fromgroup, '')
      if !empty(togroup)
        execute 'hi link' fromgroup togroup
        let num_restored += 1
      endif
    endif
  endfor
endfunction

function! s:set_colorscheme(colo_name)	" {{{2
  call <SID>find_colorscheme_links()
  exec 'colorscheme ' a:colo_name
  call <SID>restore_colorscheme_links()
endfunction	" }}}
" }}}

" vim: fdm=marker ts=4 noet sts=0
