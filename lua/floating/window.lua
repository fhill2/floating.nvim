
local log = require'floating/log'
local utils = require "floating/utils"
local get_default = utils.get_default
local ternary = utils.ternary

local config = require "floating/config"



Window = {}
Window.__index = Window

function Window:new(opts)
  log.info('Window: new trig')
   opts = opts or {}

       setup_opts = vim.deepcopy(opts)

    -- ============================================= OPTS =================================================
    opts.margin = opts.margin or {}
    opts.two_margin = opts.two_margin or {}
  
    custom_opts = {
              title = get_default(opts.title, config.defaults.title), 
             x = get_default(opts.x, config.defaults.x), 
        y = get_default(opts.y, config.defaults.y), 
        layout = get_default(opts.layout, config.defaults.layout),
        pin = get_default(opts.pin, config.defaults.pin),        
        grow = get_default(opts.grow, config.defaults.grow), 
               max_height = get_default(opts.max_height, config.defaults.max_height), 
               grow_direction = get_default(opts.grow_direction, config.defaults.grow_direction),
           winblend = get_default(opts.winblend, config.defaults.winblend), 
        split = get_default(opts.split, config.defaults.split), 
        gap = get_default(opts.gap, config.defaults.gap), 
        content_height = get_default(opts.content_height, config.defaults.content_height), 
   
        enter = get_default(opts.enter, config.defaults.enter), 
        on_close = get_default(opts.on_close, config.defaults.on_close)
    }

    if vim.tbl_islist(opts.margin) then custom_opts.margin = { get_default(opts.margin.top, 1), get_default(opts.margin.right, 1), get_default(opts.margin.bottom, 1), get_default(opts.margin.left, 1) } end

    
    if not vim.tbl_islist(opts.margin) then custom_opts.margin = { top = get_default(opts.margin.top, 1), right = get_default(opts.margin.right, 1), bottom = get_default(opts.margin.bottom, 1), left = get_default(opts.margin.left, 1) } end

   
    -- TODO: VALIDATE BORDER OPTS and save back to custom_opts

       total_opts_init = { 
       width = get_default(opts.width, config.defaults.width), 
       height = get_default(opts.height, config.defaults.height), 
       relative = get_default(opts.relative, config.defaults.relative), 
       anchor = "NW" }

    local style = get_default(opts.style, config.defaults.style)
    if style then total_opts_init.style = "minimal" end

    if total_opts_init.relative == "win" then total_opts_init.win = vim.api.nvim_get_current_win() end

    assert(total_opts_init.width <= 1, "LTL ERROR: view width 0 - 1 number supported only")
    assert(total_opts_init.height <= 1, "LTL ERROR: view height 0 - 1 number supported only")
    assert(total_opts_init.width > 0, "LTL ERROR: view width needs to be 0 - 1 number")
    assert(total_opts_init.height > 0, "LTL ERROR: view height needs to be 0 - 1 number")

    setup_opts_pointer = tostring(setup_opts)

    return setmetatable({ 
      name = opts.name or setup_opts_pointer, 
      setup_opts = setup_opts, 
      setup_opts_pointer = setup_opts_pointer, 
      custom_opts = custom_opts, 
      state = { is_open = true }, 
      total_opts_init = total_opts_init, 
      actions = opts.actions ,
      exit_actions = opts.exit_actions
      }, self)


end


function Window:calculate()
  total_opts = vim.deepcopy(self.total_opts_init)
    custom_opts = self.custom_opts

    custom_opts.max_col = nil
    custom_opts.max_row = nil
    -- decide max_col, max_row dependant on win or global, for pin
    if total_opts_init.relative == "editor" then
        custom_opts.max_col = vim.o.columns
        custom_opts.max_row = vim.o.lines
    else
        custom_opts.max_col = vim.api.nvim_call_function("winwidth", { total_opts.win })
        custom_opts.max_row = vim.api.nvim_call_function("winheight", { total_opts.win })
    end

    -- always center
    local col_start_percentage = (1 - total_opts.width) / 2
    local row_start_percentage = (1 - total_opts.height) / 2

    total_opts.height = math.floor(custom_opts.max_row * total_opts.height)
    total_opts.width = math.floor(custom_opts.max_col * total_opts.width)
    total_opts.col = custom_opts.max_col * col_start_percentage
    total_opts.row = custom_opts.max_row * row_start_percentage

 local function apply_pin(colrow, total_opts, custom_opts)
        local function is_editor_scoped(total_opts)
            if total_opts.relative == "editor" then
                return true
            else
                return false
            end
        end

        if custom_opts.pin == nil then return false end

        local max_col, max_row = custom_opts.max_col, custom_opts.max_row
        local width, height = total_opts.width, total_opts.height

        local choose_pin = {
            top = ternary(colrow, false, ternary(is_editor_scoped(total_opts), 1, 0)), -- change to 1 if relative is editor, 0 if win
            topright = ternary(colrow, max_col - width, ternary(is_editor_scoped(total_opts), 1, 1)), right = ternary(colrow, max_col - width, false), botright = ternary(colrow, max_col - width, ternary(is_editor_scoped(total_opts), max_row - height - 2, max_row - height)), bot = ternary(colrow, false, ternary(is_editor_scoped(total_opts), max_row - height - 2, max_row - height)), -- -2 for vim.o.cmdheight and statusline
            botleft = ternary(colrow, 0, ternary(is_editor_scoped(total_opts), max_row - height - 2, max_row - height)), left = ternary(colrow, 0, false), topleft = ternary(colrow, 0, ternary(is_editor_scoped(total_opts), 1, 0))
        }
        return choose_pin[custom_opts.pin]
    end

    -- then apply pin
    if custom_opts.pin then
        total_opts.col = apply_pin(true, total_opts, custom_opts) or total_opts.col
        total_opts.row = apply_pin(false, total_opts, custom_opts) or total_opts.row
    end



    -- add offset
    total_opts.col = total_opts.col - custom_opts.x
    total_opts.row = total_opts.row + custom_opts.y


 self.total_opts = total_opts
    self.custom_opts = custom_opts


    

