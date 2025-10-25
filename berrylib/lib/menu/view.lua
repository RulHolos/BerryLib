---@class Menu.View
---@field id string Set by the manager object.
---@field frame fun(self:Menu.View)
---@field render fun(self:Menu.View)
MenuView = {}

function MenuView:init()
    self.locked = true
    self.alpha = 0
end

---@nodiscard
---@return Menu.View
function MenuView.create(M)
    local view = makeInstance(M)
    return view
end