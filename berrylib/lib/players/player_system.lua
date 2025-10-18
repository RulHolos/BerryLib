---@type lstg.Player.Behavior[]
BasePlayerBehaviors = {}

---@class lstg.Player : lstg.object
PlayerSystem = Class(Object)

---@param index integer Player index, p1, p2. BerryLib natively supports only two players at max.
function PlayerSystem:init(index)
    index = index or 1
    self.index = index

    self.layer = LAYER_PLAYER
    self.group = GROUP_PLAYER

    self.name = ""
    self.protect = 0
    self.scale = 1

    self.attachBehavior = PlayerSystem.attachBehavior
    self.detachBehavior = PlayerSystem.detachBehavior
    self.getBehavior = PlayerSystem.getBehavior
    self.AfterFrame = PlayerSystem.AfterFrame

    ---@type lstg.Player.Behavior[]
    self.behaviors = {}
    for _, v in pairs(BasePlayerBehaviors) do
        self:attachBehavior(v)
    end

    ---@param p_index integer
    ---@param key_name KnownKeys
    ---@param is_down boolean
    lstg.Signals:register("KeyStateChanged", "PlayerSystem:do_input_p" .. index, function(p_index, key_name, is_down)
        if p_index ~= index then return end -- Not the right player

        for _, v in ipairs(self.behaviors) do
            if v.OnKeyAction then
                v:OnKeyAction(key_name, is_down)
            end
        end
    end)
end

function PlayerSystem:frame()
    for _, behavior in ipairs(self.behaviors) do
        if behavior.frame then
            behavior:frame(self)
        end
    end

    self:AfterFrame()

    self.timer = self.timer + 1
end

function PlayerSystem:AfterFrame()
    for _, behavior in ipairs(self.behaviors) do
        if behavior.afterFrame then
            behavior:afterFrame(self)
        end
    end
end

function PlayerSystem:render()
    for _, behavior in ipairs(self.behaviors) do
        if behavior.render then
            behavior:render(self)
        end
    end
end

---@param behavior lstg.Player.Behavior
function PlayerSystem:attachBehavior(behavior)
    behavior = makeInstance(behavior)
    behavior.player = self
    if behavior.init then
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
    for k, v in ipairs(self.behaviors) do
        if v.name == name then
            b = v
        end
    end
    if b == nil then
        error(("The behavior named %s doesn't exist"):format(name))
    end
    return b
end

----------------------------------------------
--- Behaviors

---@class lstg.Player.Behavior
---@field name string
---@field priority integer Higher means being executed first
---@field player lstg.Player Is defined when attached.
---@field init fun(self: lstg.Player.Behavior)?
---@field frame fun(self: lstg.Player.Behavior, player: lstg.Player)?
---@field afterFrame fun(self: lstg.Player.Behavior, player: lstg.Player)?
---@field render fun(self: lstg.Player.Behavior, player: lstg.Player)?
---@field onAttach fun(self: lstg.Player.Behavior, player: lstg.Player)?
---@field onDetach fun(self: lstg.Player.Behavior, player: lstg.Player)?
---@field OnKeyAction fun(self: lstg.Player.Behavior, key_name: KnownKeys, is_down: boolean)?

--- Include behaviors here
local patch = "lib/players/base_behaviors/"
Include(patch .. "move.lua")

--- Players
---@type table<string, string, lstg.Player>
PlayerList = {}

function AddPlayerToPlayerList(display_name, replay_name, class)
    table.insert(PlayerList, { display_name, replay_name, class })
end

Include("lib/players/reimu_player/reimu.lua")