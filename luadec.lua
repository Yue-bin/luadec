local base = _G
local _M = {}

_M.decorators = {}

local status = {}

function _M.add_decorator(name, decorator)
    _M.decorators[name] = decorator
    status[name] = false
end

local function decorate(func, event)
    return function()
        _M.decorators[event](func)
    end
end

function _M.start_listen(table_to_listen)
    base.setmetatable(table_to_listen, {
        __newindex = function(t, k, v)
            for name, stat in pairs(status) do
                if stat then
                    rawset(t, k, decorate(v, name))
                    --t[k] = decorate(v, name)
                    status[name] = false
                end
            end
        end
    })
end

function _M.At(name)
    status[name] = true
end

return _M
