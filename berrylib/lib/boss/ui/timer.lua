---@class berry.boss.ui.timer : lstg.object
local M = Class(Object)

function M:init()
    self.alpha = 0
end

---@nodiscard
---@param ui berry.boss.ui
---@return berry.boss.ui.timer
function M.create(ui)
    return New(M, ui)
end

return M