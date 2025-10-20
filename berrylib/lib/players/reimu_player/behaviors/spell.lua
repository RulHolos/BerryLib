local reimu_sp_ef1 = Class(Object)
function reimu_sp_ef1:init(img, x, y, v, angle, target, trail, dmg, t, player)
    
end

---@class lstg.Player.Reimu.Behavior.Spell : lstg.Player.Behavior
local M = {}
M.name = "Spell"

function M:init()
    self.bombing = false
    self.next_spell = 0

    ---@type lstg.Player.Behavior.Move
    ---@diagnostic disable-next-line: assign-type-mismatch
    self.move = self.player:getBehavior("Move")
end

function M:frame()
    ---@type lstg.Player.Behavior.Death
    ---@diagnostic disable-next-line: assign-type-mismatch
    self.death = self.player:getBehavior("Death")
    if not self.death.canAct(self.death) then
        return
    end
end

function M:shoot()
    self.player.collect_line = self.player.collect_line - 300
    Task.New(self, function()
        Task.Wait(90)
        self.player.collect_line = self.player.collect_line + 300
    end)

    if self.move.focus or self.move.force_focus then
        PlaySound("power1", 0.8)
        PlaySound("cat00", 0.8)

        self.next_spell = 240
        self.player.protect = 360
    else
        PlaySound("nep00", 0.8)
        PlaySound("slash", 0.8)
        local rot = ran:Int(0, 360)
        for i = 1, 8 do

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