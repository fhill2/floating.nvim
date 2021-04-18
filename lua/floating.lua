local floating = {}
local window = require'floating/window'
local Config = require'floating/config'





return {
  open = window.open,
  config = Config.setup
}
