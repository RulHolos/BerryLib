-- ============ --
-- Tween System --
-- ============ --

local Easing = require("berrylib.util.easing")

---@class lstg.Tween : lstg.object
---@field target lstg.object
---@field finished boolean
---@field onFrameFn fun(key, value)[]
---@field onCompleteFn fun(object:any)[]
---@field easing fun(t:integer)
---@field completed integer
---@field repeatCount integer
---@field timer integer
---@field duration integer Duration in frames
---@field properties table<number>
---@field from table<number>
---@field yoyoFlag boolean
---@field delay integer
---@field delayTimer integer
Tween = {}

function Tween:frame()
    if self.finished then
        return
    end

    if self.delayTimer < self.delay then
        self.delayTimer = self.delayTimer + 1
        return
    end

    local t = math.min(self.timer / self.duration, 1.0)
    local k = self.easing(t)

    for key, targetValue in pairs(self.properties) do
        local startValue = self.from[key]
        local value = startValue + (targetValue - startValue) * k
        self.target[key] = value
        for k, _ in ipairs(self.onFrameFn) do
            self.onFrameFn[k](key, value)
        end
    end

    self.timer = self.timer + 1

    if t >= 1.0 then
        self.completed = self.completed + 1
        if self.yoyoFlag and self.completed % 2 == 1 then
            local temp = self.from
            self.from = self.properties
            self.properties = temp
            self.timer = 0
        elseif self.completed < self.repeatCount then
            self.timer = 0
        else
            self.finished = true
            for k, _ in ipairs(self.onCompleteFn) do
                self.onCompleteFn[k]()
            end
        end
    end
end

---@generic T lstg.object or table.
---@param target T The target object
---@param properties table Properties of `target` to tween. Only number values.
---@param duration_frames integer Duration in frames
---@return lstg.Tween
function Tween.to(target, properties, duration_frames)
    local self = makeInstance(Tween)
    ---@type string|nil
    self.id = nil
    self.target = target
    self.duration = duration_frames
    self.properties = properties
    self.timer = 0
    self.from = {}
    self.repeatCount = 0
    self.completed = 0
    self.easing = Easing.linear
    self.onFrameFn = {}
    self.onCompleteFn = {}
    self.finished = false
    self.yoyoFlag = false
    self.delay = 0
    self.delayTimer = 0

    for k, _ in pairs(properties) do
        self.from[k] = target[k]
    end

    TweenManager:add(self)

    return self
end

---Tries to get a tween object from a target and an id.
---@param target lstg.object The target object
---@param id string Identifier of the tween to get
---@return lstg.Tween|nil self Returns the tween if found. Otherwise; nil.
function Tween.get(target, id)
    for _, v in ipairs(TweenManager.list) do
        if v.target == target and v.id == id then
            return v
        end
    end
    return nil
end

---Waits until the tween is finished.
---@param tween lstg.Tween
function Tween.wait(tween)
    while not tween.finished do
        Task.wait()
    end
end

-- ============= --
-- Chainable API --
-- ============= --

---Adds a easing behavior to this tween.
---@param name EasingType
---@return lstg.Tween self
function Tween:ease(name)
    self.easing = Easing[name] or Easing.linear
    return self
end

---@param times integer Number of times to repeat.
---@return lstg.Tween self
function Tween:times(times)
    self.repeatCount = times or 0
    return self
end

---Adds a frame callback.
---
---Will be called each frame for every properties set to change.
---@param callback fun(key, value)
---@return lstg.Tween self
function Tween:onFrame(callback)
    table.insert(self.onFrameFn, callback or function(key, value) end)
    return self
end

---Adds a completed callback.
---
---Called when the tween finishes.
---@param callback fun(object: any)
---@return lstg.Tween self
function Tween:onComplete(callback)
    table.insert(self.onCompleteFn, callback or function(object) end)
    return self
end

---Creates a "back and forth" behavior.
---@return lstg.Tween self
function Tween:yoyo()
    self.yoyoFlag = true
    return self
end

---Attaches an optional id to this tween for future reference.
---@param id string Identifier of this tween.
---@return lstg.Tween self
function Tween:attachId(id)
    self.id = id or "default"
    return self
end

---Starts the tween after a certain amount of frames.
---@param frames integer Delay to start the tween.
---@return lstg.Tween self
function Tween:delay(frames)
    self.delay = frames or 0
    return self
end

---Adds new properties to this tween. Useful for object-created-returned tweens.
---@param tbl table A table of properties. Same format as `Tween.to()`.
---@return lstg.Tween self
function Tween:addProperties(tbl)
    for k, v in pairs(tbl) do
        self.properties[k] = v
    end
    return self
end