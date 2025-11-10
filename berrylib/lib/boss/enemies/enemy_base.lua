---@class berry.enemy_base : lstg.object
EnemyBase = Class(Object)

---@param x number x position
---@param y number y position
---@param hp number Max hp count
---@param invincible boolean Will change the group to NONTJT if true
---@param auto_delete boolean Will bound if true
---@param style any
---@param drop table<any, integer> Table of objects to drop
function EnemyBase:init(x, y, hp, invincible, auto_delete, style, drop)
    self.damage = EnemyBase.damage

    self.layer = LAYER_ENEMIES
    if invincible then
        self.group = GROUP_NONTJT
    else
        self.group = GROUP_ENEMY
    end
    self.x, self.y = x, y
    self.bound = auto_delete or true
    self.colli = true
    self.max_hp = hp
    self.hp = hp
    self.servants = {}
    self.style = style
    self.drop = drop or {} -- Format can be : { power_item = 2, point_item = 4 }
end

function EnemyBase:frame()
    Task.Do(self)
    if self.hp <= 0 then
        Kill(self)
    end
end

function EnemyBase:render()
    -- TODO: Walk img
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
    dmg = abs(dmg)
    self.hp = clamp(self.hp - dmg, 0, self.max_hp)
end

function EnemyBase:kill()
    New(EnemyDeath, self.x, self.y)
    if self.drop then
        --item.dropItem(self.x, self.y, self.drop)
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