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

local function has_positional_arg(func, position)
    if base.type(func) == "table" then
        local mt = base.getmetatable(func)
        -- 前面已经保证func是可调用的
        return has_positional_arg(mt.__call, position)
    end

    local info = base.debug.getinfo(func, "u")
    local nparams = base.math.abs(info.nparams) -- 处理可变参数（负值表示固定参数数量）

    return position <= nparams
end

_M.safe_mode = false

function _M.start_listen(table_to_listen)
    base.setmetatable(table_to_listen, {
        __newindex = function(t, k, v)
            if not is_callable(v) then
                base.rawset(t, k, v)
                return
            end
            for name, stat in base.pairs(status) do
                if stat then
                    v = decorate(v, name)
                    --t[k] = decorate(v, name)
                    status[name] = false
                end
            end
            base.rawset(t, k, v)
        end
    })
end

function _M.add_decorator(name, decorator)
    base.assert(is_callable(decorate), "Decorator already exists")
    if _M.safe_mode then
        base.assert(has_positional_arg(decorator, 1), "Decorator must have at least one argument")
    end
    _M.decorators[name] = decorator
    status[name] = false
end

function _M.at(name)
    status[name] = true
end

return _M
