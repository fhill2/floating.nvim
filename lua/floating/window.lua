local windows = {}

local utils = require "floating/utils"
local get_default = utils.get_default
local ternary = utils.ternary

local config = require "floating/config"

local Border = require "floating/border"

local state = require "floating/state"

local Window = {}
Window.__index = Window

function Window:new(opts)
    opts = opts or {}

    --- ============= TOGGLE WALL/BLOCK ===============
    setup_opts = vim.deepcopy(opts)

    -- ============================================= OPTS =================================================
    -- otherwise obj & log padding get_defaults nil error
    opts.margin = opts.margin or {}
    opts.two_margin = opts.two_margin or {}

    actions = {action = opts.action, two_action = opts.two_action}

    custom_opts = {
        border = get_default(opts.border, config.defaults.border),
        border_thickness = get_default(opts.border_thickness, config.defaults.border_thickness),
        borderchars = get_default(opts.borderchars, config.defaults.borderchars),
        title = get_default(opts.title, config.defaults.title),
        two_title = get_default(opts.two_title, config.defaults.two_title),
        x = get_default(opts.x, config.defaults.x),
        y = get_default(opts.y, config.defaults.y),
        layout = get_default(opts.layout, config.defaults.layout),
        pin = get_default(opts.pin, config.defaults.pin),
        dual = get_default(opts.dual, config.defaults.dual),
        grow = get_default(opts.grow, config.defaults.grow),
        two_grow = get_default(opts.two_grow, config.defaults.two_grow),
        max_height = get_default(opts.max_height, config.defaults.max_height),
        two_max_height = get_default(opts.two_max_height, config.defaults.two_max_height),
        grow_direction = get_default(opts.grow_direction, config.defaults.grow_direction),
        -- two_grow_direction = get_default(opts.two_grow_direction, config.defaults.two_grow_direction),
        winblend = get_default(opts.winblend, config.defaults.winblend),
        split = get_default(opts.split, config.defaults.split),
        gap = get_default(opts.gap, config.defaults.gap),
        content_height = get_default(opts.content_height, config.defaults.content_height),
        two_content_height = get_default(opts.two_content_height, config.defaults.two_content_height),
        enter = get_default(opts.enter, config.defaults.enter)
    }

    if vim.tbl_islist(opts.margin) then custom_opts.margin = {get_default(opts.margin.top, 1), get_default(opts.margin.right, 1), get_default(opts.margin.bottom, 1), get_default(opts.margin.left, 1)} end

    if vim.tbl_islist(opts.two_margin) then custom_opts.two_margin = {get_default(opts.two_margin.top, 1), get_default(opts.two_margin.right, 1), get_default(opts.two_margin.bottom, 1), get_default(opts.two_margin.left, 1)} end

    if not vim.tbl_islist(opts.margin) then custom_opts.margin = {top = get_default(opts.margin.top, 1), right = get_default(opts.margin.right, 1), bottom = get_default(opts.margin.bottom, 1), left = get_default(opts.margin.left, 1)} end

    if not vim.tbl_islist(opts.two_margin) then
        custom_opts.two_margin = {top = get_default(opts.two_margin.top, 1), right = get_default(opts.two_margin.right, 1), bottom = get_default(opts.two_margin.bottom, 1), left = get_default(opts.two_margin.left, 1)}
    end

    -- TODO: VALIDATE BORDER OPTS and save back to custom_opts

    local border_default_thickness = {top = 1, right = 1, bot = 1, left = 1}
    local border_options = {}

    if custom_opts.border then
        if type(custom_opts.border_thickness) == "boolean" or vim.tbl_isempty(custom_opts.border_thickness) then
            border_options.border_thickness = border_default_thickness
        elseif #custom_opts.border_thickness == 4 then
            border_options.border_thickness = {
                top = utils.bounded(custom_opts.border_thickness[1], 0, 1),
                right = utils.bounded(custom_opts.border_thickness[2], 0, 1),
                bot = utils.bounded(custom_opts.border_thickness[3], 0, 1),
                left = utils.bounded(custom_opts.border_thickness[4], 0, 1)
            }
        end
    end

    local b_top, b_right, b_bot, b_left, b_topleft, b_topright, b_botright, b_botleft
    if custom_opts.borderchars == nil then
        b_top, b_right, b_bot, b_left, b_topleft, b_topright, b_botright, b_botleft = "═", "║", "═", "║", "╔", "╗", "╝", "╚"
    elseif #custom_opts.borderchars == 1 then
        local b_char = custom_opts.borderchars[1]
        b_top, b_right, b_bot, b_left, b_topleft, b_topright, b_botright, b_botleft = b_char, b_char, b_char, b_char, b_char, b_char, b_char, b_char
    elseif #custom_opts.borderchars == 2 then
        local b_char = custom_opts.borderchars[1]
        local c_char = custom_opts.borderchars[2]
        b_top, b_right, b_bot, b_left, b_topleft, b_topright, b_botright, b_botleft = b_char, b_char, b_char, b_char, c_char, c_char, c_char, c_char
    elseif #custom_opts.borderchars == 8 then
        b_top, b_right, b_bot, b_left, b_topleft, b_topright, b_botright, b_botleft = unpack(custom_opts.borderchars)
    else
        error(string.format('Not enough arguments for "borderchars"'))
    end

    border_options.top = b_top
    border_options.bot = b_bot
    border_options.right = b_right
    border_options.left = b_left
    border_options.topleft = b_topleft
    border_options.topright = b_topright
    border_options.botright = b_botright
    border_options.botleft = b_botleft

    custom_opts.borderchars = border_options.borderchars
    custom_opts.border_thickness = border_options.border_thickness

    one_border_opts = vim.tbl_extend("keep", border_options, {title = get_default(opts.title, config.defaults.title)})
    two_border_opts = vim.tbl_extend("keep", border_options, {title = get_default(opts.two_title, config.defaults.two_title)})

    total_opts_init = {width = get_default(opts.width, config.defaults.width), height = get_default(opts.height, config.defaults.height), relative = get_default(opts.relative, config.defaults.relative), anchor = "NW"}

    local style = get_default(opts.style, config.defaults.style)
    if style then total_opts_init.style = "minimal" end

    if total_opts_init.relative == "win" then total_opts_init.win = vim.api.nvim_get_current_win() end

    assert(total_opts_init.width <= 1, "LTL ERROR: view width 0 - 1 number supported only")
    assert(total_opts_init.height <= 1, "LTL ERROR: view height 0 - 1 number supported only")
    assert(total_opts_init.width > 0, "LTL ERROR: view width needs to be 0 - 1 number")
    assert(total_opts_init.height > 0, "LTL ERROR: view height needs to be 0 - 1 number")

    local border
    if custom_opts.border then border = Border:new() end

    return setmetatable({
        setup_opts = setup_opts,
        setup_opts_pointer = tostring(setup_opts),
        one_border_opts = one_border_opts,
        two_border_opts = two_border_opts,
        custom_opts = custom_opts,
        border = border,
        total_opts_init = total_opts_init,
        actions = actions
    }, self)
