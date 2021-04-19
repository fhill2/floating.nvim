local windows = {}


local utils = require'floating/utils'
local get_default = utils.get_default
local ternary = utils.ternary

local config = require'floating/config'

local Border = require'floating/border'

local state = require'floating/state'

local log = require'log1'

local Window = {}
Window.__index = Window









  
function Window:new(opts)
--lo(opts)
-- ============================================= OPTS =================================================
opts = opts or {}
-- otherwise obj & log padding get_defaults nil error
opts.margin = opts.margin or {}
opts.two_margin = opts.two_margin or {}

action = opts.action

custom_opts = {
show_border = get_default(opts.show_border, config.defaults.show_border),
border_thickness = get_default(opts.border_thickness, config.defaults.border_thickness),
borderchars = get_default(opts.borderchars, config.defaults.borderchars),
one_border_title = get_default(opts.one_title, config.defaults.one_border_title),
two_border_title = get_default(opts.two_title, config.defaults.two_border_title),
x = get_default(opts.x, config.defaults.x),
 y = get_default(opts.y, config.defaults.y),
layout = get_default(opts.layout, config.defaults.layout),
pin = get_default(opts.pin, config.defaults.pin),
center = get_default(opts.center, config.defaults.center),
dual = get_default(opts.dual, config.defaults.dual),
grow = get_default(opts.grow, config.defaults.grow),
two_grow = get_default(opts.two_grow, config.defaults.two_grow),
max_height = get_default(opts.max_height, config.defaults.max_height),
two_max_height = get_default(opts.two_max_height, config.defaults.two_max_height),
grow_direction = get_default(opts.grow_direction, config.defaults.grow_direction),
--two_grow_direction = get_default(opts.two_grow_direction, config.defaults.two_grow_direction),
winblend = get_default(opts.winblend, config.defaults.winblend),
split = get_default(opts.split, config.defaults.split),
gap = get_default(opts.gap, config.defaults.gap),
content_height = get_default(opts.content_height, config.defaults.content_height),
two_content_height = get_default(opts.two_content_height, config.defaults.two_content_height),
enter = get_default(opts.enter, config.defaults.enter)
}




if vim.tbl_islist(opts.margin) then
custom_opts.margin = { 
 get_default(opts.margin.top, 1),
 get_default(opts.margin.right, 1),
 get_default(opts.margin.bottom, 1),
 get_default(opts.margin.left, 1),
}
end

if vim.tbl_islist(opts.two_margin) then
custom_opts.two_margin = {
get_default(opts.two_margin.top, 1),
get_default(opts.two_margin.right, 1),
get_default(opts.two_margin.bottom, 1),
get_default(opts.two_margin.left, 1),
}
end

if not vim.tbl_islist(opts.padding) then
custom_opts.padding = { 
top = get_default(opts.margin.top, 1),
right = get_default(opts.margin.right, 1),
bottom = get_default(opts.margin.bottom, 1),
left = get_default(opts.margin.left, 1),
}
end


if not vim.tbl_islist(opts.two_margin) then
custom_opts.two_margin = {
top = get_default(opts.two_margin.top, 1),
right = get_default(opts.two_margin.right, 1),
bottom = get_default(opts.two_margin.bottom, 1),
left = get_default(opts.two_margin.left, 1),
}
end





-- VALIDATE BORDER OPTS snd save back to custom_opts

