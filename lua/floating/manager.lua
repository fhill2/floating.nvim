local Manager = {}


local log = require'floating/log'


local utils = require "floating/utils"
local get_default = utils.get_default
local ternary = utils.ternary

local config = require'floating/config'
local Window = require'floating/window'



Manager.views = {}
Manager.recent = {}


function Manager:open(opts, view_in_keys)
        log.info('=========== RERUN ==============')
        log.info('manager open trig') 
        local current_window
--log.info('view_in_keys is: ')
--log.info(view_in_keys)

    for _, view in ipairs(view_in_keys) do

        opts[view].actions = opts[view .. "_action"]
              opts[view].exit_actions = opts[view .. '_exit_action']
      

 --- ============= TOGGLE BLOCK ===============

        local toggle = get_default(opts[view].toggle, config.defaults.toggle)


                      -- only enters this block if a manager config is matched with open() input
            for name, v in pairs(self.views) do
              if vim.inspect(opts[view]) == vim.inspect(v.setup_opts) then
                  log.info('MATCHED EXISTING CONFIG: ' .. name .. ' ---> entering toggle block') 

                  if self.views[name].state.is_open then
                    
                    if toggle then 
                        log.info('is_open=true, toggle=true ---> closing window')
                        self:close_view(name)
                    else 
                        log.info('is_open=true, toggle=false ---> executing actions ONLY')
                        self.views[name]:execute_actions()

                      end
                        return self.views[name] 


                    elseif not self.views[name].state.is_open then
                      log.info('is_open=false ---> reopening window')
                        self.views[name].state.is_open = true
                        self.views[name]:calculate()
                        self.views[name]:open()
                          return
                      end
                    end
                  end
                              
---- ================ END TOGGLE BLOCK ============
      -- ONLY new windows that arent already in manager
        log.info('NEW WINDOW')

        current_window = Window:new(opts[view] or {})
        local where = self:_main_or_floating_cwinnr()
        if where == 'main' then self.last_main_window = vim.api.nvim_get_current_win() end
     
        current_window:calculate()
        current_window:open()
      
        self.views[current_window.name] = current_window
        self.recent = current_window

    return current_window
end
end



function Manager:close_all_views()
      for k, v in pairs(self.views) do self:close_view(v.name) end
end



function Manager:close_view(name)
  log.info('close view ran')
  log.info('NAME IS: ')
  log.info(name)
  
  -- if not called from autocmd and not manager, iterate to find self from name
    self.views[name]:execute_exits()
   self.views[name].state.is_open = false


    
   
    -- 1 close windows (run for 'buffers' and 'windows')
           if vim.api.nvim_win_is_valid(self.views[name].winnr) then
            vim.api.nvim_win_close(self.views[name].winnr, false)
            self.views[name].winnr = nil
        end
    
 
    if self.recent == self then self.recent = {} end

    if self.views[name].custom_opts.on_close == 'buffers' then
        -- close content buffer only if told to   
        if self.views[name].bufnr and vim.api.nvim_buf_is_valid(self.views[name].bufnr) then vim.api.nvim_buf_close(self.views[name].bufnr, false) end
      
        -- delete object 
        self.views[name] = nil
   -- log.info(self.views[name])
      end

    -- if vim.tbl_isempty(state.views) then
    --     state.timer:stop()
    --     return
    -- end
end

-- function Manager.on_win_closed(name) self:close_view(state.views[name]) end

function Manager:_get_all_floating_winnr()
    local all_floating_windows = {}
    for view, opt in pairs(self.views) do
        if opt.winnr then table.insert(all_floating_windows, opt.winnr) end
         end
    return all_floating_windows
end

function Manager:_main_or_floating_cwinnr()

    local all_floating_windows = self:_get_all_floating_winnr()
    local current_winnr = vim.api.nvim_get_current_win()

    local where = 'main'
    for i, winnr in ipairs(all_floating_windows) do if winnr == current_winnr then where = 'floating' end end
    return where
end

function Manager:focus(name, toggle)

    if not one_two then one_two = 'one' end
    if name then
        assert(self.views[name], 'name not found in views. Make sure passed in name equals a unique name you specified when opening window in view table')
        named_winnr = self.views[name].winnr
    end

    recent_winnr = self.recent.winnr

    local all_floating_windows = self:_get_all_floating_winnr()
    local where = self:_main_or_floating_cwinnr()

    if where == 'main' then self.last_main_window = vim.api.nvim_get_current_win() end

    if where == 'floating' then
        if last_focused_name == name then
            vim.api.nvim_set_current_win(self.last_main_window)
        else
            vim.api.nvim_set_current_win(named_winnr)
        end
    elseif where == 'main' then
        if not name then
            vim.api.nvim_set_current_win(recent_winnr)
        else
            vim.api.nvim_set_current_win(named_winnr)
        end

    end

    last_focused_name = name

end

function Manager:focus_cycle(next_prev)

    if not next_prev then next_prev = 'next' end

    local inc_dec
    if next_prev == 'next' then
        inc_dec = 1
    elseif next_prev == 'prev' then
        inc_dec = -1
    end

    local all_floating_windows = self:_get_all_floating_winnr()
    log.info(all_floating_windows)
    table.sort(all_floating_windows, function(a, b) return a < b end)

    local where = self:_main_or_floating_cwinnr()
    log.info(where)

    local cwinnr = vim.api.nvim_get_current_win()
    log.info(cwinnr)
    if where == 'floating' then
        local start_index
        for i, winnr in ipairs(all_floating_windows) do 
          if cwinnr == winnr then start_index = i + inc_dec end end

        -- cycle if start_index is out of bounds
        if start_index == #all_floating_windows + 1 then
            start_index = 1
        elseif start_index == 0 then
            start_index = #all_floating_windows
        end

        vim.api.nvim_set_current_win(all_floating_windows[start_index])

    elseif where == 'main' then
        local start_index = 1
        vim.api.nvim_set_current_win(all_floating_windows[start_index])
    end

end


Manager.__index = Manager

return Manager