end

function Window:calculate(win_self)
    if win_self then win_self = self end

    total_opts = vim.deepcopy(self.total_opts_init)
    custom_opts = self.custom_opts

    custom_opts.max_col = nil
    custom_opts.max_row = nil
    -- decide max_col, max_row dependant on win or global, for pin
    if total_opts_init.relative == "editor" then
        custom_opts.max_col = vim.o.columns
        custom_opts.max_row = vim.o.lines
    else
        custom_opts.max_col = vim.api.nvim_call_function("winwidth", {total_opts.win})
        custom_opts.max_row = vim.api.nvim_call_function("winheight", {total_opts.win})
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
            topright = ternary(colrow, max_col - width, ternary(is_editor_scoped(total_opts), 1, 1)),
            right = ternary(colrow, max_col - width, false),
            botright = ternary(colrow, max_col - width, ternary(is_editor_scoped(total_opts), max_row - height - 2, max_row - height)),
            bot = ternary(colrow, false, ternary(is_editor_scoped(total_opts), max_row - height - 2, max_row - height)), -- -2 for vim.o.cmdheight and statusline
            botleft = ternary(colrow, 0, ternary(is_editor_scoped(total_opts), max_row - height - 2, max_row - height)),
            left = ternary(colrow, 0, false),
            topleft = ternary(colrow, 0, ternary(is_editor_scoped(total_opts), 1, 0))
        }
        return choose_pin[custom_opts.pin]
    end

    -- then apply pin
    if custom_opts.pin then
        total_opts.col = apply_pin(true, total_opts, custom_opts) or total_opts.col
        total_opts.row = apply_pin(false, total_opts, custom_opts) or total_opts.row
    end

    -- TODO: convert xy offset in % to col/row count
    -- custom_opts.x = custom_opts.max_col * custom_opts.x
    -- custom_opts.y = custom_opts.max_row * custom_opts.y

    -- add offset
    total_opts.col = total_opts.col - custom_opts.x
    total_opts.row = total_opts.row + custom_opts.y

    ---  =========================== SPLIT WINDOWS HERE =============================
    if custom_opts.dual == true then
        -- everything in this condition only applies to opening 2 windows at once

        local layout_bool
        if custom_opts.layout == "horizontal" then
            layout_bool = true
        elseif custom_opts.layout == "vertical" then
            layout_bool = false
        end

        -- create each individual window options
        local function create_window_opts(total_opts, custom_opts, one_two, layout_bool)
            local total_opts = vim.deepcopy(total_opts) -- important

            total_opts.col = math.floor(ternary(one_two, ternary(layout_bool, total_opts.col, total_opts.col), ternary(layout_bool, total_opts.col + total_opts.width / 2, total_opts.col)))
            total_opts.row = math.floor(ternary(one_two, ternary(layout_bool, total_opts.row, total_opts.row), ternary(layout_bool, total_opts.row, total_opts.row + total_opts.height / 2)))
            total_opts.width = math.floor(ternary(one_two, ternary(layout_bool, total_opts.width / 2, total_opts.width), ternary(layout_bool, total_opts.width / 2, total_opts.width)))
            total_opts.height = math.floor(ternary(one_two, ternary(layout_bool, total_opts.height, total_opts.height / 2), ternary(layout_bool, total_opts.height, total_opts.height / 2)))
            return total_opts
        end

        -- windows are split here
        one_opts = create_window_opts(total_opts, custom_opts, true, layout_bool)
        if custom_opts.dual == true then two_opts = create_window_opts(total_opts, custom_opts, false, layout_bool) end

        if total_opts.relative == "win" then one_opts.win = total_opts.win end
        if total_opts.relative == "win" and two_opts then two_opts.win = total_opts.win end

        local gap_bool
        if custom_opts.gap > 0 then
            gap_bool = true
        else
            gap_bool = false
        end

        -- add gap
        if layout_bool and gap_bool then
            one_opts.width = one_opts.width - custom_opts.gap
        elseif gap_bool then
            two_opts.height = two_opts.height - custom_opts.gap
        end

        -- add split %
        local distance = 0.5 - custom_opts.split

        if custom_opts.layout == "horizontal" then
            local col_to_move = math.floor(total_opts.width * distance)
            one_opts.width = one_opts.width - col_to_move
            if custom_opts.dual == true then
                two_opts.col = two_opts.col - col_to_move
                two_opts.width = two_opts.width + col_to_move
            end
        else
            local row_to_move = math.floor(total_opts.height * distance)
            one_opts.height = one_opts.height - row_to_move
            if custom_opts.dual == true then
                two_opts.row = two_opts.row - row_to_move
                two_opts.height = two_opts.height + row_to_move
            end
        end
    end -- end if multiple windows

    local function apply_margin(win_opts, custom_opts, one_two)
        local one_two_margin
        if one_two == "one" then
            one_two_margin = custom_opts.margin
        elseif one_two == "two" then
            one_two_margin = custom_opts.two_margin
        end

        local padding = {}
        if not vim.tbl_islist(one_two_margin) then
            table.insert(margin, one_two_margin.top)
            table.insert(margin, one_two_margin.right)
            table.insert(margin, one_two_margin.bottom)
            table.insert(margin, one_two_margin.left)
        else
            margin = one_two_margin
        end

        -- anchor decides if the padding side has to be moved or not
        -- top
        win_opts.row = win_opts.row + margin[1]
        win_opts.height = win_opts.height - margin[1]
        -- left
        win_opts.col = win_opts.col + margin[2]
        win_opts.width = win_opts.width - margin[2]
        -- bottom
        win_opts.height = win_opts.height - margin[3]
        -- right
        win_opts.width = win_opts.width - margin[4]

        return win_opts
    end

    if custom_opts.dual == true then
        one_opts = apply_margin(one_opts, custom_opts, "one")
        two_opts = apply_margin(two_opts, custom_opts, "two")
    elseif custom_opts.dual == false then
        total_opts = apply_margin(total_opts, custom_opts, "one")
    end

    if custom_opts.dual == true then
        self.one_opts = one_opts
        self.two_opts = two_opts
    end
    self.total_opts = total_opts
    self.custom_opts = custom_opts
    -- end calculate
