

![grow-false](https://user-images.githubusercontent.com/16906982/115581381-d057ee00-a27c-11eb-8fd5-3e91a5668ccb.gif)
![grow-true](https://user-images.githubusercontent.com/16906982/115581396-d2ba4800-a27c-11eb-8d2a-06a846d18fe5.gif)
```lua
require'floating'.config {
defaults = {
-- nvim_open_win() standard params
width = 0.9, -- 0-1 = 0%-100%
height = 0.3, -- 0-1 = 0%-100%
relative = 'win', -- 'editor'/'win' supported only
style = 'minimal', -- 'minimal' only

-- single & dual
x = 0, -- right -, left +
y = 0, -- down -, up +
pin = 'bot', -- top/topright/right/botright/bot/botleft/left/topleft
winblend = 15,
margin = {1,1,1,1},
enter = false, -- true/false or 'one'/'two'
toggle = true, 

-- single & dual border
border = true, -- true/false - show/hide border
border_thickness = { 1,1,1,1},
borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
title = 'win1',


-- single & dual - height manipulation
grow = true, -- true/false
grow_direction = 'down', -- 'up'/'down'
content_height = false, -- true/false
max_height = 40, -- in row/line count



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


![pin](https://user-images.githubusercontent.com/16906982/115612416-16727900-a2a0-11eb-98ec-7d92979fc652.png)





grow direction is disabled if pin is enabled
layout is disabled when dual is false

affects the maximum lines the window can grow to, and if content_height is true
content height is affected by grow_max_heighti



Single Window Layout Calculation flow:
Pin > Offset> Margin > Open Buffer/Window/Border > Content Height

Dual Window Layout Calculation flow:
Pin > Offset > [Window 1 gets split here] > Gap > Split > Margin > Open Buffers/Windows/Borders > Content Height
