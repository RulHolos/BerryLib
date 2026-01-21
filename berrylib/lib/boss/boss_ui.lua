local hp = require("lib.boss.ui.hp_circle")
local tim = require("lib.boss.ui.timer")
local pointer = require("lib.boss.ui.pointer")

---@class berry.boss.ui : lstg.object
---@field open boolean Will dictate when the aura appears and disappears;
---@field create fun(boss:berry.boss.boss_manager)
local M = Class(Object)

---@param manager berry.boss.boss_manager
function M:init(manager)
    self.manager = manager

    self.layer = LAYER_TOP + 2
    self.group = GROUP_GHOST
    self.bound = false
    self.colli = false
    self.alpha = 0

    self.fade_in = M.fade_in
    self.fade_out = M.fade_out
    self.set_state = M.set_state

    self.show_timer = true
    self.show_hp = true
    self.show_name = true
    self.show_aura = true
    self.show_pointer = true

    self.time = tim.create(self)
    self.hp = hp.create(self)
    self.pointer = pointer.create(self)
end

function M:frame()
    Task.Do(self)
end

function M:render()
    if self.alpha < 0.0001 then
        return
    end
end

function M:kill()
end

function M:del()
end

function M:fade_in()
    Tween.to(self, { alpha = 255 }, 60)
end

function M:fade_out()
    Tween.to(self, { alpha = 0 }, 60)
        :onComplete(function(_)
            Del(self)
        end)
end

---Sets the state of the boss UI
---@param timer boolean
---@param hp_circle boolean
---@param name boolean
---@param aura boolean
---@param pointer boolean
---@overload fun(self:berry.boss.ui, full_enabled:boolean) Sets the state to one single value.
function M:set_state(timer, hp_circle, name, aura, pointer)
    if type(hp_circle) ~= "boolean" then
        local full_enabled = timer
        Tween.to(self.time, { alpha = full_enabled and 255 or 0 }, 30)
        Tween.to(self.hp, { alpha = full_enabled and 255 or 0 }, 30)
        --Tween.to(self.name, { alpha = full_enabled and 255 or 0 }, 30)
        --Tween.to(self.aura, { alpha = full_enabled and 255 or 0 }, 30)
        Tween.to(self.pointer, { alpha = full_enabled and 255 or 0 }, 30)
    else
        Tween.to(self.time, { alpha = timer and 255 or 0 }, 30)
        Tween.to(self.hp, { alpha = hp_circle and 255 or 0 }, 30)
        --Tween.to(self.name, { alpha = name and 255 or 0 }, 30)
        --Tween.to(self.aura, { alpha = aura and 255 or 0 }, 30)
        Tween.to(self.pointer, { alpha = pointer and 255 or 0 }, 30)
    end
end

---Creates a new BossUI makeInstance
---@nodiscard
---@param manager berry.boss.boss_manager
---@return berry.boss.ui
function M.create(manager)
    return New(M, manager)
end

lstg.RegisterGameObjectClass(M)

return M