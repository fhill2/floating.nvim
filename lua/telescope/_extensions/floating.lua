local has_telescope, telescope = pcall(require, 'telescope')
if not has_telescope then error('This plugins requires nvim-telescope/telescope.nvim') end

local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local previewers = require('telescope.previewers')
local entry_display = require('telescope.pickers.entry_display')
local sorters = require "telescope.sorters"
local conf = require('telescope.config').values

local state = require 'floating/state'

local tstate = {}

local floating = function(opts)

    -- lo('ltl ran!!')

    local objs = {}
    for k, v in pairs(state.views) do

        local dual_str
        if v.custom_opts.dual then
            dual_str = 'dual'
        else
            dual_str = 'single'
        end

        if not v.custom_opts.dual then table.insert(objs, {dual = 'single', name = k}) end

        if v.custom_opts.dual then
            table.insert(objs, {dual = '1/2', name = k})

            -- insert 2nd window as another result
            table.insert(objs, {dual = '2/2', name = k})

        end

    end

    local displayer = entry_display.create {
        separator = ' ',
        items = {{width = 20}, {width = 20}} -- , {width = 20}, {remaining = true}},
    }

    local make_display = function(entry) return displayer {entry.value.name, entry.value.dual} end

    pickers.new(opts, {
        prompt_title = 'Floating Windows',
        finder = finders.new_table {results = objs, entry_maker = function(entry) return {value = entry, display = make_display, ordinal = entry.name} end},
        sorter = conf.generic_sorter(opts),
        previewer = conf.file_previewer(opts),
        attach_mappings = function() return true end
    }):find()

    -- tstate.picker = 

end

return telescope.register_extension {exports = {floating = floating}}

