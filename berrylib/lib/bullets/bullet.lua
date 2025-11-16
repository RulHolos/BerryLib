---@class lstg.Bullet : lstg.object
Bullet = Class(Object)

---@enum lstg.Bullet.Color
Bullet.COLOR = {
    DEEP_RED = 1,
    RED = 2,
    DEEP_PURPLE = 3,
    PURPLE = 4,
    DEEP_BLUE = 5,
    BLUE = 6,
    ROYAL_BLUE = 7,
    CYAN = 8,
    DEEP_GREEN = 9,
    GREEN = 10,
    CHARTREUSE = 11,
    YELLOW = 12,
    GOLDEN_YELLOW = 13,
    ORANGE = 14,
    DEEP_GRAY = 15,
    GRAY = 16,
}

local bullet_data = require("assets.bullets").data.bullet_data

function Bullet:init(bullet_type, color, indes)
    self.group = GROUP_ENEMY_BULLET
    if indes then
        self.group = GROUP_INDES
    end

    local idx
    if bullet_data[bullet_type][1] == 16 then
        idx = color
    else
        idx = math.floor((color + 1) / 2)
    end

    self.color = color
    self.bullet_type = bullet_type
    self.blend = bullet_data[bullet_type][3]
    self._blend = self.blend
    self.img = "bullet:" .. bullet_type .. idx
    self.layer = LAYER_ENEMY_BULLETS - bullet_data[bullet_type][2] + color * 0.00001
    self.wait = 0

    Task.new(self, function()
        for i = 1, 12 do
            self._a = i * 255 / 12
            self.hscale = (12 - i) / 12 + 0.5 + bullet_data[bullet_type][2]
            self.vscale = (12 - i) / 12 + 0.5 + bullet_data[bullet_type][2]
            Task.wait()
        end
        self.colli = true
    end)
end

function Bullet:frame()
    Task.Do(self)
end

function Bullet:kill()
    local l, r, b, t = GetBound()
    if BoxCheck(self, l, r, b, t) then
        New(BulletBreak, self)
    end
end

function Bullet:del()
    local l, r, b, t = GetBound()
    if BoxCheck(self, l, r, b, t) then
        New(BulletBreak, self)
    end
end

---@class lstg.BulletBreak : lstg.object
BulletBreak = Class(Object)

---@param bullet lstg.Bullet
function BulletBreak:init(bullet)
    self.group = GROUP_GHOST
    self.color = bullet.color
    self.bullet_type = bullet.bullet_type
    self.blend = bullet.blend
    self._blend = bullet.blend
    self.img = bullet.img
    self.x, self.y = bullet.x, bullet.y
    self.rot = bullet.rot
    self.hscale, self.vscale = bullet.hscale, bullet.vscale
    self.dhscale, self.dvscale = bullet.hscale / 24, bullet.vscale / 24
    self.omiga = bullet.omiga
    self.vx = bullet.vx
    self.vy = bullet.vy
    self.ax = -bullet.vx * 0.016
    self.ay = -bullet.vy * 0.016
    self.layer = bullet.layer - 50
    self.bound = true
end

function BulletBreak:frame()
    self.hscale = self.hscale + self.dhscale
    self.vscale = self.vscale + self.dvscale
    self._a = 255 - self.timer * 10.6
    if self.timer >= 25 then
        Del(self)
    end
end

--- Fires a single bullet.
---@param bullet_type string
---@param color lstg.Bullet.Color
---@param x number
---@param y number
---@param v number
---@param ang number
---@param aim boolean?
---@param indes boolean?
---@param wait integer?
---@return lstg.Bullet
function Bullet.fire(bullet_type, color, x, y, v, ang, aim, indes, wait)
    local b = New(Bullet, bullet_type, color, indes)
    b.x = x
    b.y = y
    if aim and IsValid(lstg.var.player) then
        ang = ang + Angle(b, lstg.var.player)
    end
    if wait then
        b.rot = ang
        b.wait = wait
        Task.new(b, function()
            Task.wait(wait)
            if IsValid(b) then
                SetV(b, v, ang, true)
            end
        end)
    else
        SetV(b, v, ang, true)
    end
    return b
end

function Bullet.bombDeleter(kill_indes)
    for _, v in ObjList(GROUP_ENEMY_BULLET) do
        Kill(v)
    end
    if kill_indes then
        for _, v in ObjList(GROUP_INDES) do
            Kill(v)
        end
    end
end