local border_default_thickness = {
  top = 1,
  right = 1,
  bot = 1,
  left = 1,
}
   local border_options = {}


  if custom_opts.show_border then
    if type(custom_opts.border_thickness) == 'boolean' or vim.tbl_isempty(custom_opts.border_thickness) then
      border_options.border_thickness = border_default_thickness
    elseif #custom_opts.border_thickness == 4 then
      border_options.border_thickness = {
        top = utils.bounded(custom_opts.border_thickness[1], 0, 1),
        right = utils.bounded(custom_opts.border_thickness[2], 0, 1),
        bot = utils.bounded(custom_opts.border_thickness[3], 0, 1),
        left = utils.bounded(custom_opts.border_thickness[4], 0, 1),
      }
    end
  end

    local b_top, b_right, b_bot, b_left, b_topleft, b_topright, b_botright, b_botleft
    if custom_opts.borderchars == nil then
      b_top , b_right , b_bot , b_left , b_topleft , b_topright , b_botright , b_botleft =
        "═" , "║"     , "═"   , "║"    , "╔"       , "╗"        , "╝"        , "╚"
    elseif #custom_opts.borderchars == 1 then
      local b_char = custom_opts.borderchars[1]
      b_top    , b_right , b_bot  , b_left , b_topleft , b_topright , b_botright , b_botleft =
        b_char , b_char  , b_char , b_char , b_char    , b_char     , b_char     , b_char
    elseif #custom_opts.borderchars == 2 then
      local b_char = custom_opts.borderchars[1]
      local c_char = custom_opts.borderchars[2]
      b_top    , b_right , b_bot  , b_left , b_topleft , b_topright , b_botright , b_botleft =
        b_char , b_char  , b_char , b_char , c_char    , c_char     , c_char     , c_char
    elseif #custom_opts.borderchars == 8 then
      b_top , b_right , b_bot , b_left , b_topleft , b_topright , b_botright , b_botleft = unpack(custom_opts.borderchars)
    else
      error(string.format('Not enough arguments for "borderchars"'))
    end

    border_options.top = b_top
    border_options.bot = b_bot
    border_options.right = b_right
    border_options.left = b_left
    border_options.topleft = b_topleft
    border_options.topright = b_topright
    border_options.botright = b_botright
    border_options.botleft = b_botleft


custom_opts.borderchars = border_options.borderchars
custom_opts.border_thickness = border_options.border_thickness

one_border_opts = vim.tbl_extend('keep', border_options, { title = get_default(opts.one_border_title, config.defaults.one_border_title)})
two_border_opts = vim.tbl_extend('keep', border_options, { title = get_default(opts.two_border_title, config.defaults.two_border_title)})







total_opts_init = {
  width = get_default(opts.width, config.defaults.width),
  height = get_default(opts.height, config.defaults.height),
  relative = get_default(opts.relative, config.defaults.relative),
  anchor = 'NW',
 style = get_default(opts.style, config.defaults.style)
 } 



if total_opts_init.relative == 'win' then 
total_opts_init.win = vim.api.nvim_get_current_win()
end



assert(total_opts_init.width <= 1, 'LTL ERROR: view width 0 - 1 number supported only')
assert(total_opts_init.height <= 1, 'LTL ERROR: view height 0 - 1 number supported only')
assert(total_opts_init.width > 0, 'LTL ERROR: view width needs to be 0 - 1 number')
assert(total_opts_init.height > 0, 'LTL ERROR: view height needs to be 0 - 1 number')




-- decide max_col, max_row dependant on win or global, for pin
if total_opts_init.relative == 'editor' then
custom_opts.max_col = vim.o.columns
custom_opts.max_row = vim.o.lines
end




return setmetatable({
one_border_opts = one_border_opts,
two_border_opts = two_border_opts,
custom_opts = custom_opts,
total_opts_init = total_opts_init,
border = Border:new(),
} , self)
end












function Window:calculate(win_self)

if win_self then win_self = self end

--Window:refresh_data(self)
total_opts = vim.deepcopy(self.total_opts_init)
custom_opts = self.custom_opts



custom_opts.max_col = nil
custom_opts.max_row = nil
custom_opts.max_col = vim.api.nvim_call_function('winwidth', {total_opts.win})
custom_opts.max_row = vim.api.nvim_call_function('winheight', {total_opts.win})


