local root = string.format('%s/%s/%s/%s/%s', vim.fn.stdpath('config'), 'plugins-me', 'floating.nvim', 'lua', 'tests')

require'floating'.open({
  view1 = {
  dual = true,
  layout = 'vertical',
  width = 0.9,
  pin = 'bot',
  height = 0.5,
  gap = 1,
  border = true,
  split = 0.7,
  relative = 'editor',
  style = 'minimal',
  title = [[split=0.7,layout='vertical' ]],
  two_title = [[split=0.7,layout='vertical']]
   },
 })




































