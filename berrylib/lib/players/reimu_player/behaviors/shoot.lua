local player_bullet = Class(Object)
function player_bullet:init(img, x, y, v, angle, dmg)
    self.group = GROUP_PLAYER_BULLET
    self.layer = LAYER_PLAYER_BULLETS
    self.img = img
    self.x, self.y = x, y
    self.rot = angle
    self.vx = v * cos(angle)
    self.vy = v * sin(angle)
    self.dmg = dmg
    if self.a ~= self.b then
        self.rect = true
    end
end

---@class lstg.Player.Reimu.Behavior.Shoot : lstg.Player.Behavior
local M = {}
M.name = "Shoot"

function M:init()
    self.shoot_timer = 4
    self.next_shoot = self.shoot_timer
    self.fire = false
    self.debug_fire = false
end

function M:frame()
    ---@type lstg.Player.Behavior.Death
    ---@diagnostic disable-next-line: assign-type-mismatch
    self.death = self.player:getBehavior("Death")
    if not self.death.canAct(self.death) then
        self.next_shoot = clamp(self.next_shoot - 1, 0, self.shoot_timer)
        return
    end

    if (self.fire or self.debug_fire) and self.next_shoot <= 0 then
        self:shoot()
    end

    self.next_shoot = clamp(self.next_shoot - 1, 0, self.shoot_timer)
end

function M:shoot()
    PlaySound('plst00', 0.3, self.player.x / 1024)
    New(player_bullet, "reimu_bullet_main", self.player.x + 10, self.player.y, 24, 90, 2)
    New(player_bullet, "reimu_bullet_main", self.player.x - 10, self.player.y, 24, 90, 2)

    self.next_shoot = self.shoot_timer
end

---@param key_name KnownKeys
---@param is_down boolean
function M:OnKeyAction(key_name, is_down)
    if key_name == "Shoot" then
        self.fire = is_down
    end
end

function M:debug()
    _, self.debug_fire = ImGui.Checkbox("Continuous shooting", self.debug_fire)
end

return M