-- always center
local col_start_percentage = (1 - total_opts.width) /2
local row_start_percentage = (1 - total_opts.height) / 2

--lo(custom_opts.max_col)

total_opts.height = math.floor(custom_opts.max_row * total_opts.height)
total_opts.width = math.floor(custom_opts.max_col * total_opts.width)
total_opts.col = custom_opts.max_col * col_start_percentage
total_opts.row = custom_opts.max_row * row_start_percentage


--lo('total opts width after width calculation')

--lo(total_opts.width)

local function apply_pin(colrow, total_opts, custom_opts)
 
if custom_opts.pin == nil then return false end

local max_col, max_row = custom_opts.max_col, custom_opts.max_row
local width, height = total_opts.width, total_opts.height

local choose_pin = {
top = ternary(colrow,false,0), 
topright = ternary(colrow, max_col - width, 0),
right =  ternary(colrow, max_col - width,false), 
botright = ternary(colrow, max_col - width, max_row - height),
bot = ternary(colrow,false, max_row - height), -- -1 for statusline
botleft = ternary(colrow, 0, max_row - height), -- -1 for statusline
left = ternary(colrow,0,false), 
topleft = ternary(colrow, 0, 0)
}
return choose_pin[custom_opts.pin]
end



-- then apply pin
if custom_opts.pin then
total_opts.col = apply_pin(true, total_opts, custom_opts) or total_opts.col
total_opts.row = apply_pin(false, total_opts, custom_opts) or total_opts.row
end


-- convert xy offset in % to col/row count
--custom_opts.x = custom_opts.max_col * custom_opts.x
--custom_opts.y = custom_opts.max_row * custom_opts.y

-- add offset
total_opts.col = total_opts.col - custom_opts.x
total_opts.row = total_opts.row + custom_opts.y




if custom_opts.dual == true then
  -- everything in this condition only applies to opening 2 windows at once

local layout_bool
if custom_opts.layout == 'horizontal' then layout_bool = true elseif custom_opts.layout == 'vertical' then layout_bool = false end


-- create each individual window options
local function create_window_opts(total_opts, custom_opts, one_two, layout_bool)
local total_opts = vim.deepcopy(total_opts) -- important


total_opts.col = math.floor(ternary(one_two, ternary(layout_bool, total_opts.col, total_opts.col ), ternary(layout_bool, total_opts.col + total_opts.width / 2, total_opts.col)))
total_opts.row = math.floor(ternary(one_two, ternary(layout_bool, total_opts.row , total_opts.row), ternary(layout_bool, total_opts.row, total_opts.row + total_opts.height / 2)))
total_opts.width = math.floor(ternary(one_two,ternary(layout_bool, total_opts.width / 2, total_opts.width),ternary(layout_bool, total_opts.width / 2 , total_opts.width)))
total_opts.height = math.floor(ternary(one_two, ternary(layout_bool, total_opts.height , total_opts.height / 2 ), ternary(layout_bool, total_opts.height, total_opts.height /2)))
return total_opts
end



-- windows are split here
one_opts = create_window_opts(total_opts, custom_opts, true, layout_bool)
if custom_opts.dual == true then
two_opts =  create_window_opts(total_opts, custom_opts, false, layout_bool)
end


if total_opts.relative == 'win' then 
one_opts.win = total_opts.win end
if total_opts.relative == 'win' and two_opts then 
two_opts.win = total_opts.win end



local gap_bool
if custom_opts.gap > 0 then gap_bool = true else gap_bool = false end



--add gap
if layout_bool and gap_bool then 
one_opts.width = one_opts.width - custom_opts.gap
elseif gap_bool then
two_opts.height = two_opts.height - custom_opts.gap
end



--add split %
local distance = 0.5 - custom_opts.split

