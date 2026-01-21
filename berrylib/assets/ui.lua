local M = {}

M.resdesc = {
    { name = "ui:bg", type = "imgfile", args = {"ui/ui_bg.png", true} },
    { name = "ui:logo", type = "imgfile", args = {"ui/logo.png", true} },
    { name = "ui:lines", type = "tex", args = {"ui/line.png", true} },
    { name = "ui:line_", type = "imggrp", args = {"ui:lines", 0, 0, 200, 8, 1, 7, 0, 0} },
    { name = "ui:hint", type = "tex", args = {"ui/hint.png", true} },
    { name = "ui:hint:hiscore", type = "img", args = {"ui:hint", 424, 8, 80, 20} },
    { name = "ui:hint:score", type = "img", args = {"ui:hint", 424, 30, 64, 20} },
    { name = "ui:boss_ui", type = "tex", args = {"ui/boss_ui.png", true} },
}

function M.postLoad()
    SetImageCenter("ui:logo", 0, 0)
    SetImageCenter("ui:hint:hiscore", 0, 10)
    SetImageCenter("ui:hint:score", 0, 10)
end

return M