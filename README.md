# scratch.nvim
A simple neovim plugin to allow creating a scratch buffer.

## Features
- Create scratch buffers with different file types.
- Buffers persist until neovim is closed.

## Installion
Using [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
    "R1chardHao/scratch.nvim",
    opts = {}
}
```

## Configuration
Default settings:
```lua
opts = {
    -- Width of the window. If value < 1, it represents the ratio of the width. Otherwise it's the column number.
    width = 0.7,

    -- Height of the window. If value < 1, it represents the ratio of the height. Otherwise it's the row number.
    height = 0.6
}
```

## Usage
Use command `:Scratch` to open a scratch buffer.
By default the buffer has no file type.

Use command `:Scratch <filetype>` to open a scratch buffer with specified file type.
For example, `:Scratch json` will open a scratch buffer for JSON.
> **NOTE:** The filetype is not necessarily the file extension. For exmaple the filetype of JavaScript is `javascript`, not `js`.

Each file type has one buffer at the same time. The content of the buffer will not be cleaned until neovim is closed.

When buffer window is open, use `<q>` or `<Esc>` to close the window.
