---@class lstg.Player.Behavior.Power : lstg.Player.Behavior
local M = {}
M.name = "Power"
M.priority = 0

function M:init()
    self.min_power = 0
    self.min_safe_power = 100
    self.max_power = 400

    self.current_power = 0

    self.lose_power_by_dying = false
    self.lose_power_by_dying_amount = 50
    if self.lose_power_by_dying then
        lstg.Signals:register("player_system:death", "player_system:lostPower", function()
            self.current_power = clamp(self.current_power - self.lose_power_by_dying_amount, self.min_safe_power, self.max_power)
        end)
    end

    lstg.Signals:register("item:getPower", "player_system:getPower", function(amount)
        local before = int(self.current_power / 100)
        self.current_power = clamp(self.current_power + amount, self.min_power, self.max_power)
        local after = int(self.current_power / 100)
        if after > before then
            PlaySound("powerup1", 0.5)
        end
        -- If get more power than max amount possible, add to score.
        if self.current_power >= self.max_power then
            lstg.var.score = lstg.var.score + amount * 100
        end
    end)
end

function M:frame()

end

function M:debug()
    success, value = ImGui.InputInt("Current Power value", self.current_power, 1, 5, "%.1f")
    if success then
        self.current_power = clamp(value, self.min_power, self.max_power)
    end
end

BasePlayerBehaviors[M.name] = M