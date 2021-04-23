![floating-nvim](https://user-images.githubusercontent.com/16906982/115815857-9ede4000-a3ac-11eb-80d8-8517f30a7650.png)


## What is Floating.nvim?



## Floating.nvim Table of Contents

- Getting Started
- Customization
- Views
- Actions
- API
- Options Showcase
- Contributing



## Getting Started

## Installation





Using [vim-plug](https://github.com/junegunn/vim-plug)

```viml
Plug 'fhill2/floating.nvim'
```

Using [dein](https://github.com/Shougo/dein.vim)

```viml
call dein#add('fhill2/floating.nvim')
```
Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use 'nvim-telescope/telescope.nvim'
```


## Usage















# Opening Views/Windows (Quickstart)
You can open a with an individual configuration in 2 ways:
- manually
- by preset, see [Opening user or default view presets](#Opening-user-or-default-view-presets)

see here for a complete list of opts

a View is a UI/window configuration
an Action is a function run on the window & buffer after the window has opened












## Customization
If you are a [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) user, `floating.nvim` configuration will be familiar, as `floating.nvim` aims to implement the same configuration style.

customizations can be applied globally or individually per window.
- **Global Customization** affecting all views/windows can be done through the main setup() method (see defaults below)
- **Individual Customization** affecting a single view or window can be done by passing 'opts' to open() 
e.g require'floating'.open(opts)
see x for detailed overview


## Floating defaults

```lua
require'floating'.setup {
defaults = {
-- nvim_open_win() standard params
width = 0.9, -- 0-1 = 0%-100%
height = 0.3, -- 0-1 = 0%-100%
x = 0, -- right -, left +
y = 0, -- down -, up +

relative = 'win', -- 'editor'/'win' supported only
style = 'minimal', -- 'minimal' only

-- single & dual
pin = 'bot', -- top/topright/right/botright/bot/botleft/left/topleft
winblend = 15,
margin = {1,1,1,1},
enter = false, -- true/false or 'one'/'two'
toggle = true, 


-- single & dual - height adjustment
grow = true, -- true/false
grow_direction = 'down', -- 'up'/'down'
content_height = false, -- true/false
max_height = 40, -- in row/line count

-- single & dual border
border = true, -- true/false - show/hide border
border_thickness = { 1,1,1,1},
borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
title = 'win1',


-- dual window only settings
dual = false, -- true/false
layout = 'vertical', -- 'vertical'/'horizontal'
split = 0.5,
gap = 0,

-- dual window only settings (duplicates)
two_title = 'win2',
two_grow = false, 
two_max_height = 40,
two_grow_direction = false,
two_content_height = false,
two_margin = {1,1,1,1},
},

view_presets = {
-- add your own custom views here
},
action_presets = {
-- add your own custom actions here
}
}
```




## Individual Customization



### Opening a view by passing in opts manually
```lua
-- to manually open a view

require'floating'.open({
  view1 = {
    
}
 })

```



### specifying an action manually
-- choosing an action (function) to be executed on the buffer after window open.
```lua
require'floating'.open({
  view1 = { width = 0.8, height = 0.4, border = true }
  view1_action = function() 
local write = {'setting a folder marker', '<-- custom', 'fold', '-->', 'add some highlights', '', ''}
        vim.api.nvim_buf_set_lines(opts.bufnr, 0, -1, false, write)
        vim.cmd([[set foldmethod=marker]])
        vim.cmd([[set foldmarker=<--,-->]])
        vim.api.nvim_buf_add_highlight(opts.bufnr, -1, 'String', 0, 0, -1)
        vim.api.nvim_buf_add_highlight(opts.bufnr, -1, 'Error', 4, 0, -1)



  end
 })
```





# Loading User & Default View & Action presets


### Opening a view by loading a user or default view preset
if viewX key is a string instead of a table, `floating.nvim` will look for the string value in the User View presets table of your configuration before opening any windows.
If the string value (preset name) isn't found in User View presets, it checks Default View presets.


```lua
-- setup() attached to init.lua
require'floating'.setup {
  user_view_presets = {
    user_view_preset_1 = { width = 0.4, height = 0.4},
    user_view_preset_2 = {
      -- add your view config
      }  
    }
}

-- from script, cmdline, luafile etc
require'floating'.open({
  view1 = 'user_view_preset_1' -- config values loaded: { width = 0.4, height = 0.4  }
 })


-- If you want to change some config values of the preset you loaded, use 2nd argument.
-- This works the same for default or user presets

require'floating'.open({
  view1 = { 'user_view_preset_1', { width = 0.8, border = true } }  
-- config values loaded: { width = 0.8, height = 0.4, border = true }
 })
```





### loading a user action preset
You can load action presets in the same way you can load view presets
Currently not possible to load multiple actions at once (coming soon)


```lua
-- 1st arg of a custom preset is 'pass through' opts. 2nd arg is your custom opts.

require'floating'.setup {
  user_action_presets = {
    user_action_preset_1 = function(opts, custom_opts)
                  vim.api.nvim_buf_set_lines(opts.bufnr, 0, -1, false, { custom_opts.arg1 })
          end
    }
}

require'floating'.open({
   view1 = 'user_view_preset_1',
  view1_action = { 'user_action_preset_1', { arg1 = 'abc' }} -- writes 'abc' to buffer of opened window

})



-- load default user action presets in the same way

require'floating'.open({
   view1 = 'user_view_preset_1',
 view1_action = {'open_file', string.format('%s/%s', vim.fn.stdpath('config'), 'init.lua')}
})

```














### Views & Actions
- Views
a View is a configuration passed to open() command that affecting/layout of the window. 
After open() is finished, the view configuration is stored internally to manage the windows.
a View can contain 1 or 2 windows, setting dual = true will open another window linked to the main window.
View configs are always table type.
- Actions
Actions are functions run on the window, after the window is created
Without actions, `floating.nvim` can only open an empty window/buffer (e.g no highlighting, folding & additional customizations added)
Actions are always functions

Switching different Actions with Views (specifically when writing those into setup() key) allows an easy way to customize without any duplicated configuration etc.

### Built-in Views & Actions 
The aim is to cover the most popular/used View & Action configs... so everyone who wants to simply open a file in a window doesn't have to write their own Action for it!
See List of Built-in Views & Actions for a complete overview!

If you know of 




Views are opened by passing opts to open()




# View Options
All these options are valid inside the View table.


&#x1F537; &#x1F537; &#x1F537; &#x1F537;
 
Options with &#x1F537; affect the single window if `dual=false`, or window 1 only if `dual=true`.
Append `two_` to key name to affect window 2 when `dual=true`:
```lua
view1 = { dual=true, one_title = 'win 1 border title', two_title = 'win 2 border title' }
```


### Options
| &#x1F537;                | Keys                   | Description                                  | Options                    |
|-|------------------------|-------------------------------------------------------|----------------------------|
| | `dual`                 | opens an additional window linked to the main window  | boolean                    |
| | `width`                 | specify width of window as a % of editor or win dimensions      | 0-1            |
| | `height`                | specify height of window as % of editor or win dimensions | 0-1               |
| | `x`                    | Relative offset applied to window after all other calculations  | NUM or -NUM               |
| | `y`                    | Relative offset applied to window after all other calculations  | NUM or -NUM               |
| | `relative`             | Equivalent to [nvim_open_win](https://neovim.io/doc/user/api.html#nvim_open_win())| 'win' or 'editor |
| | `style`                | Equivalent to [nvim_open_win](https://neovim.io/doc/user/api.html#nvim_open_win())| 'minimal' |                                                  
| | `pin`                  | pin window to a side or corner of the window/editor   | string: edge or corner. see [pin](#Pin)
| |`winblend`             | How transparent the floating window should be.        | NUM                        |
|  &#x1F537; |`margin`             | like CSS - reduces window edges from outside border  | {1,1,1,1} |
| |`enter`                | if/what window should be focused after window open    | boolean                    |
| |`toggle`       |         calling open() on the same view config will close the opened window| boolean |
| |                      |           `Height Adjustment Options`
|  &#x1F537;  |`grow`             | after win open, adjusts window height to buffer contents on buffer keystroke input   | boolean |
|  &#x1F537; |`grow_direction`     | see [grow](#Grow). if pin is disabled, manually specify grow direction.        | 'up' or 'down'    |
|  &#x1F537;|  `content_height`   | after win open, 1 off, adjusts window height to buffer contents  | boolean   |
| &#x1F537; | `max_height`           | maximum height limit window can grow to               | NUM             |
| |                       |      `Border Options`                                 |                            |
| |`border`              |  Enable/disable border                                 | boolean            |
| |`border_thickness`     | Border thickness                                     | {1,1,1,1}                      |
| |`borderchars`          | Border appearance                                     | see [default config](#default-config) |
|&#x1F537; |`title`     | Border title                                          | string  |

### Dual Window Options
These Options are enabled if `dual=true`
| Keys                   | Description                                           | Options                    |
|------------------------|-------------------------------------------------------|----------------------------|    
|   `layout`             |    left/right dual window or top/bot dual window                | 'horizontal' or 'vertical' |
|   `split`              |  Increase window size 1, decrease window size 2 etc. in %   |  0 - 1               |
| `gap`                  | quicker config for padding, only reduces the 2 connecting edges of a dual window |    NUM    | 


### Comments regarding options

`max_height` affects content_height and grow. It doesn't affect height.








### Creating your own custom Views







### Creating your own custom Actions







## Opening multiple views at one time











## Future
Load multiple actions






## Showcase

![grow-false](https://user-images.githubusercontent.com/16906982/115581381-d057ee00-a27c-11eb-8fd5-3e91a5668ccb.gif)
![grow-true](https://user-images.githubusercontent.com/16906982/115581396-d2ba4800-a27c-11eb-8d2a-06a846d18fe5.gif)

![gap-0](https://user-images.githubusercontent.com/16906982/115616286-e37eb400-a2a4-11eb-842e-9f71b7698a8e.png)
![gap-1](https://user-images.githubusercontent.com/16906982/115616294-e4afe100-a2a4-11eb-8b43-1df6abd164f6.png)
![content_height](https://user-images.githubusercontent.com/16906982/115616308-eb3e5880-a2a4-11eb-9b1e-53c98ba073ba.gif)
![split-vert-0 3](https://user-images.githubusercontent.com/16906982/115616316-ee394900-a2a4-11eb-874a-1a3338a785b4.png)
![split-vert-0 7](https://user-images.githubusercontent.com/16906982/115616326-f0030c80-a2a4-11eb-8d68-741581175139.png)
![split-horizontal-0 3](https://user-images.githubusercontent.com/16906982/115616340-f2656680-a2a4-11eb-95fe-9650b958bae6.png)
![split-horizontal-0 7](https://user-images.githubusercontent.com/16906982/115616345-f3969380-a2a4-11eb-8fbe-522c74a56591.png)




![pin](https://user-images.githubusercontent.com/16906982/115612416-16727900-a2a0-11eb-98ec-7d92979fc652.png)





grow direction is disabled if pin is enabled
layout is disabled when dual is false

affects the maximum lines the window can grow to, and if content_height is true
content height is affected by grow_max_heighti



Single Window Layout Calculation flow:
Pin > Offset> Margin > Open Buffer/Window/Border > Content Height

Dual Window Layout Calculation flow:
Pin > Offset > [Window 1 gets split here] > Gap > Split > Margin > Open Buffers/Windows/Borders > Content Height
