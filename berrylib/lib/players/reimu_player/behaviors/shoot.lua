--#region Bullet effects

local reimu_bullet_ef = Class(Object)
function reimu_bullet_ef:init(x, y, rot)
    self.x, self.y = x, y
    self.rot = rot
    self.img = "reimu_bullet_orange_ef"
    self.layer = LAYER_PLAYER_BULLETS + 50
    self.group = GROUP_GHOST
    self.vy = 2
    self.hscale = ran:Float(1.4, 1.6)
end
function reimu_bullet_ef:frame()
    if self.timer > 15 then
        self.x = 600
        Del(self)
    end
end
function reimu_bullet_ef:render()
    SetImageState(self.img, "mul+add", Color(255 - 255 * self.timer / 16, 255, 255, 255))
    Object.render(self)
end

local reimu_bullet_ef2 = Class(Object)
function reimu_bullet_ef2:init(x, y)
    self.x, self.y = x, y
    self.rot = -90 + ran:Float(-10, 10)
    self.img = "reimu_bullet_orange_ef2"
    self.layer = LAYER_PLAYER_BULLETS + 50
    self.group = GROUP_GHOST
    self.hscale = ran:Float(1.5, 1.8)
    self.vscale = 1.5
end
function reimu_bullet_ef2:frame()
    if self.timer >= 9 then
        self.x = 600
        Del(self)
    end
end

local reimu_bullet_blue_ef = Class(Object)
function reimu_bullet_blue_ef:init(x, y, rot)
    self.x, self.y = x, y
    self.rot = rot
    self.img = "reimu_bullet_blue_ef"
    self.layer = LAYER_PLAYER_BULLETS + 50
    self.group = GROUP_GHOST
    self.vx = cos(rot)
    self.vy = sin(rot)
end
function reimu_bullet_blue_ef:frame()
    if self.timer > 14 then
        Del(self)
    end
end

--#endregion
--#region Bullet types
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
function player_bullet:kill()
    New(reimu_bullet_ef, self.x, self.y, self.rot + 180 + ran:Float(-15, 15))
    New(reimu_bullet_ef2, self.x, self.y)
end

local player_bullet_blue = Class(Object)
function player_bullet_blue:init(img, x, y, v, angle, trail, dmg, player)
    self.group = GROUP_PLAYER_BULLET
    self.layer = LAYER_PLAYER_BULLETS
    self.img = img
    self.x, self.y = x, y
    self.rot = angle
    self.v = v
    self.trail = trail
    self.dmg = dmg
    self.player = player
    if self.a ~= self.b then
        self.rect = true
    end
end
function player_bullet_blue:frame()
    if IsValid(self.player.target) and self.player.target.colli then
        local a = math.mod(Angle(self, self.player.target) - self.rot + 720, 360)
        if a > 180 then
            a = a - 360
        end
        local da = self.trail / (Dist(self, self.player.target) + 1)
        if da >= abs(a) then
            self.rot = Angle(self, self.player.target)
        else
            self.rot = self.rot + sign(a) * da
        end
    end
    self.vx = self.v * cos(self.rot)
    self.vy = self.v * sin(self.rot)
end
function player_bullet_blue:kill()
    New(reimu_bullet_blue_ef, self.x, self.y, self.rot)
end
--#endregion

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
    LoadTexture("reimu_orange_ef2", "players/reimu_player/reimu_orange_eff.png")
    LoadImage('reimu_bullet_orange', 'reimu_player', 64, 176, 64, 16, 64, 16)
	SetImageState('reimu_bullet_orange', '', Color(0x80FFFFFF))
	SetImageCenter('reimu_bullet_orange', 32, 8)
	LoadImage('reimu_bullet_orange_ef', 'reimu_player', 64, 176, 64, 16, 64, 16)
	SetImageState('reimu_bullet_orange_ef', '', Color(0x80FFFFFF))
	SetImageCenter('reimu_bullet_orange_ef', 32, 8)
	LoadAnimation('reimu_bullet_orange_ef2', 'reimu_orange_ef2', 0, 0, 64, 16, 1, 9, 1)
	SetAnimationCenter('reimu_bullet_orange_ef2', 0, 8)
	SetAnimationState('reimu_bullet_orange_ef2', 'mul+add', Color(255, 255, 155, 155))
    -----------------------------------------
    LoadImage("reimu_bullet_blue", "reimu_player", 0, 160, 16, 16, 16, 16)
    SetImageState("reimu_bullet_blue", "", Color(0x80FFFFFF))
    LoadAnimation("reimu_bullet_blue_ef", "reimu_player", 0, 160, 16, 16, 4, 1, 4)
    SetAnimationState("reimu_bullet_blue_ef", "mul+add", Color(0xA0FFFFFF))
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
        else
            if self.player.timer % 8 < 4 then
                self.support:doFor(function(i, x, y)
                    New(player_bullet_blue, "reimu_bullet_blue", x, y, 8, 90, 900, 0.7, self.player)
                end)
            end
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