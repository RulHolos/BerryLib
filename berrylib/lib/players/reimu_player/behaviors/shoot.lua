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

    ---@type lstg.Player.Behavior.Death
    ---@diagnostic disable-next-line: assign-type-mismatch
    self.death = self.player:getBehavior("Death")

    ---@type lstg.Player.Behavior.Support
    ---@diagnostic disable-next-line: assign-type-mismatch
    self.support = self.player:getBehavior("Support")

    ---@type lstg.Player.Behavior.Move
    ---@diagnostic disable-next-line: assign-type-mismatch
    self.move = self.player:getBehavior("Move")

    -----------------------------------------
    LoadImage("reimu_bullet_red", "reimu_player", 192, 160, 64, 16, 16, 16)
    SetImageState("reimu_bullet_red", "", Color(0xA0FFFFFF))
    SetImageCenter("reimu_bullet_red", 56, 8)
    -----------------------------------------
    LoadImage("reimu_bullet_orange", "reimu_player", 64, 176, 64, 16, 64, 16)
    SetImageState("reimu_bullet_orange", "", Color(0x80FFFFFF))
    SetImageCenter("reimu_bullet_orange", 32, 8)
end

function M:frame()
    if not self.death.canAct(self.death) or self.player.in_dialog then
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
    self.next_shoot = self.shoot_timer

    New(player_bullet, "reimu_bullet_red", self.player.x + 10, self.player.y, 24, 90, 2)
    New(player_bullet, "reimu_bullet_red", self.player.x - 10, self.player.y, 24, 90, 2)
    if self.support.number_of_supports > 0 then
        if self.move.focus == 1 then
            self.support:doFor(function(i, x, y)
                New(player_bullet, "reimu_bullet_orange", x - 3, y, 24, 90, 0.3)
                New(player_bullet, "reimu_bullet_orange", x + 3, y, 24, 90, 0.3)
            end)
        end
    end
end

---@param key_name KnownKeys
---@param is_down boolean
function M:OnKeyAction(key_name, is_down)
    if key_name == "Shoot" then
        self.fire = is_down
    end
end

function M:debug()
    local success, value = ImGui.InputInt("Shoot timer", self.shoot_timer, 1, 1)
    if success then
        self.shoot_timer = clamp(value, 1, INF)
    end

    _, self.debug_fire = ImGui.Checkbox("Continuous shooting", self.debug_fire)
end

return M