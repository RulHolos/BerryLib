---@class berry.boss.ui.hp : lstg.object
local M = Class(Object)

---@param ui berry.boss.ui
function M:init(ui)
    self.alpha = 0
    self.ui = ui

    LoadImageFromFile("ui:hp_rail", "boss/hp_rail.png")
    LoadImageFromFile("ui:hp_node", "boss/hp_node3.png")
    LoadTexture("ui:hp_line", "boss/hp_line.png")
    LoadImage("ui:hp_line0", "ui:hp_line", 0, 0, 512, 512)
    LoadImage("ui:hp_line1", "ui:hp_line", 0, 0, 256, 256)
    SetImageCenter("ui:hp_line1", 256, 256)
    LoadImage("ui:hp_line2", "ui:hp_line", 256, 0, 256, 256)
    SetImageCenter("ui:hp_line2", 0, 256)
    LoadImage("ui:hp_line3", "ui:hp_line", 0, 256, 256, 256)
    SetImageCenter("ui:hp_line3", 256, 0)
    LoadImage("ui:hp_line4", "ui:hp_line", 256, 256, 256, 256)
    SetImageCenter("ui:hp_line4", 0, 0)
end

function M:frame()
end

function M:render()
    self.ui.manager:foreachBoss(false, true, function(b)
        local current_spell = self.ui.manager.card_system.current_card
        if not current_spell then return end

        local color = Color(self.alpha, 255, 255, 255)
        local k = current_spell.hp / current_spell.max_hp
        SetImageState("ui:hp_rail", "", color)
        for i = 0, 4 do
            SetImageState("ui:hp_line" .. i, "", color)
        end

        local z, scale = 0.5, 0.5
        local w, h = GetTextureSize("ui:hp_line")
        local wr = h * scale

        if k < 0.25 then
            local a = 90 + 90 * (k * 4)
            RenderTexture("ui:hp_line", ""
                , { b.x, b.y + wr, z, w / 2, -h / 2, color }
                , { b.x, b.y + wr, z, w / 2, -h / 2, color }
                , { b.x, b.y, z, w / 2, h / 2, color }
                , { b.x + wr * cos(a), b.y + wr * sin(a), z, w / 2 + h * cos(-a), h / 2 + h * sin(-a), color }
            )
        elseif k < 0.5 then
            local a = 180 + 90 * ((k - 0.25) * 4)
            RenderTexture("ui:hp_line", ""
                , { b.x - wr, b.y, z, -w / 2, h / 2, color }
                , { b.x - wr, b.y, z, -w / 2, h / 2, color }
                , { b.x, b.y, z, w / 2, h / 2, color }
                , { b.x + wr * cos(a), b.y + wr * sin(a), z, w / 2 + h * cos(-a), h / 2 + h * sin(-a), color }
            )
            Render("ui:hp_line1", b.x, b.y, 0, scale)
        elseif k < 0.75 then
            local a = 270 + 90 * ((k - 0.5) * 4)
            RenderTexture("ui:hp_line", ""
                , { b.x, b.y, z, w / 2, h / 2, color }
                , { b.x, b.y, z, w / 2, h / 2, color }
                , { b.x + wr * cos(a), b.y + wr * sin(a), z, w / 2 + h * cos(-a), h / 2 + h * sin(-a), color }
                , { b.x, b.y - wr, z, w / 2, h * 1.5, color }
            )
            Render("ui:hp_line1", b.x, b.y, 0, scale)
            Render("ui:hp_line3", b.x, b.y, 0, scale)
        elseif k < 1 then
            local a = 90 * ((k - 0.75) * 4)
            RenderTexture("ui:hp_line", ""
                , { b.x, b.y, z, w / 2, h / 2, color }
                , { b.x, b.y, z, w / 2, h / 2, color }
                , { b.x + wr * cos(a), b.y + wr * sin(a), z, w / 2 + h * cos(-a), h / 2 + h * sin(-a), color }
                , { b.x + wr, b.y, z, w * 1.5, h / 2, color }
            )
            Render("ui:hp_line1", b.x, b.y, 0, scale)
            Render("ui:hp_line3", b.x, b.y, 0, scale)
            Render("ui:hp_line4", b.x, b.y, 0, scale)
        else
            Render("ui:hp_line0", b.x, b.y, 0, scale)
        end
        Render("ui:hp_rail", b.x, b.y, 0, scale)
        --[[
        if b.sp_point and #b.sp_point > 0 then
            lstg.SetImageState("hp_node", "", color)
            for i = 1, #b.sp_point do
                lstg.Render("hp_node", b.x + 62 * lstg.cos(b.sp_point[i]), b.y + 62 * lstg.sin(b.sp_point[i]), b.sp_point[i] - 90, 0.5)
            end
        end
        ]]
    end)
end

---@nodiscard
---@param ui berry.boss.ui
---@return berry.boss.ui.hp
function M.create(ui)
    return New(M, ui)
end

return M