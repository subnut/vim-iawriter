# vim-iawriter
This is a minimal plugin that aims to provide an experience similar to iAwriter. It acts as a wrapper around three other plugins -
* [goyo.vim](https://github.com/junegunn/goyo.vim)
* [limelight](https://github.com/junegunn/limelight.vim)
* [vim-colors-pencil](https://github.com/reedes/vim-colors-pencil)

## Installation
Install the plugins mentioned above, and then install this plugin any way you like :smile: <br/>
In case you have never installed plugins before, I recommend you to check out [vim-plug](https://github.com/junegunn/vim-plug)

## Configuration
vim-iawriter does not touch the configurations defined individually for the abovementioned three plugins. If they are defined, vim-iawriter shall respect them.
In addition to that, vim-iawriter provides a few configuration options -
* `let g:iawriter_center_cursor`
* `let g:iawriter_change_cursorline`
* `let g:iawriter_change_underline`

#### g:iawriter_center_cursor
vim-iawriter tries to keep the cursor in the vertical center of the screen by default. To turn that off -
```
let g:iawriter_center_cursor = 0
```

#### g:iawriter_change_cursorline
vim-iawriter turns off cursorline (if enabled) by default. To keep it on -
```
let g:iawriter_change_cursorline = 0
```

#### g:iawriter_change_underline
vim-iawriter turns off the underlining of the cursorline (if enabled) by default. To keep it on -
```
let g:iawriter_change_underline = 0
```

## Extras
For the _preview_ feature, I personally use [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)
