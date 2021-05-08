local utils = {}

function utils:strsplit(sSeparator, nMax, bRegexp)
    assert(sSeparator ~= '')
    assert(nMax == nil or nMax >= 1)
    local aRecord = {}
    if self:len() > 0 then
        local bPlain = not bRegexp
        nMax = nMax or -1
        local nField, nStart = 1, 1
        local nFirst, nLast = self:find(sSeparator, nStart, bPlain)
        while nFirst and nMax ~= 0 do
            aRecord[nField] = self:sub(nStart, nFirst - 1)
            nField = nField + 1
            nStart = nLast + 1
            nFirst, nLast = self:find(sSeparator, nStart, bPlain)
            nMax = nMax - 1
        end
        aRecord[nField] = self:sub(nStart)
    end
    return aRecord
end

utils.if_nil = function(x, was_nil, was_not_nil)
    if x == nil then
        return was_nil
    else
        return was_not_nil
    end

end

utils.get_default = function(x, default) return utils.if_nil(x, default, x) end

utils.ternary = function(condition, if_true, if_false)
    if condition then
        return if_true
    else
        return if_false
    end
end

-- FROM popup.lua
utils.bounded = function(value, min, max)
    min = min or 0
    max = max or math.huge

    if min then value = math.max(value, min) end
    if max then value = math.min(value, max) end

    return value
end

utils.apply_defaults = function(original, defaults) if original == nil then original = {} end end

-- FROM telescope/path.lua
utils.read_file = function(filepath)
    local fd = vim.loop.fs_open(filepath, "r", 438)
    if fd == nil then return '' end
    local stat = assert(vim.loop.fs_fstat(fd))
    if stat.type ~= 'file' then return '' end
    local data = assert(vim.loop.fs_read(fd, stat.size, 0))
    assert(vim.loop.fs_close(fd))
    return data
end

utils.read_file_async = function(filepath, callback)
    vim.loop.fs_open(filepath, "r", 438, function(err_open, fd)
        if err_open then
            print("We tried to open this file but couldn't. We failed with following error message: " .. err_open)
            return
        end
        vim.loop.fs_fstat(fd, function(err_fstat, stat)
            assert(not err_fstat, err_fstat)
            if stat.type ~= 'file' then return callback('') end
            vim.loop.fs_read(fd, stat.size, 0, function(err_read, data)
                assert(not err_read, err_read)
                vim.loop.fs_close(fd, function(err_close)
                    assert(not err_close, err_close)
                    return callback(data)
                end)
            end)
        end)
    end)
end

utils.contains_table = function(t)
for i, v in ipairs(t) do 
if type(v) == 'table' then return true end
return false
end
end

return utils
