local base = _G
local _M = {}

local decorators = {}

local function decorate(callable, decorator)
    return function()
        decorator(callable)
    end
end

local function is_callable(obj)
    return base.type(obj) == "function" or (base.getmetatable(obj) and base.getmetatable(obj).__call)
end

function _M.start_listen(table_to_listen)
    base.setmetatable(table_to_listen, {
        __newindex = function(t, k, v)
            if not is_callable(v) then
                base.rawset(t, k, v)
                return
            end
            for name, decorator in base.pairs(decorators) do
                if decorator.status then
                    v = decorate(v, decorator.func)
                    --t[k] = decorate(v, name)
                    decorators[name].status = false
                end
            end
            base.rawset(t, k, v)
        end
    })
end

function _M.add_decorator(name, decorator)
    base.assert(is_callable(decorate), "Decorator already exists")
    decorators[name] = {
        func = decorator,
        status = false
    }
end

function _M.at(name)
    base.assert(decorators[name], "Decorator not found")
    decorators[name].status = true
end

return _M
