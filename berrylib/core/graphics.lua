-- ======================== --
-- LuaSTG Screen and Window --
-- ======================== --

---@class Screen
---@field width integer Width of the viewport
---@field height integer Height of the viewport
---@field hscale number Horizontal scale factor
---@field vscale number Vertical scale factor
---@field resScale number Aspect ratio (width / height)
---@field scale number Overall scale factor (minimum of hscale and vscale)
Screen = {}

---@class Screen.playfield
Screen.playfield = {}

---@class World
---@field left number Left-most part of the world
---@field right number Right-most part of the world
---@field bottom number Bottom-most part of the world
---@field top number Top-most part of the world

function CreateScreenData()
    -- 16:9 aspect ratio by default
    Screen.width = 640
    Screen.height = 480

    Screen.hScale = Settings.XResolution / Screen.width
    Screen.vScale = Settings.YResolution / Screen.height
    Screen.resScale = Settings.XResolution / Settings.YResolution
    Screen.scale = math.min(Screen.hScale, Screen.vScale)

    CreatePlayfieldData()
end

function CreatePlayfieldData()
    Screen.playfield.width = 384
    Screen.playfield.height = 448
    Screen.playfield.boundOffset = 32
    Screen.playfield.xoffset = 0
    Screen.playfield.yoffset = 0

    SetBound(-(Screen.playfield.width / 2), Screen.playfield.width / 2, -(Screen.playfield.height / 2), Screen.playfield.height / 2)
end

-- ============ --
-- Screen modes --
-- ============ --

---@param mode "background"|"world"|"ui"
function SetViewMode(mode)
    if mode == "background" then
    elseif mode == "world" then
    elseif mode == "ui" then
        SetRenderRect()
    else
        error("Unknown ViewMode: '" .. mode .. "'.")
    end
end

function SetRenderRect(l, r, b, t, xoffset, yoffset)

end