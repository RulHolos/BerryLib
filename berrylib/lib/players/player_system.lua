---@type lstg.Player.Behavior[]
BasePlayerBehaviors = {}

---@class lstg.Player : lstg.object
PlayerSystem = Class(Object)

function PlayerSystem:init()
    lstg.var.player = self

    self.x, self.y = 0, -192

    self.layer = LAYER_PLAYER
    self.group = GROUP_PLAYER

    self.name = ""
    self.protect = 0
    self.scale = 1

    ---@type boolean Set by the dialog manager. Don't set yourself.
    self.in_dialog = false
    self.collect_line = 96

    self.grazer = New(PlayerGrazer, self)

    self.attachBehavior = PlayerSystem.attachBehavior
    self.detachBehavior = PlayerSystem.detachBehavior
    self.getBehavior = PlayerSystem.getBehavior
    self.AfterFrame = PlayerSystem.AfterFrame

    ---@type lstg.Player.Behavior[]
    self.behaviors = {}
    for _, v in pairs(BasePlayerBehaviors) do
        self:attachBehavior(v)
    end
    for _, v in pairs(self.behaviors) do
        if v.init then
            v:init()
        end
    end
    self.behaviors_initialized = true

    ---@param key_name KnownKeys
    ---@param is_down boolean
    lstg.Signals:register("KeyStateChanged", "PlayerSystem:do_input", function(key_name, is_down)
        for _, v in ipairs(self.behaviors) do
            if v.OnKeyAction then
                v:OnKeyAction(key_name, is_down)
            end
        end
    end)

    lstg.Signals:emit("PlayerSystem:PlayerInstanciated", self)
end

-- TODO: Change those 4 calls to signals.

function PlayerSystem:frame()
    for _, behavior in ipairs(self.behaviors) do
        if behavior.frame then
            behavior:frame()
        end
    end

    self:AfterFrame()

    self.protect = clamp(self.protect - 1, 0, INF)
end

function PlayerSystem:AfterFrame()
    for _, behavior in ipairs(self.behaviors) do
        if behavior.afterFrame then
            behavior:afterFrame()
        end
    end
end

function PlayerSystem:render()
    for _, behavior in ipairs(self.behaviors) do
        if behavior.render then
            behavior:render()
        end
    end
end

---@param other lstg.object
function PlayerSystem:colli(other)
    for _, behavior in ipairs(self.behaviors) do
        if behavior.colli then
            behavior:colli(other)
        end
    end
end

---@param behavior lstg.Player.Behavior
function PlayerSystem:attachBehavior(behavior)
    behavior = makeInstance(behavior)
    behavior.player = self
    if behavior.init and self.behaviors_initialized then
        behavior:init()
    end
    if not behavior or not behavior.name then
        error("Behavior must have a name or object is invalid.")
    end
    if behavior.onAttach then
        behavior:onAttach(self)
    end

    table.insert(self.behaviors, behavior)
    table.sort(self.behaviors, function(a, b)
        return (a.priority or 0) > (b.priority or 0)
    end)
end

---@param name string
function PlayerSystem:detachBehavior(name)
    local behavior = self.behaviors[name]
    if behavior and behavior.onDetach then
        behavior:onDetach(self)
    end
    self.behaviors[name] = nil
end

---@param name string
---@return lstg.Player.Behavior
function PlayerSystem:getBehavior(name)
    local b
    for _, v in ipairs(self.behaviors) do
        if v.name == name then
            b = v
        end
    end
    --if b == nil then
    --    error(("The behavior named %s doesn't exist"):format(name))
    --end
    return b
end

function PlayerSystem:kill()
    for _, v in ipairs(self.behaviors) do
        self:detachBehavior(v.name)
    end

    lstg.var.player = nil

    Del(self)
end

----------------------------------------------
--- Behaviors

---@class lstg.Player.Behavior
---@field name string
---@field enabled boolean Mostly for debugging purposes.
---@field priority integer Higher means being executed first
---@field player lstg.Player Is defined when attached.
---@field init fun(self: lstg.Player.Behavior)?
---@field frame fun(self: lstg.Player.Behavior)?
---@field afterFrame fun(self: lstg.Player.Behavior)?
---@field render fun(self: lstg.Player.Behavior)?
---@field colli fun(self: lstg.Player.Behavior, other: lstg.object)?
---@field onAttach fun(self: lstg.Player.Behavior, player: lstg.Player)?
---@field onDetach fun(self: lstg.Player.Behavior, player: lstg.Player)?
---@field OnKeyAction fun(self: lstg.Player.Behavior, key_name: KnownKeys, is_down: boolean)?
---@field debug fun(self: lstg.Player.Behavior)? Optional callback for the Player Debugger in ImGui.

