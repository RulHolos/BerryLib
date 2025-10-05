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