if custom_opts.layout == 'horizontal' then
local col_to_move = math.floor(total_opts.width * distance)
one_opts.width = one_opts.width - col_to_move
if custom_opts.dual == true then
two_opts.col = two_opts.col - col_to_move
two_opts.width = two_opts.width + col_to_move
end
else
local row_to_move = math.floor(total_opts.height * distance)
one_opts.height = one_opts.height - row_to_move
if custom_opts.dual == true then
two_opts.row = two_opts.row - row_to_move
two_opts.height = two_opts.height + row_to_move
end
end

end -- END IF MULTIPLE WINDOWS


local function apply_margin(win_opts, custom_opts, one_two)

local one_two_margin
if one_two == 'one' then
one_two_margin = custom_opts.margin
elseif one_two == 'two' then
one_two_margin = custom_opts.two_margin
end


local padding = {}
if not vim.tbl_islist(one_two_margin) then
table.insert(margin, one_two_margin.top)
table.insert(margin, one_two_margin.right) 
table.insert(margin, one_two_margin.bottom)
table.insert(margin, one_two_margin.left)
else
margin = one_two_margin
end

-- anchor decides if the padding side has to be moved or not
-- top
win_opts.row = win_opts.row + margin[1]
win_opts.height = win_opts.height - margin[1]
-- left
win_opts.col = win_opts.col + margin[2]
win_opts.width = win_opts.width - margin[2]
-- bottom
win_opts.height = win_opts.height - margin[3]
-- right
win_opts.width = win_opts.width - margin[4]

return win_opts
end


if custom_opts.dual == true then
one_opts = apply_margin(one_opts, custom_opts, 'one')
two_opts = apply_margin(two_opts, custom_opts, 'two')
elseif custom_opts.dual == false then
total_opts = apply_margin(total_opts, custom_opts, 'one')
end





if custom_opts.dual == true then
self.one_opts = one_opts
self.two_opts = two_opts
end
self.total_opts = total_opts
self.custom_opts = custom_opts
-- end calculate

end










function Window:refresh_win_dimensions(win_self)

if win_self.total_opts_init.relative == 'win' then
 win_self.custom_opts.max_col = vim.api.nvim_call_function('winwidth', {win_self.total_opts_init.win})

win_self.custom_opts.max_row = vim.api.nvim_call_function('winheight', {win_self.total_opts_init.win})

end
end








function Window:resize_all(win_self)
--if win_self then win_self = self end
lo('RESIZE TRIG')
--lo('self at resize all is')
--log.info(win_self)


win_self.calculate(win_self)
win_self.border:redraw_all(win_self)


if win_self.custom_opts.dual == false then
  lo('resize trig 1')

--lo('self total opts width at time of nvim win set config')
vim.api.nvim_win_set_config(win_self.winnr.one_content, win_self.total_opts)


elseif self.custom_opts.dual == true then
 lo('resize trig 2')
vim.api.nvim_win_set_config(win_self.winnr.one_content, win_self.one_opts)
vim.api.nvim_win_set_config(win_self.winnr.two_content, win_self.two_opts)
end

end







function Window:resize_to_height(win_self, one_two, single_dual)




local buf_contents = vim.api.nvim_buf_get_lines(win_self.bufnr[one_two .. '_content'], 0, -1, false)
--lo(buf_contents)
line_count = #buf_contents + 2


local max_height
if one_two == 'one' then
max_height = win_self.custom_opts.max_height
opts_direction = win_self.custom_opts.grow_direction
else
max_height = win_self.custom_opts.two_max_height
end
-- limit by max height
if line_count > max_height then line_count = max_height end



local other_win
if one_two == 'one' then other_win = 'two' else other_win = 'one' end 



local height_to_move, current_opts, other_win_opts, other_content_winnr, content_winnr
if single_dual == true then
current_opts = win_self.total_opts 
elseif single_dual == false then
current_opts = win_self[one_two .. '_opts']

other_win_opts = win_self[other_win .. '_opts']

other_content_winnr = win_self.winnr[other_win .. '_content']
end