--- Include behaviors here
local patch = "lib/players/base_behaviors/"
Include(patch .. "move.lua")
Include(patch .. "death.lua")
Include(patch .. "power.lua")
Include(patch .. "collect_items.lua")

----------------------------------------------
--- Players

--- TODO: Rework this
---@type table<string, string, lstg.Player>
PlayerDefList = {}

function AddPlayerToPlayerList(display_name, replay_name, class)
    table.insert(PlayerDefList, { display_name, replay_name, class })
end

Include("lib/players/reimu_player/reimu.lua")


--- Grazer

--[[
This object needs to be an actual object and not a behavior because of multiple reasons.
But the best reason is that it must be on a different layer than the player, and also
have its own collider callback, since it has a different collider size.
]]

PlayerGrazer = Class(Object)
---@param player lstg.Player
function PlayerGrazer:init(player)
    self.layer = LAYER_ENEMY_BULLETS_EF + 50
    self.group = GROUP_PLAYER
    self.player = player
    self.grazed = false
    self.img = "player:graze"
    ParticleStop(self)
    self.a = 24
    self.b = 24
    self.aura = 0
    self.aura_d = 0
    self._slow_timer = 0
    self._pause = 0
    self._collectCounter = 0

    self.move = nil
    self.death = nil

    LoadTexture("tex:ItemCollectRing", "general/white.png")
    LoadImageGroup("ItemCollectRing", "tex:ItemCollectRing", 0, 0, 110, 62, 1, 10)
    for i = 1, 10 do
        SetImageState("ItemCollectRing" .. i, "mul+add", Color(0x80FFFFFF))
    end
end

function PlayerGrazer:frame()
    if not IsValid(self.player) then
        lstg.MsgBoxWarn("Player invalid. Grazer initialized before player. You're doing something wrong somewhere.")
        Del(self)
        return
    end

    ---@type lstg.Player.Behavior.Move
    ---@diagnostic disable-next-line: assign-type-mismatch
    self.move = self.player:getBehavior("Move")

    ---@type lstg.Player.Behavior.Death
    ---@diagnostic disable-next-line: assign-type-mismatch
    self.death = self.player:getBehavior("Death")

    local alive = (self.death.dtimer == 0 or self.death.dtimer > 90)
    if alive then
        self.x = self.player.x
        self.y = self.player.y
        self.hide = self.player.hide
    end
    if self.move.focus == 1 then
        self._slow_timer = min(self._slow_timer + 1, 30)
        self._collectCounter = min(self._collectCounter + 1, 20)
        item.UpdateCollectRingRadius(self._collectCounter)
    else
        self._slow_timer = 0
        self._collectCounter = max(self._collectCounter - 1, 0)
        item.UpdateCollectRingRadius(self._collectCounter)
    end
    if self._pause == 0 then
        self.aura = self.aura + 1.5
    end
    self._pause = max(0, self._pause - 1)
    self.aura_d = 180 * cos(90 * self._slow_timer / 30) ^ 2

    if self.grazed then
        PlaySound("graze", 0.3, self.x / 200)
        self.grazed = false
        ParticleFire(self)
    else
        ParticleStop(self)
    end
end

function PlayerGrazer:render()
    Object.render(self)
    SetImageState("player:aura", "", Color(0xC0FFFFFF))
    Render("player:aura", self.x, self.y, -self.aura + self.aura_d, self.move.slow_lh)
    SetImageState("player:aura", "", Color(0xC0FFFFFF) * self.move.slow_lh + Color(0x00FFFFFF) * (1 - self.move.slow_lh))
    Render("player:aura", self.x, self.y, self.aura, 2 - self.move.slow_lh)

    -- Item collection ring effect. Is a plain white texture for base release, but can be changed in PlayerGraze:init.
    if item.GetCollectRingRadius() >= 8 then
        misc.RenderRing("ItemCollectRing", self.x, self.y,
            item.GetCollectRingRadius() - 8,
            item.GetCollectRingRadius(),
            -self.timer,
            50, 10
        )
    end
end

---@param other lstg.object
function PlayerGrazer:colli(other)
---@diagnostic disable-next-line: undefined-field
    if other.group ~= GROUP_ENEMY and (not (other._grazed) or other._inf_graze) then
        self.grazed = true
---@diagnostic disable-next-line: undefined-field
        if not (other._inf_graze) then
            other._grazed = true
        end
    end
end