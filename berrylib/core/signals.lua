-- ============== --
-- Signals System --
-- ============== --
--[[
    Signals are a way to implement an event-like system, they're a core part of BerryLib's behavior pattern.

    Signals come in two types: static and dynamic.
    - Dynamic signals are used to register and emit callbacks calls.
    - Static signals are used for setting signal keys to values. (ex.SetSignal in THlib)
--]]

---@class lstg.Signals
local Signals = {
    ---@private
    ---@type table<string, lstg.Signals.Entry[]>
    entries = {},

    ---@private
    ---@type table<string, any>
    static = {}
}
lstg.Signals = Signals

------------- Dynamic Signals

---@class lstg.Signals.Entry
---@field id string?
---@field callback fun(...)
---@field once boolean?
---@field priority integer?

---Adds a function to be called when a signal with the given key is emitted.
---@param key string
---@param id string
---@param callback fun(...)
---@param priority integer? Higher priority callbacks are called first. Default is 0.
function Signals:register(key, id, callback, priority)
    ---@type lstg.Signals.Entry
    local entry = {
        id = id,
        callback = callback,
        priority = priority or 0,
    }

    local lst = self.entries[key] or {}
    lst[#lst + 1] = entry

    table.sort(lst, function(a, b)
        return (a.priority or 0) > (b.priority or 0)
    end)

    self.entries[key] = lst
end

---Registers a one-time callback for the given signal key. The callback will be removed after being called once.
---@param key string
---@param id string
---@param callback fun(...)
---@param priority integer? Higher priority callbacks are called first. Default is 0.
function Signals:once(key, id, callback, priority)
    ---@type lstg.Signals.Entry
    local entry = {
        id = id,
        callback = callback,
        once = true,
        priority = priority or 0,
    }

    local lst = self.entries[key] or {}
    lst[#lst + 1] = entry

    table.sort(lst, function(a, b)
        return (a.priority or 0) > (b.priority or 0)
    end)

    self.entries[key] = lst
end

---Removes a previously registered callback for the given signal key.
---@param key string
---@param id string?
---@param callback fun(...)?
function Signals:unregister(key, id, callback)
    local lst = self.entries[key]
    if not self:hasListeners(key) then return end

    if id == nil then
        assert(callback ~= nil, "Using key mode: Callback must not be nil.")
    end

    for i, cb in ipairs(lst) do
        if cb.callback == callback then
            table.remove(lst, i)
            break
        end
    end
end

---Calls all registered callbacks for the given signal key, passing any additional arguments to them.
---@param key string
---@param ... any
function Signals:emit(key, ...)
    local lst = self.entries[key]
    if not self:hasListeners(key) then return end

    for _, entry in ipairs(lst) do
        entry.callback(...)
        if entry.once then
            self:unregister(key, nil, entry.callback)
        end
    end
end

---Asynchronously calls all registered callbacks for the given signal key, passing any additional arguments to them.
---@param key string
---@param ... any
function Signals:emitAsync(key, ...)
    local lst = self.entries[key]
    if not self:hasListeners(key) then return end

    for _, entry in ipairs(lst) do
        local co = coroutine.create(entry.callback)
        local ok, err = coroutine.resume(co, ...)
        if not ok then
            error(err)
        end
    end
end

---Function to iterate over all registered signal names. Can be used in a for loop.
---@return function
function Signals:eventNames()
    local keys = {}
    for k in pairs(self.entries) do
        keys[#keys+1] = k
    end
    local i = 0
    return function()
        i = i + 1
        return keys[i]
    end
end

---Clears all registered signals and their callbacks.
---@param key string? If provided, only clears callbacks for this key.
function Signals:clear(key)
    if key then
        self.entries[key] = nil
    else
        self.entries = {}
    end
end

---Check if there are any listeners for a given signal key.
---@param key string
function Signals:hasListeners(key)
    local lst = self.entries[key]
    return lst ~= nil and #lst > 0
end

------------------------ Static signals

---Sets a static signals to a value.
---@param key string
---@param value any
function Signals:setStatic(key, value)
    self.static[key] = value
end

---Waits until a static signal has the wanted value.
---@param key string
---@param value any
function Signals:waitForStatic(key, value)
    while self.static[key] ~= value do
        Task.Wait(1)
    end
end