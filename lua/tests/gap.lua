-- require'floating'.open({
--   view1 = 'single',
--   --view1_action = 'open_file'
--   view1_action = {'open_file', '/home/f1/.config/nvim/lua/asd12.lua'}
-- })

require'floating'.open({
  view1 = {
  dual = true,
 pin = 'bot',
 layout = 'horizontal',
  grow = true,
  width = 0.8,
  height = 0.4,
  border = true,
  --grow_max_height = 10,
 -- two_grow_max_height = 10,
--  two_grow = true,
--grow_direction = 'down',
-- content_height = true,
 -- two_content_height = true


  },
--  view1_action = {'it_ran', '/home/f1/.config/nvim/ginit.vim'},
--   view1_action = function(bufnr, winnr) 
-- local filepath = '/home/f1/.config/nvim/init.lua'
-- local filetype = filepath:match('.*%/.*%.(.*)$')
--      local file_contents = vim.fn.readfile(filepath)
--    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, file_contents)
--     vim.api.nvim_buf_set_option(bufnr, 'filetype', filetype)  

--   end,
view1_action = {'open_file', string.format('%s/%s', vim.fn.stdpath('config'), 'init.lua')}

})

