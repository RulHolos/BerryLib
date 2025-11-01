local Death_Eff2 = Class(Object)

function Death_Eff2:init(x, y)
    self.x, self.y = x, y
    self.img = "player_death_ef"
    self.layer = LAYER_PLAYER + 50
end

function Death_Eff2:frame()
    if self.timer == 4 then
        ParticleStop(self)
    end
    if self.timer == 60 then
        Del(self)
    end
end

local Death_Eff = Class(Object)

function Death_Eff:init(x, y, _type)
    self.x, self.y = x, y
    self.type = _type
    self.size, self.size1 = 0, 0
    self.layer = LAYER_TOP - 1
    Task.New(self, function()
        local size, size1 = 0, 0
        if self.type == "second" then
            Task.Wait(30)
        end
        for _ = 1, 360 do
            self.size = size
            self.size1 = size1
            size = size + 12
            size1 = size1 + 8
            Task.Wait(1)
        end
    end)
end

function Death_Eff:frame()
    Task.Do(self)
    if self.timer > 180 then
        Del(self)
    end
end

function Death_Eff:render()
    if self.type == "first" then
        render_circle(self.x, self.y, self.size, 60)
        render_circle(self.x + 35, self.y + 35, self.size1, 60)
        render_circle(self.x + 35, self.y - 35, self.size1, 60)
        render_circle(self.x - 35, self.y + 35, self.size1, 60)
        render_circle(self.x - 35, self.y - 35, self.size1, 60)
    elseif self.type == "second" then
        render_circle(self.x, self.y, self.size, 60)
    end
end

---@class lstg.Player.Behavior.Death : lstg.Player.Behavior
local M = {}
M.name = "Death"
M.priority = 110

function M:init()
    self.dtimer = 0
    self.dstate = 0

    ---@type integer Number of grace frames period where the player can bomb to perform a deathbomb. Cannot be less than 1.
    self.grace_frames = 10
end

function M:updateState()
    if self.dtimer == 0 or self.dtimer > 90 then
        self.dstate = 0
    elseif self.dtimer == 90 then
        self.dstate = 1
    elseif self.dtimer == 84 then
        self.dstate = 2
    elseif self.dtimer == 50 then
        self.dstate = 3
    elseif self.dtimer < 50 then
        self.dstate = 4
    else
        self.dstate = -1
    end
end

function M:frame()
    self:updateState()

    self:doState1()
    self:doState2()
    self:doState3()
    self:doState4()

    if self.dtimer > 0 then
        self.dtimer = self.dtimer - 1
    end
end

function M:doState1()
    if self.dstate ~= 1 then return end

    -- Do the effects
    --lstg.var.life_left[self.player.index] = lstg.var.life_left[self.player.index] - 1

    self.deathee = {}
    self.deathee[1] = New(Death_Eff, self.player.x, self.player.y, "first")
    self.deathee[2] = New(Death_Eff, self.player.x, self.player.y, "second")
    New(Death_Eff2, self.player.x, self.player.y)
end

function M:doState2()
    if self.dstate ~= 2 then return end

    self.player.hide = true
    self.player.protect = 60*4
end

function M:doState3()
    if self.dstate ~= 3 then return end

    self.player.x, self.player.y = 0, -236
end

function M:doState4()
    if self.dstate ~= 4 then return end

    self.player.hide = false
    self.player.y = -192 - (1.2 * (self.dtimer - 1))
end

---@param other lstg.object
function M:colli(other)
    if self.dtimer == 0 and not self.player.in_dialog then
        if self.player.protect == 0 then
            PlaySound("pldead00", 0.5)
            self.dtimer = 90 + self.grace_frames
        end
        if other and other.group == GROUP_ENEMY_BULLET then
            Del(other)
        end
    end
end

function M:cancelDeath()
    self.dtimer = 0
    self.dstate = 0
    self.grace_timer = 0
end

---@param d lstg.Player.Behavior.Death|nil
---@return boolean @Can act
function M.canAct(d)
    return d ~= nil and d.dstate == 0
end

function M:debug()
    if ImGui.Button("Kill") then
        ---@diagnostic disable-next-line: param-type-mismatch
        self:colli(nil)
    end

    local success, value = ImGui.InputInt("Death State", self.dstate, 1, 1)
    if success then
        self.dstate = clamp(value, 0, 4)
    end

    success, value = ImGui.InputInt("Grace Frames", self.grace_frames, 1, 2)
    if success then
        self.grace_frames = clamp(value, 1, 60)
    end
end

BasePlayerBehaviors[M.name] = M