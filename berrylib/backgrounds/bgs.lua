---@class Background : lstg.object
Background = Class(Object)

---@param is_sc_bg boolean whether this background is for spell cards
function Background:init(is_sc_bg)
    self.group = GROUP_GHOST
    self.bound = false
    if is_sc_bg then
        self.layer = LAYER_BG
        self.alpha = 0
    else
        self.layer = LAYER_BG - 0.1
        self.alpha = 1
        if lstg.tmpvar.bg and IsValid(lstg.tmpvar.bg) then
            Del(lstg.tmpvar.bg)
        end
        lstg.tmpvar.bg = self
    end
end

function Background:render()
    SetViewMode("world")
    RenderClearViewMode(Color(0))
end

--- Include every backgrounds here

Include("backgrounds/temple/temple.lua")