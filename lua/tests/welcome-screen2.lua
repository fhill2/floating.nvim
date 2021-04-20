local root = string.format('%s/%s/%s/%s/%s', vim.fn.stdpath('config'), 'plugins-me', 'floating.nvim', 'lua', 'tests')

require'floating'.open({
  view1 = {
  dual = false,
 pin = 'topleft',
 layout = 'horizontal',
 split = 0.7,
  width = 0.6,
  height = 0.4,
  border = true,
  relative = 'editor',
y = 2,
x = -10
  },
view1_action = {'open_file', string.format('%s/%s', root, 'welcome-screen2.lua')},


  view2 = {
  dual = false,
 pin = 'topright',
 layout = 'horizontal',
-- split = 0.7,
  width = 0.2,
  height = 0.4,
  border = true,
  relative = 'editor',
  x = 27,
  y = 2
  },

view2_action = {'open_file', string.format('%s/%s', root, 'welcome-screen2.lua')},


  view3 = {
  dual = false,
-- pin = 'bot',
  width = 0.8,
  height = 0.4,
  border = true,
  relative = 'editor',
  y = 4,
  },
view3_action = {'open_file', string.format('%s/%s', root, 'welcome-screen2.lua')},

 view4 = {
  dual = false,
 pin = 'bot',
  width = 0.5,
  height = 0.4,
  border = true,
  relative = 'editor',
  y = -6
  },
view4_action = {'open_file', string.format('%s/%s', root, 'welcome-screen2.lua')},
})

