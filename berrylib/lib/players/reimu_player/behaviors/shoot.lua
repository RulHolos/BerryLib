---@class lstg.Player.Reimu.Behavior.Shoot : lstg.Player.Behavior
local M = {}
M.name = "Shoot"

function M:init()
    self.shoot_timer = 4
    self.next_shoot = self.shoot_timer
    self.fire = false
end

function M:frame()
    if self.fire and self.next_shoot <= 0 then
        self:shoot()
    end

    self.next_shoot = clamp(self.next_shoot - 1, 0, self.shoot_timer)
end

function M:shoot()
    PlaySound('plst00', 0.3, self.player.x / 1024)

    self.next_shoot = self.shoot_timer
end

---@param key_name KnownKeys
---@param is_down boolean
function M:OnKeyAction(key_name, is_down)
    if key_name == "Shoot" then
        self.fire = is_down
    end
end

return M