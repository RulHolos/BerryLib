local M = {}

M.resdesc = {
    { name = "item", type = "tex", args = {"misc/item.png"} },
    { name = "item_", type = "imggrp", args = {"item", 0, 0, 32, 32, 2, 6, 8, 8} },
    { name = "item_up_", type = "imggrp", args = {"item", 64, 0, 32, 32, 2, 6} },
}

function M.postLoad()
    SetImageState("item_8", "mul+add", Color(0xC0FFFFFF))
end

return M