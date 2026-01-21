-- ============== --
-- Signals System --
-- ============== --
--[[
    Signals are a way to implement an event-like system, they're a core part of BerryLib's behavior pattern.

    Signals come in two types: static and dynamic.
    - Dynamic signals are used to register and emit callbacks calls.
    - Static signals are used for setting signal keys to values. (ex.SetSignal in THlib)
--]]

---@class lstg.Signals.Entry
---@field id string?
---@field callback fun(...)
---@field enabled boolean
---@field once boolean?
---@field priority integer?

---@class lstg.Signals
---@field entries table<string, lstg.Signals.Entry[]>
---@field static table<string, any>
local Signals = {
    entries = {},
    static = {},
}
lstg.Signals = Signals

------------------------
-- Helper Functions
------------------------

---Comparator for sorting entries by priority (descending).
---@param a lstg.Signals.Entry
---@param b lstg.Signals.Entry
---@return boolean
local function comparePriority(a, b)
    return (a.priority or 0) > (b.priority or 0)
end

---Creates a new signal entry.
---@param id string
---@param callback fun(...)
---@param priority integer?
---@param once boolean?
---@return lstg.Signals.Entry
local function createEntry(id, callback, priority, once)
    return {
        id = id,
        callback = callback,
        enabled = true,
        once = once or false,
        priority = priority or 0,
    }
end

---Adds an entry to the signal list and sorts by priority.
---@param self lstg.Signals
---@param key string
---@param entry lstg.Signals.Entry
local function addEntry(self, key, entry)
    local lst = self.entries[key] or {}
    lst[#lst + 1] = entry
    table.sort(lst, comparePriority)
    self.entries[key] = lst
end

------------------------
-- Dynamic Signals
------------------------

---Check if there are any listeners for a given signal key.
---@param key string
---@return boolean
function Signals:hasListeners(key)
    local lst = self.entries[key]
    return lst ~= nil and #lst > 0
end

---Adds a function to be called when a signal with the given key is emitted.
---@param key string
---@param id string
---@param callback fun(...)
---@param priority integer? Higher priority callbacks are called first. Default is 0.
function Signals:register(key, id, callback, priority)
    local entry = createEntry(id, callback, priority, false)
    addEntry(self, key, entry)
end

---Registers a one-time callback for the given signal key. The callback will be removed after being called once.
---@param key string
---@param id string
---@param callback fun(...)
---@param priority integer? Higher priority callbacks are called first. Default is 0.
function Signals:registerOnce(key, id, callback, priority)
    local entry = createEntry(id, callback, priority, true)
    addEntry(self, key, entry)
end

---Removes a previously registered callback for the given signal key.
---@param key string
---@param id string?
---@param callback fun(...)?
function Signals:unregister(key, id, callback)
    if not self:hasListeners(key) then return end

    if id == nil then
        assert(callback ~= nil, "Using key mode: Callback must not be nil.")
    end

    local lst = self.entries[key]
    for i, entry in ipairs(lst) do
        if entry.callback == callback then
            table.remove(lst, i)
            break
        end
    end
end

---Calls all registered callbacks for the given signal key, passing any additional arguments to them.
---@param key string
---@param ... any
function Signals:emit(key, ...)
    if not self:hasListeners(key) then return end

    local lst = self.entries[key]
    for _, entry in ipairs(lst) do
        if entry.enabled then
            local result = entry.callback(...)
            if entry.once or result == false then
                self:unregister(key, nil, entry.callback)
            end
        end
    end
end

---Asynchronously calls all registered callbacks for the given signal key, passing any additional arguments to them.
---@param key string
---@param ... any
function Signals:emitAsync(key, ...)
    if not self:hasListeners(key) then return end

    local lst = self.entries[key]
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
        keys[#keys + 1] = k
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

------------------------
-- Static Signals
------------------------

---Sets a static signal to a value.
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
        Task.wait(1)
    end
end