local utils = require 'floating/utils'
local get_default = utils.get_default

Config = {
    defaults = {
        border = true, border_thickness = { 1, 1, 1, 1 }, borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' }, title = 'win1', two_title = 'win2', x = 0, y = 0, layout = 'vertical', pin = false, dual = false, grow = false, two_grow = false, max_height = 40, two_max_height = 40, grow_direction = false, two_grow_direction = false, winblend = 15, split = 0.5, gap = 0, content_height = false, two_content_height = false, margin = { 1, 1, 1, 1 }, two_margin = { 1, 1, 1, 1 },
        width = 0.9, height = 0.3, relative = 'editor', style = false, enter = false, toggle = true, on_close = 'windows'
    }, user_views = {}, user_actions = {}, user_exits = {}, default_views = { single_auto_grow = {}, center = { width = 0.8, height = 0.8 }, content_auto = { content_height = true, grow = true }, dual_content_auto = { content_height = true, two_content_height = true, grow = true, two_grow = true }, dual_bot = {} }, default_actions = {
        open_file = function(opts, filepath)
            if not filepath then
                vim.api.nvim_buf_set_lines(opts.bufnr, 0, -1, false, { 'Error: filepath not specified' })
                return
            end

            -- if buffer already exists
            for k, bufnr in pairs(vim.api.nvim_list_bufs()) do
                local iter_name = vim.api.nvim_buf_get_name(bufnr)
                if iter_name == filepath then
                    vim.api.nvim_buf_set_option(bufnr, 'buflisted', true)
                    vim.schedule(function() vim.api.nvim_win_set_buf(opts.winnr, bufnr) end)
                    opts.bufnr = bufnr
                    return
                end
            end
            vim.api.nvim_buf_set_name(opts.bufnr, filepath)
            vim.api.nvim_buf_set_option(opts.bufnr, 'buftype', '')

            vim.schedule(function() vim.api.nvim_buf_call(opts.bufnr, function() vim.cmd([[edit!]] .. filepath) end) end)
        end, buf_write = function(opts, msg) vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { msg }) end, open_term = function(opts, cmd) vim.schedule(function() vim.api.nvim_buf_call(opts.bufnr, function() vim.cmd([[terminal]]) end) end) end, read_file_async = function()
            -- TODO
            -- local filetype = filepath:match('.*%/.*%.(.*)$')
            -- local fd = vim.loop.fs_open(filepath, "r", 438, function(err_open, fd)
            --     if err_open then
            --         vim.schedule(function() vim.api.nvim_buf_set_lines(opts.bufnr, 0, -1, false, {'Error: cant find file', err_open}) end)
            --         return
            --     else
            --         local stat = vim.loop.fs_fstat(fd)

            --         if stat.type ~= 'file' then
            --             vim.schedule(function() vim.api.nvim_buf_set_lines(opts.bufnr, 0, -1, false, {'Error: filepath is not a file'}) end)
            --             return
            --         end

            --         local data = vim.loop.fs_read(fd, stat.size, 0)
            --         vim.loop.fs_close(fd)

            --         vim.schedule(function()
            --             vim.api.nvim_buf_set_lines(opts.bufnr, 0, -1, false, vim.split(data, '[\r]?\n'))
            --             vim.api.nvim_buf_set_option(opts.bufnr, 'filetype', filetype)

            --             if opts.one_two == 'one' and opts.self.custom_opts.content_height == true then
            --                 opts.self:resize_to_height(opts.self, opts.one_two, opts.single_dual)
            --             elseif opts.one_two == 'two' and opts.self.custom_opts.two_content_height == true then
            --                 opts.self:resize_to_height(opts.self, opts.one_two, opts.single_dual)
            --             end

            --         end)

            --     end

            -- end)
        end

    }, default_exits = {}
}

function Config.setup(opts)
    opts = opts or {}
    for k, v in pairs(opts.defaults) do Config.defaults[k] = v end

    Config.user_views = opts.user_views
    Config.user_actions = opts.user_actions
    Config.user_exits = opts.user_exits
end

function Config.get_preset(preset_name, view_action_exit, merge, merge_opts)
    local user_preset = Config['user_' .. view_action_exit][preset_name]
    local default_preset = Config['default_' .. view_action_exit][preset_name]
    local preset = user_preset or default_preset or assert(false, view_action_exit .. ' preset not found in user or default presets')

    if merge and view_action_exit == 'view' then
        return vim.tbl_extend('force', preset, merge_opts)
    else
        return preset
    end
end

return Config
