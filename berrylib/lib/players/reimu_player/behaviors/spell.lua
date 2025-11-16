-- Warning: For these two objects, I took the THlib version of the base Reimu player.
-- This is NOT my code.

--#region kekkai
local reimu_kekkai = Class(Object)
function reimu_kekkai:init(x, y, dmg, dr, n, t)
    self.x, self.y = x, y
    self.dmg = dmg
    SetImageState('reimu_kekkai', 'mul+add', Color(0x804040FF))
    self.group = GROUP_PLAYER_BULLET
    self.layer = LAYER_PLAYER_BULLETS
    self.r, self.a, self.b = 0, 0, 0
    self.dr = dr
    self.ds = dr / 256
    self.n = 0
    self.mute = true
    self.list = {}
    Task.new(self, function()
        for i = 1, n do
            self.list[i] = { scale = 0, rot = 0 }
            self.n = self.n + 1
            Task.wait(t)
        end
        self.dmg = 0
        PlaySound("slash", 1.0)
        for i = 128, 0, -4 do
            SetImageState('reimu_kekkai', 'mul+add', Color(0x004040FF) + i * Color(0x01000000))
			Task.wait(1)
        end
        Del(self)
    end)
end

function reimu_kekkai:frame()
    Task.Do(self)

    if self.timer % 6 == 0 then
        self.mute = false
    else
        self.mute = true
    end
    self.r = self.r + self.dr
    self.a, self.b = self.r, self.r
    for i = 1, self.n do
        self.list[i].scale = self.list[i].scale + self.ds
        self.list[i].rot = self.list[i].rot + (-1) ^ i
    end
    Bullet.bombDeleter(false)
end

function reimu_kekkai:render()
    for i = 1, self.n do
        Render("reimu_kekkai", self.x, self.y, self.list[i].rot, self.list[i].scale)
    end
end
--#endregion
--#region sp_ef1
local reimu_sp_ef1 = Class(Object)
function reimu_sp_ef1:init(img, x, y, v, angle, trail, dmg, t, player)
    self.group = GROUP_PLAYER_BULLET
    self.layer = LAYER_PLAYER_BULLETS
    self.img = img
    self.hscale, self.vscale = 1.2, 1.2
    self.a, self.b = 1.2, 1.2
    self.x, self.y = x, y
    self.rot, self.angle = angle, angle
    self.v = v
    self.trail = trail
    self.dmg = dmg
    self.DMG = dmg
    self.bound = false
    self.tflag = t
    self.player = player
end

function reimu_sp_ef1:frame()
    if IsInPlayfield(self) then
        self.inscreen = true
    else
        self.inscreen = false
    end
    if self.timer < 150 + self.tflag then
        self.rot = self.angle - 4 * self.timer - 90
        self.x = self.timer * cos(self.rot + 90) + self.player.x
        self.y = self.timer * sin(self.rot + 90) + self.player.y
    end
    if self.timer > 150 + self.tflag then
        self.dmg = 35
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
        self.vx = 8 * cos(self.rot)
        self.vy = 8 * sin(self.rot)
        if self.inscreen then
            if self.x >  192 then self.x =  192 self.vx = 0 self.vy = 0 end
			if self.x < -192 then self.x = -192 self.vx = 0 self.vy = 0 end
			if self.y >  224 then self.y =  224 self.vx = 0 self.vy = 0 end
			if self.y < -224 then self.y = -224 self.vx = 0 self.vy = 0 end
        end
    end
    if self.timer > 230 then
        self.dmg = 0.4 * self.DMG
        self.a = 2 * self.a
        self.b = 2 * self.b
        self.hscale = (self.timer - 230) * 0.5 + 1
        self.vscale = (self.timer - 230) * 0.5 + 1
    end
    if self.timer > 240 then
        Kill(self)
    end
    Bullet.bombDeleter(false)
end
--#endregion

---@class lstg.Player.Reimu.Behavior.Spell : lstg.Player.Behavior
local M = {}
M.name = "Spell"

function M:init()
    self.bombing = false
    self.next_spell = 0

    ---@type lstg.Player.Behavior.Move
    ---@diagnostic disable-next-line: assign-type-mismatch
    self.move = self.player:getBehavior("Move")

    ---@type lstg.Player.Behavior.Death
    ---@diagnostic disable-next-line: assign-type-mismatch
    self.death = self.player:getBehavior("Death")

    LoadTexture("reimu_kekkai", "players/reimu_player/reimu_kekkai.png")
    LoadImage("reimu_kekkai", "reimu_kekkai", 0, 0, 256, 256, 0, 0)
    SetImageState("reimu_kekkai", "mul+add", Color(0x804040FF))

    LoadPS("reimu_sp_ef", "players/reimu_player/reimu_sp_ef.psi", "parimg1", 16, 16)
end

function M:frame()
    if not self.death.canAct(self.death) then
        return
    end

    if self.next_spell == 0 and self.bombing then
        self:bomb()
    end

    if self.next_spell ~= 0 then
        self.next_spell = self.next_spell - 1
    end
end

function M:bomb()
    self.death:cancelDeath()
    self.bombing = false

    self.player.collect_line = self.player.collect_line - 300
    Task.new(self, function()
        Task.wait(90)
        self.player.collect_line = self.player.collect_line + 300
    end)

    if self.move.focus == 1 then
        PlaySound("power1", 0.8)
        PlaySound("cat00", 0.8)

        misc.ShakeScreen(210, 3)
        New(reimu_kekkai, self.player.x, self.player.y, 1.25, 12, 20, 12)
        self.next_spell = 240
        self.player.protect = 360
    else
        PlaySound("nep00", 0.8)
        PlaySound("slash", 0.8)
        local rot = ran:Int(0, 360)
        for i = 1, 8 do
            New(reimu_sp_ef1, "reimu_sp_ef", self.player.x, self.player.y, 8, rot + i * 45, 1200, 1, 40 - 10 * i, self.player)
        end

        self.next_spell = 300
        self.player.protect = 360
    end
end

---@param key_name KnownKeys
---@param is_down boolean
function M:OnKeyAction(key_name, is_down)
    if key_name == "Bomb" then
        self.bombing = is_down
    end
end

function M:debug()
    if ImGui.Button("Bomb right now fucking hell") then
        self.bombing = true
    end
end

return M