content_winnr = win_self.winnr[one_two .. '_content']

height_to_move = current_opts.height - line_count












local pin = win_self.custom_opts.pin

height_col = {
top = 'down',
topright = 'down',
right = 'down',
botright = 'up',
bot = 'up',
botleft = 'up',
left = 'down',
topleft = 'down',
nopin = 'nopin'
}

--local resize_actions = {}

local direction = height_col[pin]
-- if pin == 'bot' or pin == 'botleft' or pin == 'botright' then
--   table.insert(resize_actions, 'height_and_row')
-- elseif pin == 'top' or pin == 'topleft' or pin == 'topright' then
--   table.insert(resize_actions, 'height_only')
-- elseif pin == 'left' or pin == 'right' then
--   table.insert(resize_actions, 'height_only')
-- end

opts_direction = win_self.custom_opts.grow_direction

if direction == nil then
  if type(opts_direction) == 'string' and opts_direction ~= false then
     direction = opts_direction   
     lo('grow direction set to opts direction')
    else
      win_self:refresh_win_dimensions(win_self)
      if win_self.total_opts.row > win_self.custom_opts.max_row / 2 then
        direction = 'up'
        lo('direction manually set to up')
        else
          lo('direction manually set to down')
          direction = 'down'
          end
    end
end


-- single window top side pins 
  if direction == 'down' then
--lo('picked height_only')


current_opts.height = line_count

if one_two == 'one'  and single_dual == false and win_self.custom_opts.layout ~= 'horizontal' then
   other_win_opts.row = other_win_opts.row - height_to_move
vim.api.nvim_win_set_config(other_content_winnr, other_win_opts)
win_self.border:redraw_single(win_self, other_win, single_dual, other_win_opts)
end
  end



-- single window bot pins
if direction == 'up' then
 -- lo('picked height_and_row')
current_opts.row = current_opts.row + height_to_move
current_opts.height = line_count
  if one_two == 'two' and single_dual == false and win_self.custom_opts.layout ~= 'horizontal' then
    lo('this RAN')
  other_win_opts.row = other_win_opts.row + height_to_move
vim.api.nvim_win_set_config(other_content_winnr, other_win_opts)
win_self.border:redraw_single(win_self, other_win, single_dual, other_win_opts)
  end

  end

-- dual window top side pins
-- if action == 'height_only' and single_dual == false then

-- current_opts.height = line_count

-- end

-- dual window bot pins
-- if action == 'height_and_row' and single_dual == false then
--   current_opts.height = line_count

-- end
vim.api.nvim_win_set_config(content_winnr, current_opts)

-- write resize modifications back to obj
-- if single_dual == true then
-- win_self.total_opts = win_self.current_opts
-- elseif single_dual == false then
-- win_self[one_two .. '_opts'] = current_opts
-- win_self[other_win .. '_opts'] = other_win_opts
-- end





--win_self.border:redraw_all(win_self)

win_self.border:redraw_single(win_self, one_two, single_dual, current_opts)

end









function Window:open()






local function open_window(one_two, single_dual)

local border_opts = self[one_two .. '_border_opts']


-- 1 create contents buf
local contents_bufnr = vim.api.nvim_create_buf(false, true)
self.bufnr[one_two .. '_content'] = contents_bufnr


--lo(self.total_opts)
-- 2 create contents winnr
local contents_winnr
if single_dual == false then
contents_winnr = vim.api.nvim_open_win(contents_bufnr, false, self[one_two .. '_opts'])
elseif single_dual == true then
contents_winnr = vim.api.nvim_open_win(contents_bufnr, false, self.total_opts)
end

-- 3 name it
local name
if self.total_opts.relative == 'win' then
name = string.format('%s_%s', contents_winnr, contents_bufnr)
elseif self.total_opts.relative == 'editor' then
name = 'global_' .. contents_bufnr 
end
self.name = name



self.border:open_single(self, one_two, single_dual)


