-- ============ --
-- Tween System --
-- ============ --

local Easing = require("berrylib.util.easing")

---@class lstg.Tween : lstg.object
---@field target lstg.object
---@field finished boolean
---@field onCompleteFn fun()
---@field easing fun(t:integer)
---@field completed integer
---@field repeatCount integer
---@field timer integer
---@field duration integer Duration in frames
---@field properties table<number>
---@field from table<number>
---@field yoyoFlag boolean
Tween = {}

function Tween:frame()
    if self.finished then
        return
    end

    local t = math.min(self.timer / self.duration, 1.0)
    local k = self.easing(t)

    for key, targetValue in pairs(self.properties) do
        local startValue = self.from[key]
        self.target[key] = startValue + (targetValue - startValue) * k
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
            if self.onCompleteFn then
                self.onCompleteFn()
            end
        end
    end
end

---@param target lstg.object The target object
---@param properties table Properties of `target` to tween. Only number values.
---@param duration_frames integer Duration in frames
---@return lstg.Tween
function Tween.to(target, properties, duration_frames)
    local self = makeInstance(Tween)
    self.target = target
    self.duration = duration_frames
    self.properties = properties
    self.timer = 0
    self.from = {}
    self.repeatCount = 0
    self.completed = 0
    self.easing = Easing.linear
    self.onCompleteFn = function() end
    self.finished = false
    self.yoyoFlag = false

    for k, _ in pairs(properties) do
        self.from[k] = target[k]
    end

    TweenManager:add(self)

    return self
end

-- ============= --
-- Chainable API --
-- ============= --

---@param name EasingType
---@return lstg.Tween self
function Tween:ease(name)
    self.easing = Easing[name] or Easing.linear
    return self
end

---@param times integer Number of times to repeat
---@return lstg.Tween self
function Tween:times(times)
    self.repeatCount = times or 0
    return self
end

---@param callback fun()
---@return lstg.Tween self
function Tween:onComplete(callback)
    self.onCompleteFn = callback
    return self
end

---@return lstg.Tween self
function Tween:yoyo()
    self.yoyoFlag = true
    return self
end