---@class berry.UI.Component.Score : berry.UI.Component
local M = {}
M.name = "Score"
M.priority = 0

local function formatnum(num)
    local sign = sign(num)
    num = abs(num)
    local tmp, var = {}, nil
    while num >= 1000 do
        var = num - int(num / 1000) * 1000
        table.insert(tmp, 1, ("%03d"):format(var))
        num = int(num / 1000)
    end
    table.insert(tmp, 1, tostring(num))
    var = table.concat(tmp, ",")
    if sign < 0 then
        var = ("-%s"):format(var)
    end
    return var, #tmp - 1
end

local function RenderScore(fontname, score, x, y, size, mode)
    if score < 100000000000 then
        RenderText(fontname, formatnum(score), x, y, size, mode)
    else
        RenderText(fontname, string.format("99,999,999,999"), x, y, size, mode)
    end
end

function M:ScoreUpdate()
    local cur_score = int(lstg.var.score)
    local score = self.score or cur_score
    local score_tmp = self.score_tmp or cur_score
    if score_tmp < cur_score then
        if cur_score - score_tmp <= 100 then
            score = score + 10
        elseif cur_score - score_tmp <= 1000 then
            score = score + 100
        else
            score = int(score / 10 + int((cur_score - score_tmp) / 600)) * 10 + cur_score % 10
        end
    end
    if score_tmp > cur_score then
        score_tmp = cur_score
        score = cur_score
    end
    if score >= cur_score then
        score_tmp = cur_score
        score = cur_score
    end

    self.score = int(score)
    self.score_tmp = score_tmp
end

function M:init()
    self.positions = {
        { "ui:hint:hiscore", 12 + Screen.playfield.screen_right, 425 },
        { "ui:hint:score", 12 + Screen.playfield.screen_right, 403 },
    }
end

function M:frame()
    self:ScoreUpdate()
end

function M:render()
    local y0 = 448 - self.ui.timer * 3
    local dyt = max(300 - y0, 0)
    for i = 1, #self.positions do
        local img = self.positions[i][1]
        local x, y = self.positions[i][2], self.positions[i][3]
        local dy = max(y - y0, 0)
        local alpha = min(dy * 4, 255)
        local dw = alpha / 255
        SetImageState(img, "", Color(alpha, 255, 255, 255))
        Render(img, x, y, 0, dw, 1)
    end
    local alplat = min(dyt * 4, 255)

    SetFontState("score3", "", Color(alplat, 173, 173, 173))
    RenderScore("score3", max(lstg.tmpvar.hiscore or 0, self.score or 0),
        216 + Screen.playfield.screen_right, 436, 0.43, "right")
    SetFontState("score3", "", Color(alplat, 255, 255, 255))
    RenderScore("score3", self.score or 0, 216 + Screen.playfield.screen_right, 414, 0.43, "right")
end

function M:debug()
end

GameUI.registerBaseComponent(M)