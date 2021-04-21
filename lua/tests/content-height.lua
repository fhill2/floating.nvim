local root = string.format('%s/%s/%s/%s/%s', vim.fn.stdpath('config'), 'plugins-me', 'floating.nvim', 'lua', 'tests')

require'floating'.open({
  view1 = {
  dual = true,
  width = 0.4,
  pin = 'bot',
  height = 0.7,
  border = true,
  relative = 'editor',
  content_height = false,
  two_content_height = true,
  style = false,
  title = 'content_height = false, height = 0.7',
  two_title = 'content_height = true, height overriden'
   },
view1_action = {'open_file', string.format('%s/%s', root, 'buf_content_height_1.lua')},
view1_two_action = {'open_file', string.format('%s/%s', root, 'buf_content_height_2.lua')},


})
