self.winnr[one_two .. '_content'] = contents_winnr

vim.api.nvim_win_set_option(contents_winnr, 'winblend', get_default(self.custom_opts.winblend, config.defaults.winblend))




-- work out grow side if pin isnt 
--if pin == false or pin == right or pin == left



 local on_win_closed = string.format(
    [[  autocmd WinClosed <buffer> ++nested ++once :silent lua require('floating/window').on_win_closed('%s')]],
    name)





vim.api.nvim_buf_call(contents_bufnr, function()
 
  vim.cmd([[augroup FloatingWinClosed]])
  vim.cmd([[  au!]])
  vim.cmd(    on_win_closed)
  vim.cmd([[augroup END]])

vim.cmd('setlocal nocursorcolumn')

config.action_presets[action[1]](contents_bufnr, contents_winnr, action[2], action[3])

end)




local function buf_attach(self, one_two, single_dual)

local contents_bufnr = self.bufnr[one_two .. '_content']


vim.api.nvim_buf_attach(contents_bufnr, false, {
on_lines = function()

Window:resize_to_height(self, one_two, single_dual)
end,




  on_detach = function() lo('on detach trig') end
})


end



if one_two == 'one' and self.custom_opts.grow == true then
buf_attach(self, 'one', single_dual)
end
if one_two == 'two' and self.custom_opts.two_grow == true then
buf_attach(self, 'two', single_dual)
end



end






self.bufnr = {}
self.winnr = {}

if self.custom_opts.dual then
open_window('one', false)
open_window('two', false)
else
open_window('one', true)
end


local enter = self.custom_opts.enter
if type(enter) == 'boolean' and enter == true then
vim.api.nvim_set_current_win(self.winnr.one_win)
elseif type(enter) == 'string' and enter == 'one' then
vim.api.nvim_set_current_win(self.winnr.one_win)
elseif type(enter) == 'string' and enter == 'two' then
vim.api.nvim_set_current_win(self.winnr.two_win)
end


-- on window open resize height to content height
if custom_opts.content_height == true and custom_opts.dual == false then
self:resize_to_height(self, 'one', true)
end
if custom_opts.content_height == true and custom_opts.dual == true then
self:resize_to_height(self, 'one', false)
end
if custom_opts.two_content_height == true and custom_opts.dual == true then
self:resize_to_height(self, 'two', false)
end




end

















function windows.open(opts)
lo('===== NEW WINDOW RUN =====')
opts = opts or {}
--lo(opts)


local view_in_keys = {}
-- 1 replace view1 = 'string' with its table from config - ui/view presets
for k,v in pairs(opts or {}) do
if k:find('^view[%d]*$') then 
  table.insert(view_in_keys, k)
  if type(v) == 'string' then
    assert(config.view_presets[v], 'view preset not found in config')
    opts[k] = config.view_presets[v]
   end

 end
end


for _, view in ipairs(view_in_keys) do
-- 3 check if presets were added to opts successfully
assert(type(opts[view]) == 'table', 'opts...view1..not a table')
--assert(type(opts[view .. '_action']) == 'function', 'opts...view1_action..not a function')
-- 4 add view1_action root level into view = { action = actionpreset } cause cba to change all values in window.lua
    opts[view].action = opts[view .. '_action']
end



--lo(opts)
for _, view in ipairs(view_in_keys) do

local current_window = Window:new(opts[view] or {})
--lo(current_window)
current_window:calculate()
current_window:open()
--lo(current_window)



state.views[current_window.name] = current_window
state.recent = current_window



-- unfortunately timer is needed due to no winresized event, but its coming soon
--https://github.com/neovim/neovim/pull/13589
 if not state.timer_enabled then
