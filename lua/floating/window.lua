local windows = {}


local utils = require'floating/utils'
local get_default = utils.get_default
local ternary = utils.ternary

local config = require'floating/config'

local Border = require'floating/border'


local Window = {}
Window.__index = Window









  
function Window:new(opts)
--lo(opts)
-- ============================================= OPTS =================================================
opts = opts or {}
-- otherwise obj & log padding get_defaults nil error
opts.one_padding = opts.one_padding or {}
opts.two_padding = opts.two_padding or {}

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
grow_side = get_default(opts.grow_size, config.defaults.grow_side),
winblend = get_default(opts.winblend, config.defaults.winblend),
split = get_default(opts.split, config.defaults.split),
gap = get_default(opts.gap, config.defaults.gap),
enter = get_default(opts.enter, config.defaults.enter)
}




if vim.tbl_islist(opts.one_padding) then
custom_opts.one_padding = { 
 get_default(opts.one_padding.top, 1),
 get_default(opts.one_padding.right, 1),
 get_default(opts.one_padding.bottom, 1),
 get_default(opts.one_padding.left, 1),
}
end

if vim.tbl_islist(opts.two_padding) then
custom_opts.two_padding = {
get_default(opts.two_padding.top, 1),
get_default(opts.two_padding.right, 1),
get_default(opts.two_padding.bottom, 1),
get_default(opts.two_padding.left, 1),
}
end

if not vim.tbl_islist(opts.one_padding) then
custom_opts.one_padding = { 
top = get_default(opts.one_padding.top, 1),
right = get_default(opts.one_padding.right, 1),
bottom = get_default(opts.one_padding.bottom, 1),
left = get_default(opts.one_padding.left, 1),
}
end


