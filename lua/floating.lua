local floating = {}
local window = require'floating/window'
local Config = require'floating/config'





return {
  open = window.open,
  setup = Config.setup,
  close_all = window.close_all_views
}
