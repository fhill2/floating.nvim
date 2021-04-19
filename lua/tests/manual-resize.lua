local state = require'floating/state'

for k, v in pairs(state.views) do
--state.views[k]:calculate(state.views[k])
--state.views[k]:resize(state.views[k], 'one')


state.views[k].border:redraw_all(state.views[k])

end
