---@class berry.UI.Component.BossPointer : berry.UI.Component
local M = {}
M.name = "BossPointer"
M.priority = -1

function M:init()
    self.alpha = 0
    self.y = Screen.playfield.screen_bottom
    self.scale = 1
    self.EnemyIndicater = 0
end

function M:frame()
    if not lstg.var.boss_manager then return end
    local current_spell = lstg.var.boss_manager.card_system.current_card
    if not current_spell then return end

    if current_spell.hp >= 0 then
        self.EnemyIndicater = self.EnemyIndicater + (max(0, (current_spell.max_hp / 2 - current_spell.hp))) / (current_spell.max_hp / 2) * 90
    end
end

function M:render()
    if not lstg.var.boss_manager then return end
    local scale = self.scale
    lstg.var.boss_manager:foreachBoss(false, true, function(b)
        if not IsValid(b) then return end
        local x, _ = WorldToUI(b.x, b.y)
        local y = self.y
        local distsub = 1
        distsub = min((1 - (min(abs(b.x - lstg.var.player.x), 64) / 128)), distsub)

        local hpsub = (sin(self.EnemyIndicater + 270) + 1) * 0.125
        local alpha = (1 - distsub * 0.4 - hpsub) * 255
        SetImageState("ui:boss_pointer", "", Color(alpha, 255, 255, 255))
        Render("ui:boss_pointer", x, y, 0, 1)
    end)
end

function M:debug()
end

GameUI.registerBaseComponent(M)