local root = string.format('%s/%s/%s/%s/%s', vim.fn.stdpath('config'), 'plugins-me', 'floating.nvim', 'lua', 'tests')

require'floating'.open({
  view1 = {
  dual = true,
  layout = 'horizontal',
  width = 0.4,
  pin = 'bot',
  height = 0.3,
  gap = 0,
  border = true,
  relative = 'editor',
  style = 'minimal',
  title = 'gap = 0',
  two_title = 'gap = 0'
   },
 })

