local timer = vim.loop.new_timer()
state.timer = timer
    timer:start(1000, 1000, vim.schedule_wrap(function()

     if vim.tbl_isempty(state.views) then timer:stop() return end
-- 1 for window local floating windows, iterate windows and find their corresponding attached main windows
    
local windows_to_monitor = {}
for k, v in pairs(state.views) do
if v.total_opts.relative == 'win' then

local current_window = k

local old_max_col = vim.deepcopy(v.custom_opts.max_col)
local old_max_row = vim.deepcopy(v.custom_opts.max_row)

state.views[k]:refresh_win_dimensions(state.views[k])

-- v.custom_opts.max_col = vim.api.nvim_call_function('winwidth', {v.total_opts.win})
--v.custom_opts.max_row = vim.api.nvim_call_function('winheight', {v.total_opts.win})



if old_max_col ~= v.custom_opts.max_col or old_max_row ~= v.custom_opts.max_row then
--lo('before resize')
--lo(state.views[k])

 --   lo('VALUES ARE DIFFERENT - WINDOW RESIZED')
--local log = require'log1'
  ---  log.info(state.views[k])
    state.views[k]:resize_all(state.views[k])
      end
--  table.insert(windows_to_monitor, v.total_opts.win)

end
end
--lo(windows_to_monitor)


     end))


end

end

end



function windows.on_win_closed(name)
if vim.tbl_isempty(state.views) then timer:stop() return end

lo('buf closed trig')
--lo(name)
local current_window = state.views[name] 

--lo(current_window)
-- close both content and border windows
for k, v in pairs(current_window.winnr) do
vim.api.nvim_win_close(v, false)
end

-- delete border buffer
-- vim.api.nvim_buf_delete(current_window.bufnr.obj_border, { force = true })
-- if current_window.bufnr.log_border then 
--   vim.api.nvim_buf_delete(current_window.bufnr.log_border, { force = true })
-- end


current_window = nil
if state.recent == state.views[name] then state.recent = nil end
state.views[name] = nil

end





function Window:focus()
end


windows._Window = Window

return windows


















-- old auto grow stuff





-- if win_self.custom_opts.dual == false then

-- else


-- end




-- add one off contents height adjust when opening window, after buffer and custom function is loaded
-- if single_dual == false and one_two == 'one' then

-- elseif single_dual == false and one_two == 'two' then

-- elseif single_dual == true then 
-- apply_content_height(self.total_opts)
-- end


-- what if its a negative number?
-- local line_count = 7
-- self.total_opts.row = 14
-- -- or positive
-- local line_count = 14
-- self.total_opts.row = 7


-- local function other_win(w)
-- if w == 'one' then return 'two' else return 'one' end
-- end

-- other_win = other_win(one_two)

-- lo(self.total_opts.height)
-- lo(self.total_opts.row)
-- lo(line_count)
-- -- tested: pin bottom, 


--decide direction based on pin
-- local direction, op
-- if win_self.custom_opts.pin == 'top' then
-- direction = 'down'
-- op = 'add'
-- elseif win_self.custom_opts.pin == 'bottom' then
-- direction = 'up'
-- op = 'min'
-- end

-- local function add_min(op, a, b)
-- if op == 'add' then
-- return a + b
-- elseif op == 'min' then
-- return a - b
-- end
-- end






--- old resize function



-- function Window:resize(win_self, one_two)

-- if win_self then win_self = self end
-- lo('resize trig')

-- --lo(self.custom_opts)
-- --lo(one_two)

-- if one_two == 'one' and self.custom_opts.dual == false then
--   lo('resize trig 1')

-- --vim.api.nvim_win_set_config(self.winnr.one_border, self.one_border_opts)
-- lo('self total opts width at time of nvim win set config')

-- lo(self.total_opts.width)
-- vim.api.nvim_win_set_config(self.winnr.one_content, self.total_opts)
-- local border_win_opts = self.border:calculate()


-- elseif one_two == 'one' and self.custom_opts.dual == true then
--  lo('resize trig 2')

