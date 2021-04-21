local root = string.format('%s/%s/%s/%s/%s', vim.fn.stdpath('config'), 'plugins-me', 'floating.nvim', 'lua', 'tests')

require'floating'.open({
  view1 = {
  dual = true,
  layout = 'horizontal',
  width = 0.5,
  pin = 'bot',
  height = 0.5,
  gap = 1,
  border = true,
  margin = {6,6,6,6},
  relative = 'editor',
  style = 'minimal',
  title = 'split = 0.7',
  two_title = 'split = 0.7'
   },
 })
