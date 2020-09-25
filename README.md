# vim-iawriter [![Github repo link](https://img.shields.io/badge/view%20on%20github-black?style=for-the-badge&logo=github)](https://github.com/subnut/vim-iawriter "Github repo link") [![Screenshots](https://img.shields.io/badge/Screenshots-blue?style=for-the-badge)](#screenshots "Screenshots")



This is a minimal plugin that aims to provide an experience similar to [iAwriter](https://ia.net/writer)'s Focus mode. Currently it can only highlight paragraphs. Sentence highlighting is a TODO.

It acts as a wrapper around three other plugins -
* [goyo.vim](https://github.com/junegunn/goyo.vim)
* [limelight](https://github.com/junegunn/limelight.vim)
* [vim-colors-pencil](https://github.com/reedes/vim-colors-pencil)

## Installation
Install the plugins mentioned above, and then install this plugin any way you like 😄 <br/>
In case you have never installed plugins before, I recommend you to check out [vim-plug](https://github.com/junegunn/vim-plug)

Using [vim-plug](https://github.com/junegunn/vim-plug), the configuration should be -

```vim
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'reedes/vim-colors-pencil'
Plug 'subnut/vim-iawriter'
```

## Usage
`:Iawriter`

Or, you could also map something to `call vim_iawriter#toggle()`

## Configuration
`vim-iawriter` does not touch the configurations defined individually for the abovementioned three plugins. If they are defined, vim-iawriter shall respect them
In addition, vim-iawriter provides a few configuration options -
* [`iawriter_force_defaults`][1.1]
* [`iawriter_change_cursorline`][1.2]
* [`iawriter_change_underline`][1.3]
* [`iawriter_show_signcolumn`][1.4]
* [`iawriter_center_cursor`][1.5] (experimental)

  [1.1]: #iawriter_force_defaults
  [1.2]: #iawriter_change_cursorline
  [1.3]: #iawriter_change_underline
  [1.4]: #iawriter_show_signcolumn
  [1.5]: #iawriter_center_cursor

#### iawriter_force_defaults
This option shall **override ALL other options** <br/>
It enforces the defaults that ship with `vim-iAwriter`

i.e. `let g:iawriter_force_defaults = 1` implies -
```vim
let g:goyo_width = '70%'
let g:goyo_height = '85%'
let g:limelight_paragraph_span = 0
let g:limelight_default_coefficient = 0.7
let g:iawriter_change_underline = 1
let g:iawriter_change_cursorline = 1
let g:iawriter_center_cursor = 0
let g:iawriter_show_signcolumn = 0
```

#### iawriter_change_cursorline
`vim-iawriter` turns off cursorline (if enabled) by default. To keep it on -
```vim
let g:iawriter_change_cursorline = 0
```

#### iawriter_change_underline
`vim-iawriter` turns off the underlining of the cursorline (if enabled) by default. To keep it on -
```vim
let g:iawriter_change_underline = 0
```

#### iawriter_show_signcolumn
`vim-iawriter` hides the signcolumn by default. To keep it -
```vim
let g:iawriter_show_signcolumn = 1
```

#### iawriter_center_cursor
This is an **experimental feature**. If enabled, `vim-iawriter` shall try to keep the cursor in the vertical center of the screen. To turn it on -
```vim
let g:iawriter_center_cursor = 1
```

## Overrides
`vim-iawriter` provides some overrides. Useful if you use both Iawriter and Goyo/Limelight. It overrides the defaults set in .vimrc

| Configuration Option | Overrides |
| -------------------- | --------- |
| `g:iawriter_goyo_width`| [`g:goyo_width`][2.1] |
| `g:iawriter_goyo_height`| [`g:goyo_height`][2.2] |
| `g:iawriter_goyo_linenr`| [`g:goyo_linenr`][2.3] |
| `g:iawriter_limelight_coefficient`| [`g:limelight_coefficient`][2.4] |
| `g:iawriter_limelight_paragraph_span`| [`g:limelight_paragraph_span`][2.5] |

  [2.1]: https://github.com/junegunn/goyo.vim#configuration
  [2.2]: https://github.com/junegunn/goyo.vim#configuration
  [2.3]: https://github.com/junegunn/goyo.vim#configuration
  [2.4]: https://github.com/junegunn/limelight.vim#options
  [2.5]: https://github.com/junegunn/limelight.vim#options

## Extras
Screenshots: [here](#screenshots)

For the _preview_ feature, I personally use [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)

<br/>

## Advanced configuration
`vim-iawriter` provides plenty of autocommands -

<br/>

| Autocommand | When |
| ----------- | ---- |
| `IawriterToggleTriggered` | `s:toggle()` enter
| `IawriterToggleFinished` | `s:toggle()` exit
| `IawriterPrePreEnter` | `s:pre_enter()` enter
| `IawriterPostPreEnter` | `s:pre_enter()` exit
| `IawriterPrePostEnter` | `s:post_enter()` enter
| `IawriterPostPostEnter` | `s:post_enter()` exit
| `IawriterPreLeave` | `s:leave()` enter
| `IawriterPostLeave` | `s:leave()` exit

<br/>

##### `s:toggle()`
 - Checks if vim-iawriter is already running. If yes, closes it (by closing Goyo). Else starts it.

##### `s:pre_enter()`
 - Closes Goyo (not vim-iawriter) if running
 - Checks if [vim-airline][3] is installed & enabled
 - Sets up autocmds to call `s:post_enter()` on entering Goyo
 - Loads configs
 - Changes colorscheme
 - Starts Goyo

     [3]: https://github.com/vim-airline/vim-airline

##### `s:post_enter()`
 - Runs after Goyo starts
 - Enables Limelight
 - Sets up autocmds to call `s:leave()` on closing Goyo
 - Applies configs

##### `s:leave()`
 - Runs when Goyo closes
 - Restores original configs

See `plugin/vim_iawriter.vim` for more information on these functions

<br/>

## Screenshots
![dark](pictures/dark.png 'dark')
![light](pictures/light.png 'light')
