---@class lstg.Player.Reimu.Behavior.Shoot : lstg.Player.Behavior
local M = {}
M.name = "Shoot"

function M:init()
    self.shoot_timer = 4
    self.next_shoot = self.shoot_timer
    self.fire = false
    self.debug_fire = false
end

function M:frame()
    ---@type lstg.Player.Behavior.Death
    ---@diagnostic disable-next-line: assign-type-mismatch
    self.death = self.player:getBehavior("Death")
    if not self.death.canAct(self.death) then
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
end

---@param key_name KnownKeys
---@param is_down boolean
function M:OnKeyAction(key_name, is_down)
    if key_name == "Shoot" then
        self.fire = is_down
    end
end

local imgui_exists, imgui = pcall(require, "imgui")
local ImGui = imgui.ImGui

function M:debug()
    _, self.debug_fire = ImGui.Checkbox("Continuous shooting", self.debug_fire)
end

return M