-- --vim.api.nvim_win_set_config(self.winnr.one_border, self.one_border_opts)
-- vim.api.nvim_win_set_config(self.winnr.one_content, self.one_opts)

-- elseif one_two == 'two' and self.custom_opts.dual == true then
--  lo('resize trig 3')

-- --vim.api.nvim_win_set_config(self.winnr.one_border, self.two_border_opts)
-- vim.api.nvim_win_set_config(self.winnr.two_content, self.two_opts)
-- --lo('after resize')
-- --lo(win_self)
-- end

-- end





-- old
 -- there is no winresized autocmd, but soon
 --   lo('autocmd winresized setup trig')
 -- local on_win_resized = [[autocmd VimResized :silent lua require('floating/window').on_win_resized()]]


 --  vim.cmd([[augroup FloatingWinResized]])
 --  vim.cmd([[  au!]])
 --  vim.cmd(    on_win_resized)
 --  vim.cmd([[augroup END]])




-- not the same as values returned
-- renderer = renderer:new({ 
--   target = opts.target,
--   log = opts.log,
--   obj_border_opts = obj_border_opts,
--   log_border_opts = log_border_opts,
--   obj_opts = obj_opts,
--   log_opts = log_opts
--   })
--  }


-- 2 replace view1_action == 'presetname' with its function from config - action presets
-- elseif k:find('^view[%d]*_action') then
--   local view = k:gsub('_action', '')

-- -- 2 if function call name is 
-- -- for _, v in ipairs(config.action_presets) do

-- --  if type(v) == 'string' then
-- --    assert(config.action_presets[v], 'action preset not found in config')
-- --       opts[k] = config.action_presets[v] 
-- --     end


-- function windows.open(opts)
-- lo('===== NEW WINDOW RUN =====')
-- opts = opts or {}
-- --lo(opts)


-- local view_in_keys = {}
-- -- 1 replace view1 = 'string' with its table from config - ui/view presets
-- for k,v in pairs(opts or {}) do
-- if k:find('^view[%d]*$') then 
--   table.insert(view_in_keys, k)
--   if type(v) == 'string' then
--     assert(config.view_presets[v], 'view preset not found in config')
--     opts[k] = config.view_presets[v]
--    end

 
-- -- 2 replace view1_action == 'presetname' with its function from config - action presets
-- elseif k:find('^view[%d]*_action') then
--   local view = k:gsub('_action', '')
--  if type(v) == 'string' then
--    assert(config.action_presets[v], 'action preset not found in config')
--       opts[k] = config.action_presets[v] 
--     end
-- end
-- end


-- for _, view in ipairs(view_in_keys) do
-- -- 3 check if presets were added to opts successfully
-- assert(type(opts[view]) == 'table', 'opts...view1..not a table')
-- assert(type(opts[view .. '_action']) == 'function', 'opts...view1_action..not a function')
-- -- 4 add view1_action root level into view = { action = actionpreset } cause cba to change all values in window.lua
--     opts[view].action = opts[view .. '_action']
-- end



-- lo(opts)
-- for _, view in ipairs(view_in_keys) do
--  fstate.floating[view] = Window:new(opts[view] or {})
--  fstate.floating[view]:open()
--  -- also add to _most recent window array

-- end

-- end











--local function parse_view_opts(opts)
-- views = {}
-- for k,v in pairs(opts or {}) do
-- if k:find('^view[%d]*') then table.insert(views, k) end
-- end
-- if vim.tbl_isempty(views) then return false else return views end
-- end




-- view_in_keys = parse_view_opts(opts) or { 'view1' }



-- -- 1st iterate and check if view1 or view2 etc is string, then its a preset
-- for _, view in ipairs(view_in_keys) do
--   if type(view) == 'string' then
    
--   end
-- end





-- for _, view in ipairs(view_in_keys) do

-- fstate.floating[view] = Window:new(opts[view] or {})
-- fst
