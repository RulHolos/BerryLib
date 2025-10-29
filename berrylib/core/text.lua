---@class TTFRenderer
TTFRenderer = {}

function TTFRenderer:init(fnt, text, x, y, scale)
    ---@type string
    self.font = fnt
    ---@type string
    self.text = text
    self.x, self.y = x or 0, y or 0
    self.scale = scale or 1
end

function TTFRenderer.create(fnt, text, x, y, scale)
    local renderer = makeInstance(TTFRenderer)
    renderer:init(fnt, text, x, y, scale)
    return renderer
end

---@param width number
---@param sections integer
---@param color lstg.Color
---@return TTFRenderer self
function TTFRenderer:setOutline(width, sections, color)
    self.outline_width = width
    self.outline_sections = sections
    self.outline_color = color

    return self
end

---@return TTFRenderer self
function TTFRenderer:parse()
    return self
end

function TTFRenderer:render()

end