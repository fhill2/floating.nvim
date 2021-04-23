-- MODIFIED VERSION of plenary/window/border
-- https://github.com/nvim-lua/plenary.nvim
-- modified to implement border resizing without having to open/close window

local Border = {}

Border.__index = Border

function Border._create_lines(content_win_options, border_win_options)
    -- TODO: Handle border width, which I haven't right here.
    local thickness = border_win_options.border_thickness

    local top_enabled = thickness.top == 1
    local right_enabled = thickness.right == 1
    local bot_enabled = thickness.bot == 1
    local left_enabled = thickness.left == 1

    local border_lines = {}

    local topline = nil

    local topleft = (left_enabled and border_win_options.topleft) or ''
    local topright = (right_enabled and border_win_options.topright) or ''

    if content_win_options.row > 0 then
        if border_win_options.title then
            local title = border_win_options.title
            if title ~= '' then title = string.format(" %s ", title) end
            local title_len = string.len(title)

            local midpoint = math.floor(content_win_options.width / 2)
            local left_start = midpoint - math.floor(title_len / 2)

            topline = string.format("%s%s%s%s%s", topleft, string.rep(border_win_options.top, left_start), title, string.rep(border_win_options.top, content_win_options.width - title_len - left_start), topright)
        else
            if top_enabled then topline = topleft .. string.rep(border_win_options.top, content_win_options.width) .. topright end
        end
    end

    if topline then table.insert(border_lines, topline) end

    local middle_line = string.format("%s%s%s", (left_enabled and border_win_options.left) or '', string.rep(' ', content_win_options.width), (right_enabled and border_win_options.right) or '')

    for _ = 1, content_win_options.height do table.insert(border_lines, middle_line) end

    if bot_enabled then table.insert(border_lines, string.format("%s%s%s", (left_enabled and border_win_options.botleft) or '', string.rep(border_win_options.bot, content_win_options.width), (right_enabled and border_win_options.botright) or '')) end

    return border_lines
end

function Border:new()
    local obj = setmetatable({}, Border)
    return obj
end

function Border:calculate(content_win_opts, border_opts)
    local thickness = border_opts.border_thickness

    local border_win_opts = {
        anchor = content_win_opts.anchor,
        relative = content_win_opts.relative,
        style = "minimal",
        row = content_win_opts.row - thickness.top,
        col = content_win_opts.col - thickness.left,
        width = content_win_opts.width + thickness.left + thickness.right,
        height = content_win_opts.height + thickness.top + thickness.bot,
        focusable = false,
        win = content_win_opts.win
    }
    return border_win_opts

end

function Border:redraw_all(win_self)
    vim.schedule_wrap(function()
        if win_self then self = win_self.border end
        -- for main window resizing autocmd like

        if win_self.bufnr.one_border ~= nil and win_self.custom_opts.dual == false then self:redraw_single(win_self, 'one', false, win_self.total_opts) end
        if win_self.bufnr.one_border ~= nil and win_self.custom_opts.dual == true then self:redraw_single(win_self, 'one', true, win_self.one_opts) end
        if win_self.bufnr.two_border ~= nil and win_self.custom_opts.dual == true then self:redraw_single(win_self, 'two', true, win_self.two_opts) end

    end)
end

function Border:redraw_single(win_self, one_two, single_dual, content_win_opts)
    -- redraw - for first window opening, and auto grow
    -- if win_self then self = win_self end

    local border_opts = win_self[one_two .. '_border_opts']
    local border_bufnr = win_self.bufnr[one_two .. '_border']

    local border_contents = Border._create_lines(content_win_opts, border_opts)
    local border_win_opts = win_self.border:calculate(content_win_opts, border_opts)

    local border_winnr = win_self.winnr[one_two .. '_border']

    if border_winnr ~= nil then
        vim.api.nvim_win_set_config(border_winnr, border_win_opts) -- do this when doing autogrow
    end

    vim.schedule(function() vim.api.nvim_buf_set_lines(border_bufnr, 0, -1, false, border_contents) end)

    return border_win_opts
end

function Border:open_single(win_self, one_two, single_dual)
    if win_self then self = win_self end

    local border_opts = win_self[one_two .. '_border_opts']

    local content_win_opts
    if single_dual == false then
        content_win_opts = win_self[one_two .. '_opts']
    elseif single_dual == true then
        content_win_opts = win_self.total_opts
    end

    local border_bufnr = vim.api.nvim_create_buf(false, true)
    win_self.bufnr[one_two .. '_border'] = border_bufnr

    vim.api.nvim_buf_set_option(border_bufnr, "bufhidden", "wipe")

    local border_contents = Border._create_lines(content_win_opts, border_opts)
    vim.api.nvim_buf_set_lines(border_bufnr, 0, -1, false, border_contents)
    local border_win_opts = win_self.border:calculate(content_win_opts, border_opts)

    win_self.winnr[one_two .. '_border'] = vim.api.nvim_open_win(border_bufnr, false, border_win_opts)

end

return Border
