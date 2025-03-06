local base = _G
local _M = {}

_M.decorators = {}

local status = {}

local function decorate(callable, event)
    return function()
        _M.decorators[event](callable)
    end
end

local function is_callable(obj)
    return base.type(obj) == "function" or (base.getmetatable(obj) and base.getmetatable(obj).__call)
end

function _M.start_listen(table_to_listen)
    base.setmetatable(table_to_listen, {
        __newindex = function(t, k, v)
            if not is_callable(v) then
                rawset(t, k, v)
                return
            end
            for name, stat in pairs(status) do
                if stat then
                    v = decorate(v, name)
                    --t[k] = decorate(v, name)
                    status[name] = false
                end
            end
            rawset(t, k, v)
        end
    })
end

function _M.add_decorator(name, decorator)
    _M.decorators[name] = decorator
    status[name] = false
end

function _M.at(name)
    status[name] = true
end

return _M
