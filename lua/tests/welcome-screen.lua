local root = string.format('%s/%s/%s/%s/%s', vim.fn.stdpath('config'), 'plugins-me', 'floating.nvim', 'lua', 'tests')

require'floating'.open({
  view1 = {
  dual = false,
 pin = 'top',
 layout = 'horizontal',
 split = 0.7,
  width = 0.9,
  height = 0.2,
  border = true,
  relative = 'win',
  title = 'a highly',
--y = 9,
--x = 30
  },
view1_action = {'open_file', string.format('%s/%s', root, 'welcome.txt')},


  view2 = {
  dual = false,
 pin = 'top',
 layout = 'horizontal',
  width = 0.4,
  height = 0.2,
  border = true,
  relative = 'win',
  title = 'configurable',
-- x = -30,
 y = 15
  },

view2_action = {'open_file', string.format('%s/%s', root, 'to.txt')},


  view3 = {
  dual = false,
  pin = 'right',
  width = 1,
  height = 0.2,
  border = true,
  relative = 'win',
  title = 'floating window',
 y = 2,
  },
view3_action = {'open_file', string.format('%s/%s', root, 'floating.txt')},

 view4 = {
  dual = false,
 pin = 'bot',
  width = 0.6,
  height = 0.2,
  border = true,
  relative = 'win',
-- y = -13,
  title = 'manager',
  },
view4_action = {'open_file', string.format('%s/%s', root, 'nvim.txt')},
})









