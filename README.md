# vim-iawriter
This is a minimal plugin that aims to provide an experience similar to iAwriter's Focus mode. It acts as a wrapper around three other plugins -
* [goyo.vim](https://github.com/junegunn/goyo.vim)
* [limelight](https://github.com/junegunn/limelight.vim)
* [vim-colors-pencil](https://github.com/reedes/vim-colors-pencil)

## Installation
Install the plugins mentioned above, and then install this plugin any way you like :smile: <br/>
In case you have never installed plugins before, I recommend you to check out [vim-plug](https://github.com/junegunn/vim-plug)

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
`vim-airline` provides some overrides. Useful if you use both Iawriter and Goyo/Limelight. It overrides the defaults set in .vimrc
| Configuration Option | Overrides |
| ---------------------| --------- |
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
Screenshots: [here](https://github.com/subnut/vim-iawriter/issues/2)

For the _preview_ feature, I personally use [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)