end

function Window:refresh_win_dimensions(win_self)
    if win_self.total_opts_init.relative == "win" then
        win_self.custom_opts.max_col = vim.api.nvim_call_function("winwidth", {win_self.total_opts_init.win})

        win_self.custom_opts.max_row = vim.api.nvim_call_function("winheight", {win_self.total_opts_init.win})
    end
end

function Window:resize_all(win_self)
    -- if win_self then win_self = self end

    win_self.calculate(win_self)

    if win_self.custom_opts.border then win_self.border:redraw_all(win_self) end

    if win_self.custom_opts.dual == false then
        vim.api.nvim_win_set_config(win_self.winnr.one_content, win_self.total_opts)
    elseif self.custom_opts.dual == true then
        vim.api.nvim_win_set_config(win_self.winnr.one_content, win_self.one_opts)
        vim.api.nvim_win_set_config(win_self.winnr.two_content, win_self.two_opts)
    end
end

function Window:resize_to_height(win_self, one_two, single_dual)
    local buf_contents = vim.api.nvim_buf_get_lines(win_self.bufnr[one_two .. "_content"], 0, -1, false)
    line_count = #buf_contents + 2

    local max_height
    if one_two == "one" then
        max_height = win_self.custom_opts.max_height
        opts_direction = win_self.custom_opts.grow_direction
    else
        max_height = win_self.custom_opts.two_max_height
    end
    -- limit by max height
    if line_count > max_height then line_count = max_height end

    local other_win
    if one_two == "one" then
        other_win = "two"
    else
        other_win = "one"
    end

    local height_to_move, current_opts, other_win_opts, other_content_winnr, content_winnr
    if single_dual == true then
        current_opts = win_self.total_opts
    elseif single_dual == false then
        current_opts = win_self[one_two .. "_opts"]

        other_win_opts = win_self[other_win .. "_opts"]

        other_content_winnr = win_self.winnr[other_win .. "_content"]
    end

    content_winnr = win_self.winnr[one_two .. "_content"]

    height_to_move = current_opts.height - line_count

    --- OPTS above here

    local pin = win_self.custom_opts.pin

    height_col = {top = "down", topright = "down", right = "down", botright = "up", bot = "up", botleft = "up", left = "down", topleft = "down", nopin = "nopin"}

    local direction = height_col[pin]

    opts_direction = win_self.custom_opts.grow_direction

    if direction == nil then
        if type(opts_direction) == "string" and opts_direction ~= false then
            direction = opts_direction
        else
            win_self:refresh_win_dimensions(win_self)
            if win_self.total_opts.row > win_self.custom_opts.max_row / 2 then
                direction = "up"
            else
                direction = "down"
            end
        end
    end

    -- single window top side pins
    if direction == "down" then
        current_opts.height = line_count

        if one_two == "one" and single_dual == false and win_self.custom_opts.layout ~= "horizontal" then
            other_win_opts.row = other_win_opts.row - height_to_move
            vim.api.nvim_win_set_config(other_content_winnr, other_win_opts)
            if win_self.custom_opts.border then win_self.border:redraw_single(win_self, other_win, single_dual, other_win_opts) end
        end
    end

    -- single window bot pins
    if direction == "up" then
        current_opts.row = current_opts.row + height_to_move
        current_opts.height = line_count
        if one_two == "two" and single_dual == false and win_self.custom_opts.layout ~= "horizontal" then
            other_win_opts.row = other_win_opts.row + height_to_move

            vim.api.nvim_win_set_config(other_content_winnr, other_win_opts)
            if win_self.custom_opts.border then win_self.border:redraw_single(win_self, other_win, single_dual, other_win_opts) end
        end
    end

    vim.api.nvim_win_set_config(content_winnr, current_opts)

    if win_self.custom_opts.border then win_self.border:redraw_single(win_self, one_two, single_dual, current_opts) end
