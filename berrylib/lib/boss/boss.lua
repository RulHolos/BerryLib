---@class berry.boss.boss : berry.enemy_base
local M = Class(Object)

---@param name string Full name of the boss
---@param img string Image name of the boss
---@param x number Initial x pos
---@param y number Initial y pos
-----@param aura berry.boss.aura|nil
---@param manager berry.boss.boss_manager
function M:init(name, img, x, y, aura, manager)
    self.damage = M.damage
    self.move = M.move
    self.wander = M.wander
    self.explode = M.explode

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
    self.a, self.b = 20, 20
end

function M:frame()
    Task.Do(self)

    local card = self.manager.card_system.current_card
    if card then
        self.colli = not card.timeout -- True if not a timeout
    else
        self.colli = false -- Disable collisions if the boss isn't in a spell-card (for safety)
    end
end

function M:render()
    Render(self.img, self.x, self.y + cos(self.timer) * 4, 0)
end

function M:kill()
end

function M:del()
end

---@param other any Colliding object
function M:colli(other)
    if other.dmg then
        self:damage(other.dmg)
    end

    other.killerenemy = self
    if not (other.killflag) then
        Kill(other)
    end

    local card = self.manager.card_system.current_card
    if card then
        local hp = card.hp
        local max_hp = card.max_hp
        if hp > 60 then
            if hp > max_hp * 0.2 then
                PlaySound("damage00", 0.4, self.x / 192)
            else
                PlaySound("damage01", 0.6, self.x / 192)
            end
        else
            PlaySound("damage00", 0.35, self.x / 192, true)
        end
    end
end

---@param dmg number Amount of row damage taken
function M:damage(dmg)
    self.manager.hit_number = self.manager.hit_number + 1
    self.manager:dealDamage(dmg)
end

---@param destX number X-axis destination
---@param destY number Y-axis destination
---@param time integer Time in frames it takes to move
---@param mode 0|1|2|3 Easing mode
function M:move(destX, destY, time, mode)
    Task.moveToObj(self, destX, destY, time, mode)
end

---Wanders around the top of the field
function M:wander(time, move_mode)
    local dirx, diry = ran:Sign(), ran:Sign()
    local dx = ran:Float(16, 64)
    local dy = ran:Float(8, 16)
    if self.x + dx * dirx < -130 then
        dirx = 1
    end
    if self.x + dx * dirx > 130 then
        dirx = -1
    end
    if self.y + dy * diry < 100 then
        diry = 1
    end
    if self.y + dy * diry > 150 then
        diry = -1
    end

    self:move(self.x + dx * dirx, self.y + dy * diry, time, move_mode)
end

--#region Effects
    local boss_death_ef_unit = Class(Object)
    function boss_death_ef_unit:init(x, y, v, angle, lifetime, size)
        self.x, self.y = x, y
        self.rot = ran:Float(0, 360)
        SetV(self, v, angle)
        self.lifetime = lifetime
        self.omiga = 3
        self.layer = LAYER_ENEMIES + 50
        self.group = GROUP_GHOST
        self.bound = false
        self.img = "leaf"
        self.hscale, self.vscale = size, size
    end
    function boss_death_ef_unit:frame()
        if self.timer == self.lifetime then
            Del(self)
        end
    end
    function boss_death_ef_unit:render()
        if self.timer < 15 then
            SetImageState("leaf", "mul+add", Color(self.timer * 12, 255, 255, 255))
        else
            SetImageState("leaf", "mul+add", Color(((self.lifetime - self.timer) / (self.lifetime - 15)) * 180, 255, 255, 255))
        end
        DefaultRenderFunc(self)
    end

    local boss_death_ef = Class(Object)
    function boss_death_ef:init(x, y, playsound, shakescreen)
        if playsound then PlaySound("enep01", 0.4, 0) end
        self.hide = true
        if shakescreen then misc.ShakeScreen(30, 15) end
        for _ = 1, 70 do
            local angle = ran:Float(0, 360)
            local lifetime = ran:Int(40, 120)
            local l = ran:Float(100, 500)
            New(boss_death_ef_unit, x, y, l / lifetime, angle, lifetime, ran:Float(2, 4))
        end
        Del(self)
    end

--#endregion

function M:explode()
    local angle = ran:Float(-15, 15)
    local sign = ran:Sign()
    local velocity = 1.5
    PlaySound("enep01", 0.5)
    self.colli = false
    self.vx = sign * velocity * cos(angle)
    self.vy = velocity * sin(angle)
    if self.aura then
        self.aura.open = false
    end

    local lifetime, l
    for _ = 1, 60 do
        velocity = velocity * 0.98
        self.vx = sign * velocity * cos(angle)
        self.vy = velocity * sin(angle)
        lifetime = ran:Int(60, 90)
        l = ran:Float(100, 250)
        New(boss_death_ef_unit, self.x, self.y, l / lifetime, ran:Float(0, 360), lifetime, ran:Float(2, 3))
        Task.wait()
    end
    PlaySound("enep01", 0.5, self.x / 256)
    New(Death_Eff, self.x, self.y, "first")
    New(Death_Eff, self.x, self.y, "second")
    New(boss_death_ef, self.x, self.y)
    Del(self)
end

function M.create(name, img, x, y, aura, manager)
    return New(M, name, img, x, y, aura, manager)
end

lstg.RegisterGameObjectClass(M)

return M