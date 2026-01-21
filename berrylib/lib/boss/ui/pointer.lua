---@class berry.boss.ui.pointer : lstg.object
local M = Class(Object)

---@param ui berry.boss.ui
function M:init(ui)
    self.ui = ui
    self.alpha = 0
    self.layer = LAYER_TOP + 1
    self.y = Screen.playfield.screen_bottom + 8
    self.scale = 1
    self.EnemyIndicater = 0

    LoadImage("ui:boss_pointer", "ui:boss_ui", 0, 64, 48, 16)
    SetImageCenter("ui:boss_pointer", 24, 0)

    lstg.Signals:register("GameUI:render", "BossPointer", function()
        local w = Screen.playfield
        local scale = self.scale
        self.ui.manager:foreachBoss(false, true, function(b)
            local x, y = b.x, self.y
            local distsub = 1
            distsub = min((1 - (min(abs(x - lstg.var.player.x), 64) / 128)), distsub)

            local hpsub = (sin(self.EnemyIndicater + 270) + 1) * 0.125
            local alpha = (1 - distsub * 0.4 - hpsub) * 255
            SetImageState("ui:boss_pointer", "", Color(alpha, 255, 255, 255))
            x, _ = WorldToUI(x, y)
            SetViewMode("ui")
            Render("ui:boss_pointer", x, y, 0, self.scale)
        end)
        SetViewMode("world")
    end, 9999)
end

function M:frame()
    local current_spell = self.ui.manager.card_system.current_card
    if not current_spell then return end

    if current_spell.hp >= 0 then
        self.EnemyIndicater = self.EnemyIndicater + (max(0, (current_spell.max_hp / 2 - current_spell.hp))) / (current_spell.max_hp / 2) * 90
    end
end

function M:render()
end

---@nodiscard
---@param ui berry.boss.ui
---@return berry.boss.ui.pointer
function M.create(ui)
    return New(M, ui)
end

return M