end

function Window:open()
    local function open_window(one_two, single_dual)
        local border_opts = self[one_two .. "_border_opts"]

        -- 1 create contents buf
        local contents_bufnr = vim.api.nvim_create_buf(false, true)
        self.bufnr[one_two .. "_content"] = contents_bufnr
    

      

        -- 2 create contents winnr
        local contents_winnr
        if single_dual == false then
 self[one_two .. '_opts'].height = math.ceil(self[one_two .. '_opts'].height)

                      contents_winnr = vim.api.nvim_open_win(contents_bufnr, false, self[one_two .. "_opts"])
        elseif single_dual == true then
          self.total_opts.height = math.ceil(self.total_opts.height)
            contents_winnr = vim.api.nvim_open_win(contents_bufnr, false, self.total_opts)
        end

        -- 3 name it
        local name
        if self.total_opts.relative == "win" then
            name = string.format("%s_%s", contents_winnr, contents_bufnr)
        elseif self.total_opts.relative == "editor" then
            name = "global_" .. contents_bufnr
        end
        self.name = name

        if self.custom_opts.border then self.border:open_single(self, one_two, single_dual) end

        self.winnr[one_two .. "_content"] = contents_winnr

        vim.api.nvim_win_set_option(contents_winnr, "winblend", get_default(self.custom_opts.winblend, config.defaults.winblend))

        local on_win_closed = string.format([[  autocmd WinClosed <buffer> ++nested ++once :silent lua require('floating/window').on_win_closed('%s')]], self.setup_opts_pointer)

        vim.api.nvim_buf_call(contents_bufnr, function()
            vim.cmd(on_win_closed)

            local action
            if one_two == "one" then
                action = actions.action
            else
                action = actions.two_action
            end

            if type(action) == "table" then
                if config.user_action_presets[action[1]] then
                    config.user_action_presets[action[1]](contents_bufnr, contents_winnr, action[2], action[3])
                elseif config.default_action_presets[action[1]] then
                    config.default_action_presets[action[1]](contents_bufnr, contents_winnr, action[2], action[3])
                else
                    assert(false, "action not found in action preset table. Add action inside config action_presets table underneath defaults.")
                end
            elseif type(action) == "function" then
                action(contents_bufnr, contents_winnr)
            end
        end)

        local function buf_attach(self, one_two, single_dual)
            local contents_bufnr = self.bufnr[one_two .. "_content"]

            vim.api.nvim_buf_attach(contents_bufnr, false, {on_lines = function() Window:resize_to_height(self, one_two, single_dual) end})
        end

        if one_two == "one" and self.custom_opts.grow == true then buf_attach(self, "one", single_dual) end
        if one_two == "two" and self.custom_opts.two_grow == true then buf_attach(self, "two", single_dual) end
    end

    self.bufnr = {}
    self.winnr = {}

    if self.custom_opts.dual then
        open_window("one", false)
        open_window("two", false)
    else
        open_window("one", true)
    end

    local enter = self.custom_opts.enter
    if type(enter) == "boolean" and enter == true then
        vim.api.nvim_set_current_win(self.winnr.one_win)
    elseif type(enter) == "string" and enter == "one" then
        vim.api.nvim_set_current_win(self.winnr.one_win)
    elseif type(enter) == "string" and enter == "two" and self.custom_opts.dual then
        vim.api.nvim_set_current_win(self.winnr.two_win)
    end

    -- on window open resize height to content height
    if custom_opts.content_height == true and custom_opts.dual == false then self:resize_to_height(self, "one", true) end
    if custom_opts.content_height == true and custom_opts.dual == true then self:resize_to_height(self, "one", false) end
    if custom_opts.two_content_height == true and custom_opts.dual == true then self:resize_to_height(self, "two", false) end
