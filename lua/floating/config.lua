local utils = require'floating/utils'
local get_default = utils.get_default



Config = {
defaults = {
show_border = true,
border_thickness = { 1,1,1,1},
borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
one_border_title = 'win1',
two_border_title = 'win2',
x = 0,
y = 0,
layout = 'vertical',
pin = 'bot',
center = true,
dual = false,
grow = false,
two_grow = false, 
max_height = 40,
two_max_height = 40,
grow_direction = false,
two_grow_direction = false,
winblend = 15,
split = 0.5,
gap = 0,
content_height = false,
two_content_height = false,
margin = {1,1,1,1},
two_margin = {1,1,1,1},
width = 0.9,
height = 0.3,
relative = 'win',
style = 'minimal',
enter = false
},
view_presets = {},
action_presets = {},
}

function Config.setup(opts)
opts = opts or {}
--lo(opts)
--lo('setup trig')



for k, v in pairs(opts.defaults) do
Config.defaults[k] = v
end

Config.view_presets = opts.view_presets
Config.action_presets = opts.action_presets
--vim.tbl_deep_extend('keep', opts.defaults, Config.defaults)
--lo(Config)
end



-- mt = {
-- __index = function(self,k,v)
-- --  lo(self)
--   lo(k)
--   lo(v)
--   lo('floating config index trig')
-- end,
-- __newindex = function() 
--   lo('floating config new index trig') 
-- end
-- }


-- setmetatable(Config, mt)
return Config
