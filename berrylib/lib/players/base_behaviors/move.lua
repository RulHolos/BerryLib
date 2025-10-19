---@class lstg.Player.Behavior.Move : lstg.Player.Behavior
local M = {}
M.name = "Move"
M.priority = 100

function M:init()
    self.normal_speed = 4
    self.focus_speed = 2
    self.focus = false
    self.force_focus = false
    self.move_up = false
    self.move_down = false
    self.move_left = false
    self.move_right = false
    self.lock = false

    self.dx = 0
end

function M:frame()
    ---@type lstg.Player.Behavior.Death
    ---@diagnostic disable-next-line: assign-type-mismatch
    self.death = self.player:getBehavior("Death")
    if not self.death.canAct(self.death) or self.lock then
        return
    end

    local dy, v = 0, self.normal_speed

    if self.focus or self.force_focus then
        v = self.focus_speed
    end
    if self.move_up then
        dy = dy + 1
    end
    if self.move_down then
        dy = dy - 1
    end
    if self.move_left then
        self.dx = self.dx - 1
    end
    if self.move_right then
        self.dx = self.dx + 1
    end

    if self.dx * dy ~= 0 then
        v = v * SQRT2_2
    end
    self.dx = v * self.dx
    dy = v * dy
    self.player.x = self.player.x + self.dx
    self.player.y = self.player.y + dy
    local l, r, b, t = GetPlayfieldScreenCoords()
    self.player.x = math.max(math.min(self.player.x, r - 4), l + 4)
    self.player.y = math.max(math.min(self.player.y, t - 4), b + 4)
end

function M:afterFrame()
    self.dx = 0
end

---@param key_name KnownKeys
---@param is_down boolean
function M:OnKeyAction(key_name, is_down)
    if key_name == "Focus" then
        self.focus = is_down
    end
    if key_name == "Up" then
        self.move_up = is_down
    end
    if key_name == "Down" then
        self.move_down = is_down
    end
    if key_name == "Left" then
        self.move_left = is_down
    end
    if key_name == "Right" then
        self.move_right = is_down
    end
end

function M:debug()
    local success, value = ImGui.InputFloat("Normal Speed", self.normal_speed, 0.5, 2, "%.1f")
    if success then
        self.normal_speed = value
    end

    success, value = ImGui.InputFloat("Focus Speed", self.focus_speed, 0.5, 2, "%.1f")
    if success then
        self.focus_speed = value
    end

    _, self.force_focus = ImGui.Checkbox("Force focus", self.force_focus)
    _, self.lock = ImGui.Checkbox("Lock movement", self.lock)
end

BasePlayerBehaviors[M.name] = M