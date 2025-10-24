local config = require("lib.menu.menuConfig")
Include("lib/menu/view.lua")

---@class Menu.Manager
MenuManager = {}

--- Basic

function MenuManager:init()
    ---@type table<string, Menu.View>
    self.views = {}
end

function MenuManager:frame()

end

function MenuManager:render()

end

--- UI

---Registers a new view to this manager.
---@param id string Identifier of the view
---@param view Menu.View Valid view instance
function MenuManager:addView(id, view)
    self.views[id] = view
end

---Removes an existing view.
---@param id string Identifier of the view
function MenuManager:removeView(id)
    self.views[id] = nil
end

---Creates a pair of tweens which will switch from the current view to the set one.
---
---Returns a pair of tweens, respectively the `fade_out` and `fade_in` tweens.
---These tweens already have one onComplete callback and target two different objects.
---
---The `fade_out` tween targets the current existing view.
---
---The `fade_in` tween targets the "target" view.
---This tween has a start delay of half the `frames` argument.
---
---Here's an example of what you can do with the returned tweens:
---
---```lua
---local out, in = MenuManager:switchTo("some_view", 60)
---out:addProperties({ x = -300, a = 0 })
---out:ease("inSine")
---```
---
---That would make the current view slide to the left while slowly getting the alpha to 0.
---
---Remarks:
---
---The tweens doesn't handle the alpha by default, don't forget the set them with `Tween:addProperties()`
---@param id string Identifier of the view
---@param frames integer? Time in frame for switching to the view. If not specified, will default to the config value.
---@return lstg.Tween, lstg.Tween @Fade_out, Fade_in
function MenuManager:switchTo(id, frames)
    local half = (frames or config.frames_for_switching) / 2

    ---@type Menu.View
    local current_view = nil
    ---@type Menu.View
    local target_view = self.views[id]
    assert(target_view ~= nil, "The target view doesn't exist in this menu.")

    current_view.locked = true
    local fade_out = Tween.to(current_view, {}, half)

    local fade_in = Tween.to(target_view, {}, half)
        :delay(half)
        ---@param obj Menu.View
        :onComplete(function(obj)
            obj.locked = false
        end)

    return fade_out, fade_in
end

--- Static

---Creates a new instance of a menu manager.
---@nodiscard
---@return Menu.Manager
function MenuManager.create()
    local manager = makeInstance(MenuManager)
    manager:init()
    return manager
end