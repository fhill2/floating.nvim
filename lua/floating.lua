local floating = {}
local window = require'floating/window'
local config = require'floating/config'
local Manager = require'floating/manager'




function floating.open(opts)
  -- validate and deconstruct input
 opts = opts or {}

 local view_in_keys = {}
    -- 1 replace view1 = 'string' with its table from config - ui/view presets
    for k, v in pairs(opts or {}) do
        if k:find("^view[%d]*$") then
            table.insert(view_in_keys, k)
            if v[2] == nil and type(v) == 'string' then
                opts[k] = config.get_preset(v, 'views', false)
            elseif v[2] == nil and type(v) == 'table' then
                if not vim.tbl_isempty(v) and vim.tbl_islist(v) then assert(false, 'input opts must be kv pairs') end
                -- continue 
            elseif v[2] ~= nil and type(v[1]) == 'string' and type(v[2]) == 'table' then
                if not vim.tbl_isempty(v[2]) and vim.tbl_islist(v[2]) then assert(false, 'input opts to merge with preset must be kv pairs') end
                opts[k] = config.get_preset(v[1], 'views', true, v[2])
            else
                assert(false, [[opts has to be: {opts} or {'view_preset', {}}]])
            end

        elseif k:find("^view[%d]*[_two]*_action$") or k:find("^view[%d]*[_two]*_exit_action$") then
            -- 2 replace view1_action or view_exit_action with their preset functions and format to all tables
            if type(v) == 'table' then
                local actions_exits = 'actions'
                if k:find('exit') then actions_exits = 'exits' end

                local contains_table = false
                local contains_string = false
                for i, action in ipairs(v) do
                    if type(action) == 'table' then contains_table = true end
                    if type(action) == 'string' then contains_string = true end
                end

                if contains_table and contains_string then assert(false, [[incorrect syntax for action: either all strings or tables: {'','',''} or  {{}, {}, {}}]]) end

                if not contains_table and contains_string then
                    v[1] = config.get_preset(v[1], actions_exits, nil, nil)
                    v = { v } 
                elseif contains_table and not contains_string then

                    for i, action in ipairs(v) do
                        if type(action) == 'table' then
                            action[1] = config.get_preset(action[1], actions_exits, nil, nil)
                        elseif type(action) == 'function' then
                            v[i] = { action }
                        end
                    end
                end
            elseif type(v) == 'function' then
                v = { { v } }
            end

        end
      end

    Manager:open(opts, view_in_keys)

end


function floating.close_all()
  Manager:close_all_views()
end

function floating.focus_cycle()
Manager:focus_cycle()
end

function floating.focus()
Manager:focus()
end

return {
  open = floating.open,
  setup = config.setup,
  close_all = floating.close_all,
  focus = floating.focus,
  focus_cycle = floating.focus_cycle,
}

