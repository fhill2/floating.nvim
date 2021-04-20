local root = string.format('%s/%s/%s/%s/%s', vim.fn.stdpath('config'), 'plugins-me', 'floating.nvim', 'lua', 'tests')

require'floating'.open({
  view1 = {
  dual = false,
 pin = 'top',
 layout = 'horizontal',
 split = 0.7,
  width = 0.6,
  height = 0.2,
  border = true,
  relative = 'editor',
  title = 'a highly',
y = 9,
x = 30
  },
view1_action = {'open_file', string.format('%s/%s', root, 'welcome.txt')},


  view2 = {
  dual = false,
 pin = 'topright',
 layout = 'horizontal',
-- split = 0.7,
  width = 0.2,
  height = 0.2,
  border = true,
  relative = 'editor',
  title = 'configurable',
  x = 27,
  y = 9
  },

view2_action = {'open_file', string.format('%s/%s', root, 'to.txt')},


  view3 = {
  dual = false,
-- pin = 'bot',
  width = 0.7,
  height = 0.2,
  border = true,
  relative = 'editor',
  title = 'floating window',
  y = -2,
  },
view3_action = {'open_file', string.format('%s/%s', root, 'floating.txt')},

 view4 = {
  dual = false,
 pin = 'bot',
  width = 0.5,
  height = 0.2,
  border = true,
  relative = 'editor',
  y = -13,
  title = 'manager',
  },
view4_action = {'open_file', string.format('%s/%s', root, 'nvim.txt')},
})