end


function Window:execute_exits()

  
    opts = { 
    self = self, 
    bufnr = self.bufnr, 
    winnr = self.winnr, 
  }

  vim.api.nvim_buf_call(self.bufnr, function() 
        
      
if type(self.exits) == 'table' then
    local contains_table = utils.contains_table(self.exits)

    if contains_table then
      for i, action in ipairs(self.exits) do 
      action[1](opts, action[2], action[3]) end 
      elseif not contains_table then
 self.exits[1](opts, self.exits[2], self.exits[3]) 
 end 
elseif type(self.exits) == 'function' then
 self.exits(opts) 
end


      end)
end -- end execute action




function Window:execute_actions()

  
    opts = { 
    self = self, 
    bufnr = self.bufnr, 
    winnr = self.winnr, 
  }

  vim.api.nvim_buf_call(self.bufnr, function() 
        
      
if type(self.actions) == 'table' then
    local contains_table = utils.contains_table(self.actions)

    if contains_table then
      for i, action in ipairs(self.actions) do 
      action[1](opts, action[2], action[3]) end 
      elseif not contains_table then
 self.actions[1](opts, self.actions[2], self.actions[3]) 
 end 
elseif type(self.actions) == 'function' then
 self.actions(opts) 
end

end)


end -- end execute action





function Window:open()
    log.info('Window:open trig')
        -- 1 create buf
       -- local contents_bufnr = self.bufnr
             if not self.bufnr then self.bufnr = vim.api.nvim_create_buf(false, true) end
             -- 2 create winnr
            
        if not self.winnr then
 self.total_opts.height = math.ceil(self.total_opts.height)
            self.winnr = vim.api.nvim_open_win(self.bufnr, false, self.total_opts)
          end
      
       
      --  vim.api.nvim_win_set_option(contents_winnr, "winblend", get_default(self.custom_opts.winblend, config.defaults.winblend))
        -- additional opts: silent lua require .... <buffer> ++nested


     --   local on_win_closed = string.format([[autocmd WinClosed <buffer=%s> ++once :lua require('floating/manager').close_view('', '%s')]], self.bufnr, self.name)



        -- opts for 
        --  opts = {win_self = self, bufnr = contents_bufnr, winnr = contents_winnr, one_two = one_two, single_dual = single_dual}
       -- log.info(self.bufnr)
   --    vim.defer_fn(function()
 --               local on_win_closed = string.format('autocmd WinClosed <buffer=%s> ++once ++nested :echo "hello world"', self.bufnr)
 --               log.info(self.bufnr)
 --           --vim.api.nvim_buf_call(self.bufnr, function() 
 --             vim.schedule_wrap(vim.cmd(on_win_closed))
                  
 --          --   end, 1000)


 --        if self.custom_opts.enter then
 -- vim.api.nvim_set_current_win(self.winnr)

        --  local on_win_closed = string.format([[  autocmd WinClosed <buffer=1> ++nested ++once :silent lua require('floating/window').on_win_closed('%s')]], self.name)


        -- --vim.api.nvim_buf_call(contents_bufnr, function() 
        --   vim.cmd(on_win_closed) 
        --end)

        log.info('AUTOCMD applied')
 self:execute_actions()
 --- APPLY AUTOCMD
 local bufnr = vim.api.nvim_win_get_buf(self.winnr)
 -- after actions, apply autocmd, as buffer might have been replaced 
  local on_win_closed = string.format([[  autocmd WinClosed <buffer=%s> ++nested ++once :silent lua require('floating/manager'):close_view('%s')]], bufnr, self.name)

     vim.cmd(on_win_closed) 
       
    
      end




return Window
