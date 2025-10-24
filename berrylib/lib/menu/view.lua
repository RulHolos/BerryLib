---@class Menu.View
MenuView = {}

function MenuView:init(id)
    self.id = id
    self.locked = true
    self.alpha = 0
end

function MenuView:frame()

end

function MenuView:render()
    if self.alpha == 0 then return end
end

---@nodiscard
---@return Menu.View
function MenuView.create(M)
    local view = makeInstance(M)
    return view
end