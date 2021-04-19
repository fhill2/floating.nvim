

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
  --grow_max_height = 10,
 -- two_grow_max_height = 10,
--  two_grow = true,
--grow_direction = 'down',
-- content_height = true,
 -- two_content_height = true


  },
  --view1_action = 'open_file'
  view1_action = {'open_file', '/home/f1/.config/nvim/ginit.vim'}
})









