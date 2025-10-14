-- ======================== --
-- LuaSTG Screen and Window --
-- ======================== --

----------------------------------------
--- build-in white

lstg.CreateRenderTarget("rt:screen-white", 64, 64)
lstg.LoadImage("img:screen-white", "rt:screen-white", 16, 16, 16, 16)

function UpdateScreenResources()
    lstg.PushRenderTarget("rt:screen-white")
    lstg.RenderClear(lstg.Color(255, 255, 255, 255))
    lstg.PopRenderTarget()
end

-----

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

-- ========= --
-- 3D Setups --
-- ========= --

lstg.view3d = {
    eye = { 0, 0, -1 },
    at = { 0, 0, 0 },
    up = { 0, 1, 0 },
    fovy = PI_2,
    z = { 0, 2 },
    fog = { 0, 0, Color(0) },
}

function Reset3D()
    lstg.view3d.eye = { 0, 0, -1 }
    lstg.view3d.at = { 0, 0, 0 }
    lstg.view3d.up = { 0, 1, 0 }
    lstg.view3d.fovy = PI_2
    lstg.view3d.z = { 1, 2 }
    lstg.view3d.fog = { 0, 0, Color(0x00000000) }
end

function Set3D(key, a, b, c)
    if key == 'fog' then
        a = tonumber(a or 0)
        b = tonumber(b or 0)
        if c then
            c.a = 255
        end
        lstg.view3d.fog = { a, b, c }
        return
    end
    a = tonumber(a or 0)
    b = tonumber(b or 0)
    c = tonumber(c or 0)
    if key == 'eye' then
        lstg.view3d.eye = { a, b, c }
    elseif key == 'at' then
        lstg.view3d.at = { a, b, c }
    elseif key == 'up' then
        lstg.view3d.up = { a, b, c }
    elseif key == 'fovy' then
        lstg.view3d.fovy = a
    elseif key == 'z' then
        lstg.view3d.z = { a, b }
    end
end

-- ============ --
-- Screen modes --
-- ============ --

---@param mode "background"|"world"|"ui"
function SetViewMode(mode)
    if mode == "background" then
        local w = Screen.playfield
        local l = -(w.width / 2)
        local r = (w.width / 2)
        local b = -(w.height / 2)
        local t = (w.height / 2)
        local scrl = w.xoffset
        local scrr = w.xoffset + w.width
        local scrb = w.yoffset
        local scrt = w.yoffset + w.height

        SetViewport(scrl * Screen.scale, scrr * Screen.scale, scrb * Screen.scale, scrt * Screen.scale)
        SetPerspective(
            lstg.view3d.eye[1], lstg.view3d.eye[2], lstg.view3d.eye[3],
            lstg.view3d.at[1], lstg.view3d.at[2], lstg.view3d.at[3],
            lstg.view3d.up[1], lstg.view3d.up[2], lstg.view3d.up[3],
            lstg.view3d.fovy, (r - l) / (t - b),
            lstg.view3d.z[1], lstg.view3d.z[2]
        )
        SetFog(lstg.view3d.fog[1], lstg.view3d.fog[2], lstg.view3d.fog[3])
        SetImageScale(((((lstg.view3d.eye[1] - lstg.view3d.at[1]) ^ 2
                + (lstg.view3d.eye[2] - lstg.view3d.at[2]) ^ 2
                + (lstg.view3d.eye[3] - lstg.view3d.at[3]) ^ 2) ^ 0.5)
                * 2 * math.tan(lstg.view3d.fovy * 0.5)) / (scrr - scrl))
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
    local function setViewportAndScissorRect(l, r, b, t)
        SetViewport(l, r, b, t)
        SetScissorRect(l, r, b, t)
    end

    local l = -(width / 2)
    local r = (width / 2)
    local b = -(height / 2)
    local t = (height / 2)

    SetOrtho(l, r, b, t)

    setViewportAndScissorRect(
        scrl * Screen.scale,
        scrr * Screen.scale,
        scrb * Screen.scale,
        scrt * Screen.scale
    )

    SetFog()
    SetImageScale(1)
end

local function drawRect(l, r, b, t, color)
    lstg.SetImageState("img:screen-white", "", color)
    lstg.RenderRect("img:screen-white", l, r, b, t)
end

---@param color lstg.Color
function RenderClearViewMode(color)
    local w = Screen.playfield
    local l = -(w.width / 2)
    local r = (w.width / 2)
    local b = -(w.height / 2)
    local t = (w.height / 2)

    if lstg.viewmode == '3d' then
        SetViewMode('world')
        drawRect(l, r, b, t, color)
        SetViewMode("background")
    elseif lstg.viewmode == 'world' then
        drawRect(l, r, b, t, color)
    elseif lstg.viewmode == 'ui' then
        drawRect(0, Screen.width, 0, Screen.height, color)
    else
        error('Unknown viewmode.')
    end
end

CreateScreenData()