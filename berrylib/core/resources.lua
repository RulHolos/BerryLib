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