end

function windows.open(opts)
    opts = opts or {}

    local view_in_keys = {}
    -- 1 replace view1 = 'string' with its table from config - ui/view presets
    for k, v in pairs(opts or {}) do
        if k:find("^view[%d]*$") then
            table.insert(view_in_keys, k)
            if type(v) == "string" then
                assert(config.view_presets[v], "view preset not found in config")
                opts[k] = config.view_presets[v]
            end
        end
    end

    for _, view in ipairs(view_in_keys) do
        assert(type(opts[view]) == "table", "opts...view1..not a table")

        opts[view].action = opts[view .. "_action"]
        opts[view].two_action = opts[view .. "_two_action"]

        local toggle = get_default(opts[view].toggle, config.defaults.toggle)
        if toggle then
            for k, v in pairs(state.views) do
                if vim.inspect(opts[view]) == vim.inspect(v.setup_opts) then
                    windows.close_single_view(state.views[k])
                    return
                end
            end
        end

        local current_window = Window:new(opts[view] or {})
        current_window:calculate()
        current_window:open()

        state.views[current_window.setup_opts_pointer] = current_window
        state.recent = current_window
    end

    -- unfortunately timer is needed due to no winresized event, but its coming soon
    -- https://github.com/neovim/neovim/pull/13589
    if not state.timer_enabled then
        local timer = vim.loop.new_timer()
        state.timer = timer
        timer:start(1000, 1000, vim.schedule_wrap(function()
            if vim.tbl_isempty(state.views) then
                timer:stop()
                return
            end
            -- 1 for window local floating windows, iterate windows and find their corresponding attached main windows

            local windows_to_monitor = {}
            for k, v in pairs(state.views) do
                if v.total_opts.relative == "win" then
                    local current_window = k

                    local old_max_col = vim.deepcopy(v.custom_opts.max_col)
                    local old_max_row = vim.deepcopy(v.custom_opts.max_row)

                    state.views[k]:refresh_win_dimensions(state.views[k])

                    if old_max_col ~= v.custom_opts.max_col or old_max_row ~= v.custom_opts.max_row then state.views[k]:resize_all(state.views[k]) end
                end
            end
        end))
    end
end

function windows.close_all_views() for _, v in pairs(state.views) do if vim.api.nvim_win_is_valid(v.winnr.one_content) then vim.api.nvim_win_close(v.winnr.one_content, false) end end end

function windows.close_single_view(win_self)
    for k, v in pairs(win_self.winnr) do if vim.api.nvim_win_is_valid(v) then vim.api.nvim_win_close(v, false) end end

    if state.recent == win_self then state.recent = {} end
    state.views[win_self.setup_opts_pointer] = nil

    if vim.tbl_isempty(state.views) then
        state.timer:stop()
        return
    end
end

function windows.on_win_closed(setup_opts_pointer) windows.close_single_view(state.views[setup_opts_pointer]) end

function Window:focus() end

windows._Window = Window

return windows
