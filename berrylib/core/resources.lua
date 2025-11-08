-- ========= --
-- Resources --
-- ========= --

lstg.included = {}
lstg.current_script_path = { '' }

function Include(filename)
    filename = tostring(filename)
    if string.sub(filename, 1, 1) == "~" then
        filename = lstg.current_script_path[#lstg.current_script_path] .. string.sub(filename, 2)
    end
    if not lstg.included[filename] then
        local i, j = string.find(filename, '^.+[\\/]+')
        if i then
            table.insert(lstg.current_script_path, string.sub(filename, i, j))
        else
            table.insert(lstg.current_script_path, '')
        end
        lstg.included[filename] = true
        lstg.DoFile(filename)
        lstg.current_script_path[#lstg.current_script_path] = nil
    end
end

ImageList = {}
ImageSize = {}
OriginalLoadImage = LoadImage

function LoadImage(img, ...)
    local arg = { ... }
    ImageList[img] = arg
    ImageSize[img] = { arg[4], arg[5] }
    OriginalLoadImage(img, ...)
end

function LoadTexture(name, path, mipmap)
    if CheckRes("tex", name) then
        return false
    end

    lstg.LoadTexture(name, path, mipmap)

    return true
end

function GetImageSize(img)
    return unpack(ImageSize[img])
end

function CopyImage(newname, img)
    if ImageList[img] then
        LoadImage(newname, unpack(ImageList[img]))
    elseif img then
        error("The image \"" .. img .. "\" can't be copied.")
    else
        error("Wrong argument #2 (expect string get nil)")
    end
end

function LoadImageGroup(prefix, texname, x, y, w, h, cols, rows, a, b, rect)
    for i = 0, cols * rows - 1 do
        LoadImage(prefix .. (i + 1), texname, x + w * (i % cols), y + h * (int(i / cols)), w, h, a or 0, b or 0, rect or false)
    end
end

---@param teximgname string
---@param filename string
---@param mipmap boolean?
---@param a number?
---@param b number?
---@param rect boolean?
---@return boolean was_loaded Returns false if the image already exists and thus, wasn't loaded.
function LoadImageFromFile(teximgname, filename, mipmap, a, b, rect)
    if CheckRes("img", teximgname) then
        return false
    end

    LoadTexture(teximgname, filename, mipmap)
    local w, h = GetTextureSize(teximgname)
    LoadImage(teximgname, teximgname, 0, 0, w, h, a or 0, b or 0, rect)

    return true
end

function LoadImageGroupFromFile(texaniname, filename, mipmap, n, m, a, b, rect)
    LoadTexture(texaniname, filename, mipmap)
    local w, h = GetTextureSize(texaniname)
    LoadImageGroup(texaniname, texaniname, 0, 0, w / n, h / m, n, m, a, b, rect)
end

---@return boolean was_loaded Returns false if the TTF already exists and thus, wasn't loaded.
function LoadTTF(ttfname, filename, size)
    if CheckRes("ttf", ttfname) then
        return false
    end

    lstg.LoadTTF(ttfname, filename, 0, size)

    return true
end

--- Text

ENUM_TTF_FMT = {
    left = 0x00000000,
    center = 0x00000001,
    right = 0x00000002,

    top = 0x00000000,
    vcenter = 0x00000004,
    bottom = 0x00000008,

    wordbreak = 0x00000010,
    --singleline=0x00000020,
    --expantextabs=0x00000040,
    noclip = 0x00000100,
    --calcrect=0x00000400,
    --rtlreading=0x00020000,
    paragraph = 0x00000010,
    centerpoint = 0x00000105,
}
setmetatable(ENUM_TTF_FMT, { __index = function(t, k)
    return 0
end })

function RenderTTF(ttfname, text, left, right, bottom, top, color, ...)
    local fmt = 0
    local arg = { ... }
    for i = 1, #arg do
        fmt = fmt + ENUM_TTF_FMT[arg[i]]
    end
    lstg.RenderTTF(ttfname, text, left, right, bottom, top, fmt, color)
end

function RenderTTF2(ttfname, text, left, right, bottom, top, scale, color, ...)
    local fmt = 0
    local arg = { ... }
    for i = 1, #arg do
        fmt = fmt + ENUM_TTF_FMT[arg[i]]
    end
    lstg.RenderTTF(ttfname, text, left, right, bottom, top, fmt, color, scale)
end

function RenderText(fontname, text, x, y, size, ...)
    local fmt = 0
    local arg = { ... }
    for i = 1, #arg do
        fmt = fmt + ENUM_TTF_FMT[arg[i]]
    end
    lstg.RenderText(fontname, text, x, y, size, fmt)
end

-------------------------------------------------
---Helpers

ENUM_RES_TYPE = { tex = 1, img = 2, ani = 3, bgm = 4, snd = 5, psi = 6, fnt = 7, ttf = 8, fx = 9 }

function CheckRes(typename, resname)
    local t = ENUM_RES_TYPE[typename]
    if t == nil then
        error('Invalid resource type name.')
    else
        return lstg.CheckRes(t, resname)
    end
end

function EnumRes(typename)
    local t = ENUM_RES_TYPE[typename]
    if t == nil then
        error('Invalid resource type name.')
    else
        return lstg.EnumRes(t)
    end
end

-----------------------------------------------
---Loaders

---@class lstg.ResourcesLoader
Loader = {}
---@type lstg.ResourcesLoader.Manager?
local current_mgr = nil

Loader.loaders = {
    tex = lstg.LoadTexture,
    img = lstg.LoadImage,
    imgfile = LoadImageFromFile,
    imggrp = LoadImageGroup,
    ani = lstg.LoadAnimation,
    bgm = lstg.LoadMusic,
    se = lstg.LoadSound,
    ps = lstg.LoadPS,
    fnt = lstg.LoadFont,
    ttf = lstg.LoadTTF,
    mdl = lstg.LoadModel,
}

---@class lstg.ResourceDesc
---
---The name of the resource
---@field name string
---
---The resource's type.
---Usually, will be one of the LuaSTG built-in resource types.
---(`tex, img, ani, bgm, se, ps, fnt, ttf, mdl`)
---as well as `imgfile` for loading images directly from a file,
---and `imggrp` for loading multiple sequential images.
---However, custom types are allowed, as long as a loader function is
---registered with the resource manager.
---@field type string
---
---Extra arguments to the resource loader function
---(usually starts with a file path or a texture name).
---@field args table

---@type { [string]: fun(respool: lstg.ResourcePoolType) }
local custom_resource_clear_handlers = {}

---Adds a function to handle pool clearing for custom resources.
---@param restype string
---@param f fun(respool: lstg.ResourcePoolType)
function Loader.addClearPoolHandler(restype, f)
    custom_resource_clear_handlers[restype] = f
end

---Resets pool clearing for the given custom resource.
---@param restype string
function Loader.removeClearPoolHandler(restype)
    custom_resource_clear_handlers[restype] = nil
end

---Clears the specified resource pool.
---@param respool lstg.ResourcePoolType
function Loader.clearPool(respool)
    for _, v in pairs(custom_resource_clear_handlers) do
        v(respool)
    end
    lstg.RemoveResource(respool)
end

----------------------------------

---Loads a single resource from the associated resource description table.
---@param self lstg.ResourcesLoader.Manager
---@return boolean
local function resmgr_load(self)
    if self.done then return false end
    if self.idx > #self.resdesc then
        if self.postLoad then
            self:postLoad()
        end
        self.done = true
        return false
    end
    local res = self.resdesc[self.idx]
    Loader.loaders[res.type](res.name, unpack(res.args))
    self.idx = self.idx + 1
    return true
end

---@param self lstg.ResourcesLoader.Manager
local function resmgr_reset(self)
    self.idx = 1
end

---@param self lstg.ResourcesLoader.Manager
---@return boolean
local function resmgr_isDone(self)
    return self.done
end

---Creates a new resource manager which will load specified resources
---by the provided table and can be called asynchronously.
---@param resdesc lstg.ResourceDesc[]
---@param post_load fun(self: lstg.ResourcesLoader.Manager)?
---@return lstg.ResourcesLoader.Manager
function Loader.newMgr(resdesc, post_load)
    ---@class lstg.ResourcesLoader.Manager
    local resmgr = {}
    resmgr.resdesc = resdesc
    resmgr.idx = 1
    resmgr.done = false
    resmgr.load = resmgr_load
    resmgr.reset = resmgr_reset
    resmgr.isDone = resmgr_isDone
    resmgr.postLoad = post_load

    return resmgr
end

---Sets the current resource manager in order to load from it.
---@param mgr lstg.ResourcesLoader.Manager?
function Loader.setCurrentMgr(mgr)
    current_mgr = mgr
end

---@return lstg.ResourcesLoader.Manager?
function Loader.getCurrentMgr()
    return current_mgr
end

---Performs one frame worth of resource loading.
function Loader.loadFrame()
    if not current_mgr or not current_mgr:load() then
        return
    end

    for _ = 1, 9 do
        current_mgr:load()
    end
end

-----------------------

---Makes the resource pool switch to `pool` before returning to the old one.
---
---Basically load a resource with a pool resource context.
---@param pool string Resource pool name
---@param f fun() What to load
function WithResourceCtx(pool, f)
    local ctx = GetResourceStatus()
    SetResourceStatus(pool)
    f()
    SetResourceStatus(ctx)
end