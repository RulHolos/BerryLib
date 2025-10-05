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
    Screen.playfield.width = 192 * 2
    Screen.playfield.height = 224 * 2
    Screen.playfield.boundOffset = 32
    Screen.playfield.xoffset = 32 -- Those two a values are the offset of the playfield in relation to the render context.
    Screen.playfield.yoffset = 16
end

-- ============ --
-- Screen modes --
-- ============ --

---@param mode "background"|"world"|"ui"
function SetViewMode(mode)
    if mode == "background" then
        -- Uhhhhh later.
    elseif mode == "world" then
        local w = Screen.playfield
        SetRenderRect(w.width, w.height, w.xoffset, w.xoffset + w.width, w.yoffset, w.yoffset + w.height)
    elseif mode == "ui" then
        SetRenderRect(Screen.width, Screen.height, 0, Screen.width, 0, Screen.height)
    else
        error("Unknown ViewMode: '" .. mode .. "'.")
    end
    lstg.viewmode = mode
end

function SetRenderRect(width, height, scrl, scrr, scrb, scrt)
---@diagnostic disable-next-line: unused-local, redefined-local
    local function setViewportAndScissorRect(l, r, b, t)
        SetViewport(l, r, b, t)
        SetScissorRect(l, r, b, t)
    end

    local l = -(width / 2)
    local r = (width / 2)
    local b = -(height / 2)
    local t = (height / 2)

    SetOrtho(l, r, b, t)
    --lstg.MsgBoxWarn(l .. " " .. r .. " " .. b .. " " .. t)

    setViewportAndScissorRect(
        scrl * Screen.scale,
        scrr * Screen.scale,
        scrb * Screen.scale,
        scrt * Screen.scale
    )

    SetFog()
    SetImageScale(1)
end

CreateScreenData()