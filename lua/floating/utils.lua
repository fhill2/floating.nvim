local utils = {}

function utils:strsplit(sSeparator, nMax, bRegexp)
   assert(sSeparator ~= '')
   assert(nMax == nil or nMax >= 1)
   local aRecord = {}
   if self:len() > 0 then
      local bPlain = not bRegexp
      nMax = nMax or -1
      local nField, nStart = 1, 1
      local nFirst,nLast = self:find(sSeparator, nStart, bPlain)
      while nFirst and nMax ~= 0 do
         aRecord[nField] = self:sub(nStart, nFirst-1)
         nField = nField+1
         nStart = nLast+1
         nFirst,nLast = self:find(sSeparator, nStart, bPlain)
         nMax = nMax-1
      end
      aRecord[nField] = self:sub(nStart)
   end
   return aRecord
end

-- function utils.start_timer()
-- local timer = vim.loop.new_timer()
-- math.random   

-- timer:start(1000, 0, vim.schedule_wrap(function()
--     --  vim.api.nvim_command('echomsg "test"')
--     end))
--   end

utils.if_nil = function(x, was_nil, was_not_nil)
  if x == nil then
    return was_nil
  else
    return was_not_nil
  end

end


utils.get_default = function(x, default)
  return utils.if_nil(x, default, x)
end

utils.ternary = function(condition, if_true, if_false)
  if condition then return if_true else return if_false end
end

--below here for popup.lua
utils.bounded = function(value, min, max)
  min = min or 0
  max = max or math.huge

  if min then value = math.max(value, min) end
  if max then value = math.min(value, max) end

  return value
end

utils.apply_defaults = function(original, defaults)
  if original == nil then
    original = {}
  end

  original = vim.deepcopy(original)

  for k, v in pairs(defaults) do
    if original[k] == nil then
      original[k] = v
    end
  end

  return original
end



return utils
