
function foo ()
      
      if unexpected_condition then error('this is a string') end
        
      print(a[i])    -- potential error: `a' may not be a table
        
    end

local status, err = pcall(foo) 


-- if pcall(foo) then
--       -- no errors while running `foo'
--       lo('no errors')
--     else
--       -- `foo' raised an error: take appropriate actions
--       lo('errors')
--     end

print(err)

local popup_opts =  {
col = 0,
row = 0,
width = 50,
height = 10,
relative = 'win',
style = 'minimal',
anchor = 'NW',
win = vim.api.nvim_get_current_win(),
}

local bufnr = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {err})
local winnr = vim.api.nvim_open_win(bufnr, false, popup_opts)


print('this still ran')

