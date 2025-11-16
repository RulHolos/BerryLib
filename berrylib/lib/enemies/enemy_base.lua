---@class berry.enemy.death : lstg.object
local enemyDeath = Class(Object)

function enemyDeath:init(x, y)
    if LoadImageFromFile("enm:die", "enemies/enemy_die.png", true) then
        SetImageCenter("enm:die", 108 / 2, 108 / 2)
    end
    self.img = "enm:die"
    self.layer = LAYER_ENEMIES + 50
    self.group = GROUP_GHOST
    self.x, self.y = x, y
    PlaySound("enep00", 0.3, self.x / (Screen.playfield.width / 2), true)
end

function enemyDeath:frame()
    if self.timer == 30 then
        Del(self)
    end
end

function enemyDeath:render()
    local alpha = 1 - self.timer / 30
    alpha = 255 * alpha ^ 2

    SetImageState(self.img, "", Color(alpha, 255, 255, 255))
    Render(self.img, self.x, self.y, 15, 0.4 - self.timer * 0.01, self.timer * 0.1 + 0.7)
    Render(self.img, self.x, self.y, 75, 0.4 - self.timer * 0.01, self.timer * 0.1 + 0.7)
    Render(self.img, self.x, self.y, 135, 0.4 - self.timer * 0.01, self.timer * 0.1 + 0.7)
end

---@class berry.enemy_base : lstg.object
EnemyBase = Class(Object)

---@alias EnemyTypes
---| "fairy"
---| "kedama"
---| "yinyang"
---| "ghost"
---| nil

---@param style integer
---@return EnemyTypes
local function getTypeFromStyle(style)
    if style <= 18 then
        return "fairy"
    elseif style <= 22 then
        return "kedama"
    elseif style <= 26 then
        return "yinyang"
    elseif style <= 34 then
        return "ghost"
    else
        return nil
    end
end

---@param x number x position
---@param y number y position
---@param hp number Max hp count
---@param invincible boolean Will change the group to NONTJT if true
---@param auto_delete boolean Will bound if true
---@param style integer
---@param drop table<any, integer> Table of objects to drop
function EnemyBase:init(x, y, hp, invincible, auto_delete, style, drop)
    self.damage = EnemyBase.damage

    self.layer = LAYER_ENEMIES
    if invincible then
        self.group = GROUP_NONTJT
    else
        self.group = GROUP_ENEMY
    end
    self.invincible = invincible
    self.x, self.y = x, y
    self.bound = auto_delete
    self.colli = true
    self.max_hp = hp
    self.hp = hp
    self.servants = {}
    self.style = style
    self.drop = drop or {} -- Format can be : { power_item = 2, point_item = 4 }
    self.show_hp_count = true
    ---@type EnemyTypes
    self.type = getTypeFromStyle(style)
    self.renderer = nil
    if self.type ~= nil then
        self.renderer = nil
    end
end

function EnemyBase:frame()
    Task.Do(self)
    if self.hp <= 0 then
        Kill(self)
    end
end

function EnemyBase:render()
    if self.hp < self.max_hp and self.show_hp_count then
        -- TODO: render text
    end
    Render("white", self.x, self.y, self.rot, 0.5)
end

function EnemyBase:colli(other)
    if other.dmg then
        local dmg = math.abs(other.dmg)
        lstg.var.score = lstg.var.score + (8 * dmg)
        self:damage(dmg)
    end

    other.killenemy = self
    if not other.killflag then
        Kill(other)
    end

    if self.hp > 60 then
        if self.hp > self.max_hp * 0.2 then
            PlaySound("damage00", 0.4, self.x / (Screen.playfield.width / 2))
        else
            PlaySound("damage01", 0.6, self.x / (Screen.playfield.width / 2))
        end
    else
        PlaySound("damage00", 0.35, self.x / (Screen.playfield.width / 2), true)
    end
end

function EnemyBase:damage(dmg)
    if self.invincible then
        return
    end
    dmg = abs(dmg)
    self.hp = clamp(self.hp - dmg, 0, self.max_hp)
end

function EnemyBase:kill()
    New(enemyDeath, self.x, self.y)
    if self.drop then
        item.dropItem(self.x, self.y, self.drop)
    end

    for _, unit in ipairs(self.servants) do
        Kill(unit)
    end
end

function EnemyBase:del()
    for _, unit in ipairs(self.servants) do
        Kill(unit)
    end
end

lstg.RegisterGameObjectClass(EnemyBase)

