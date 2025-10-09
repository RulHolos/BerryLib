---@class berry.boss.boss : lstg.object
local M = Class(Object)

---@param name string Full name of the boss
---@param img string Image name of the boss
---@param x number Initial x pos
---@param y number Initial y pos
---@param aura berry.boss.aura|nil
---@param manager berry.boss.boss_manager
function M:init(name, img, x, y, aura, manager)
    self.x, self.y = x, y
    self.name = name
    ---@type berry.boss.boss_manager
    self.manager = manager
    if aura ~= nil then
        self.aura = aura.create(self)
    end

    self.bound = false
    self.img = img
    self.group = GROUP_BOSS
    self.layer = LAYER_ENEMIES - 1
    self.ringx, self.ringy = self.x, self.y
end

function M:frame()
    Task.Do(self)

    self.a, self.b = 20, 20 -- why
end

function M:render()
    Render(self.img, self.y, self.y + cos(self.timer) * 4, 0, 0.06)
end

function M:kill()
end

function M:del()
end

---@param other lstg.object Colliding object
function M:colli(other)
end

---@param dmg number Amount of row damage taken
function M:Damage(dmg)
    self.manager.hit_number = self.manager.hit_number + 1
    self.manager:dealDamage(dmg)
end

---@param destX number X-axis destination
---@param destY number Y-axis destination
---@param time integer Time in frames it takes to move
---@param mode 0|1|2|3 Easing mode
function M:Move(destX, destY, time, mode)

end

lstg.RegisterGameObjectClass(M)

return M