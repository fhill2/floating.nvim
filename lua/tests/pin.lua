require'floating'.open({
  view1 = {
  dual = true,
 pin = 'left',
 layout = 'vertical',
  width = 0.2,
  height = 0.5,
  border = true,
  relative = 'win',
  title = 'left win1',
  two_title = 'left win2'
   },

  view1_action = {'buf_write', '-- left' },
 view1_two_action = {'buf_write', '-- left'},


  view2 = {
  dual = true,
 pin = 'top',
 layout = 'horizontal',
  width = 0.5,
  height = 0.2,
  border = true,
  relative = 'win',
  title = 'top win1',
  two_title = 'top win2'
   },

  view2_action = {'buf_write', '-- top' },
 view2_two_action = {'buf_write', '-- top'},

  view3 = {
  dual = true,
 pin = 'right',
 layout = 'horizontal',
  width = 0.2,
  height = 0.5,
  border = true,
  relative = 'win',
  title = 'right win1',
  two_title = 'right win2'
   },

  view3_action = {'buf_write', '-- right' },
 view3_two_action = {'buf_write', '-- right'},

  view4 = {
  dual = true,
 pin = 'bot',
 layout = 'vertical',
  width = 0.5,
  height = 0.3,
  border = true,
  relative = 'win',
  title = 'bot win1',
  two_title = 'bot win2'
   },

  view4_action = {'buf_write', '-- bot' },
 view4_two_action = {'buf_write', '-- bot'},

  view5 = {
  dual = false,
 pin = 'topleft',
 layout = 'vertical',
  width = 0.2,
  height = 0.2,
  border = true,
  relative = 'win',
  title = 'topleft win1',
   },

  view5_action = {'buf_write', '-- topleft' },

  view6 = {
  dual = false,
 pin = 'topright',
 layout = 'vertical',
  width = 0.2,
  height = 0.2,
  border = true,
  relative = 'win',
  title = 'topright win1',
   },

  view6_action = {'buf_write', '-- topright' },


  view7 = {
  dual = false,
 pin = 'botright',
 layout = 'vertical',
  width = 0.2,
  height = 0.2,
  border = true,
  relative = 'win',
  title = 'botright win1',
   },

  view7_action = {'buf_write', '-- botright' },


  view8 = {
  dual = false,
 pin = 'botleft',
 layout = 'vertical',
  width = 0.2,
  height = 0.2,
  border = true,
  relative = 'win',
  title = 'botleft win1',
   },

  view8_action = {'buf_write', '-- botleft' },



  
})
