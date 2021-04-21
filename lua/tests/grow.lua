local root = string.format('%s/%s/%s/%s/%s', vim.fn.stdpath('config'), 'plugins-me', 'floating.nvim', 'lua', 'tests')

require'floating'.open({
  view1 = {
 --  x = 30,
  dual = false,
  width = 0.4,
  pin = 'bot',
  height = 0.7,
  border = true,
  relative = 'editor',
  title = 'content_height = true',
 content_height = true,
   },
view1_action = {'open_file', string.format('%s/%s', root, '6lines.lua')},

})


































































