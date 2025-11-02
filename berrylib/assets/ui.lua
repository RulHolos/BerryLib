local M = {}

M.resdesc = {
    { name = 'ui:bg', type = 'imgfile', args = {"ui/ui_bg.png", true} },
    { name = 'ui:lines', type = 'tex', args = {"ui/line.png", true} },
    { name = 'ui:line_', type = 'imggrp', args = {"ui:lines", 0, 0, 200, 8, 1, 7, 0, 0} }
}

return M