if not vim.tbl_islist(opts.two_padding) then
custom_opts.two_padding = {
top = get_default(opts.two_padding.top, 1),
right = get_default(opts.two_padding.right, 1),
bottom = get_default(opts.two_padding.bottom, 1),
left = get_default(opts.two_padding.left, 1),
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







total_opts = {
  width = get_default(opts.width, config.defaults.width),
  height = get_default(opts.height, config.defaults.height),
  relative = get_default(opts.relative, config.defaults.relative),
  anchor = 'NW',
 style = get_default(opts.style, config.defaults.style)
 } 





assert(total_opts.width <= 1, 'LTL ERROR: view width 0 - 1 number supported only')
assert(total_opts.height <= 1, 'LTL ERROR: view height 0 - 1 number supported only')
assert(total_opts.width > 0, 'LTL ERROR: view width needs to be 0 - 1 number')
assert(total_opts.height > 0, 'LTL ERROR: view height needs to be 0 - 1 number')


-- decide max_col, max_row dependant on win or global, for pin
if total_opts.relative == 'win' then
local cwin_max_col = vim.api.nvim_call_function('winwidth', {0})
local cwin_max_row = vim.api.nvim_call_function('winheight', {0})
custom_opts.max_col = cwin_max_col
custom_opts.max_row = cwin_max_row
else
custom_opts.max_col = vim.o.columns
custom_opts.max_row = vim.o.lines
end


-- always center
local col_start_percentage = (1 - total_opts.width) /2
local row_start_percentage = (1 - total_opts.height) / 2

total_opts.height = math.floor(custom_opts.max_row * total_opts.height)
total_opts.width = math.floor(custom_opts.max_col * total_opts.width)
total_opts.col = custom_opts.max_col * col_start_percentage
total_opts.row = custom_opts.max_row * row_start_percentage



local function apply_pin(colrow, total_opts, custom_opts)
 
if custom_opts.pin == nil then return false end

local max_col, max_row = custom_opts.max_col, custom_opts.max_row
local width, height = total_opts.width, total_opts.height

local choose_pin = {
top = ternary(colrow,false,0), 
topright = ternary(colrow, max_col - width, 0),
right =  ternary(colrow, max_col - width,false), 
bottomright = ternary(colrow, max_col - width, max_row - height - 1),
bottom = ternary(colrow,false, max_row - height - 1), -- -1 for statusline
bottomleft = ternary(colrow, 0, max_row - height - 1), -- -1 for statusline
left = ternary(colrow,0,false), 
topleft = ternary(colrow, 0, 0)
}
return choose_pin[custom_opts.pin]
end



-- then apply pin
total_opts.col = apply_pin(true, total_opts, custom_opts) or total_opts.col
total_opts.row = apply_pin(false, total_opts, custom_opts) or total_opts.row



-- add offset
total_opts.col = total_opts.col - custom_opts.x
total_opts.row = total_opts.row + custom_opts.y






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

one_opts = create_window_opts(total_opts, custom_opts, true, layout_bool)
two_opts =  create_window_opts(total_opts, custom_opts, false, layout_bool)

local gap_bool
if custom_opts.gap > 0 then gap_bool = true else gap_bool = false end



-- add gap
if layout_bool and gap_bool then 
one_opts.width = one_opts.width - custom_opts.gap
elseif gap_bool then
two_opts.height = two_opts.height - custom_opts.gap
end



-- add split %
local distance = 0.5 - custom_opts.split

if custom_opts.layout == 'horizontal' then
local col_to_move = math.floor(total_opts.width * distance)
one_opts.width = one_opts.width - col_to_move
two_opts.col = two_opts.col - col_to_move
two_opts.width = two_opts.width + col_to_move
else
local row_to_move = math.floor(total_opts.height * distance)
one_opts.height = one_opts.height - row_to_move
two_opts.row = two_opts.row - row_to_move
two_opts.height = two_opts.height + row_to_move
end




local function apply_padding(win_opts, custom_opts, one_two)
local one_two_padding = custom_opts[one_two .. '_padding']

local padding = {}
if not vim.tbl_islist(one_two_padding) then
table.insert(padding, one_two_padding.top)
table.insert(padding, one_two_padding.right) 
table.insert(padding, one_two_padding.bottom)
table.insert(padding, one_two_padding.left)
else
padding = one_two_padding
end

-- anchor decides if the padding side has to be moved or not
-- top
win_opts.row = win_opts.row + padding[1]
win_opts.height = win_opts.height - padding[1]
-- left
win_opts.col = win_opts.col + padding[2]
win_opts.width = win_opts.width - padding[2]
-- bottom
win_opts.height = win_opts.height - padding[3]
-- right
win_opts.width = win_opts.width - padding[4]

return win_opts
end



one_opts = apply_padding(one_opts, custom_opts, 'one')
two_opts = apply_padding(two_opts, custom_opts, 'two')



return setmetatable({
target = opts.target,
one_opts = one_opts,
two_opts = two_opts,
one_border_opts = one_border_opts,
two_border_opts = two_border_opts,
custom_opts = custom_opts,
total_opts = total_opts,
border = Border:new(),
} , self)
end










function Window:open()

self.total_opts.win = vim.api.nvim_get_current_win()
if self.total_opts.relative == 'win' then 
self.one_opts.win = vim.api.nvim_get_current_win() end
if self.total_opts.relative == 'win' and self.two_opts then 
self.two_opts.win = vim.api.nvim_get_current_win() end





local function open_window(one_two, single_dual)

local border_opts = self[one_two .. '_border_opts']


-- 1 create contents buf
local contents_bufnr = vim.api.nvim_create_buf(false, true)
self.bufnr[one_two .. '_content'] = contents_bufnr



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



--self.border:open(self, one_two, single_dual)


self.winnr[one_two .. '_content'] = contents_winnr

vim.api.nvim_win_set_option(contents_winnr, 'winblend', get_default(self.custom_opts.winblend, config.defaults.winblend))




-- work out grow side if pin isnt 
--if pin == false or pin == right or pin == left



 local on_win_closed = string.format(
    [[  autocmd WinClosed <buffer> ++nested ++once :silent lua require('floating/window').on_win_closed('%s')]],
    name)




vim.api.nvim_buf_call(contents_bufnr, function()
 
  vim.cmd([[augroup FloatingInsert]])
  vim.cmd([[  au!]])
  vim.cmd(    on_win_closed)
  vim.cmd([[augroup END]])



vim.cmd('setlocal nocursorcolumn')


config.action_presets[action[1]](contents_bufnr, contents_winnr, action[2], action[3])

end)


local buf_contents = vim.api.nvim_buf_get_lines(contents_bufnr, 0, -1, false)
local line_count = #buf_contents + 2



local function apply_content_height()


end
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

lo(self.total_opts.height)
lo(self.total_opts.row)
lo(line_count)
-- tested: pin bottom, 

height_to_move = self.total_opts.height - line_count
lo(height_to_move)
self.total_opts.row = self.total_opts.row + height_to_move

self.total_opts.height = line_count
--self.total_opts.col = self.total_opts.col - self.total_opts.height
self:resize('one')








if self.custom_opts.grow == true then
vim.api.nvim_buf_attach(contents_bufnr, false, {
on_lines = function() 
lo(line_count)
  lo('on lines trig') 

end,




  on_detach = function() lo('on detach trig') end
})
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





end





function Window:resize(one_two)
lo('resize trig')

--lo(self.custom_opts)
--lo(one_two)

if one_two == 'one' and self.custom_opts.dual == false then
  lo('resize trig 1')
--vim.api.nvim_win_set_config(self.winnr.one_border, self.one_border_opts)
vim.api.nvim_win_set_config(self.winnr.one_content, self.total_opts)

elseif one_two == 'one' and self.custom_opts.dual == true then
 lo('resize trig 2')

vim.api.nvim_win_set_config(self.winnr.one_border, self.one_border_opts)
vim.api.nvim_win_set_config(self.winnr.one_content, self.one_opts)

elseif one_two == 'two' and self.custom_opts.dual == true then
 lo('resize trig 3')

vim.api.nvim_win_set_config(self.winnr.one_border, self.two_border_opts)
vim.api.nvim_win_set_config(self.winnr.one_content, self.two_opts)
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
current_window:open()
--lo(current_window)

fstate_floating.views[current_window.name] = current_window
fstate_floating.recent = current_window

 -- fstate_floating.views[view]:open()
 -- also add to _most recent window array

end

end



function windows.on_win_closed(name)
lo('buf closed trig')
local current_window = fstate_floating.views[name] 
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

end





function Window:focus()
if vim.api.nvim_get_current_win() ~= state.ui.winnr then
state.disp1.prevwin = vim.api.nvim_get_current_win()
vim.api.nvim_set_current_win(state.ui.disp1.winnr)
else
vim.api.nvim_set_current_win(state.disp1.prevwin)
end


end

windows._Window = Window

return windows





-- old
 

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
