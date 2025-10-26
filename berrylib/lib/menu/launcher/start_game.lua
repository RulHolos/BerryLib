---@param text string
---@param callback fun()
---@return launcher.StartGame.widget
local function widget(text, callback)
    ---@class launcher.StartGame.widget
    local w = {
        sizeX = 400,
        sizeY = 40,
        text = text,
        callback = callback,
        hovered = false,
        clicked = false,
    }
    return w
end


---@class Launcher.StartGame : Menu.View
local M = {}

---@return string[]
local function enumMods()
    local list = {}
    local list_mods = lstg.FileManager.EnumFiles("game/")
    for _, v in ipairs(list_mods) do
        local filename = v[1]
        local mod_name = ""
        if string.sub(filename, -4, -1) == ".zip" then
            lstg.LoadPack(filename)
            local archive = lstg.FileManager.GetArchive(filename)
            if archive then
                local root_exist = archive:FileExist("root.lua")
                lstg.UnloadPack(filename)
                if root_exist then
                    mod_name = string.sub(filename, 5, -5)
                end
            end
        elseif v[2] then
            if lstg.FileManager.FileExist(v[1] .. "root.lua") then
                mod_name = string.sub(filename, 5, -2)
            end
        end
        if string.len(mod_name) > 0 then
            table.insert(list, mod_name)
        end
    end
    return list
end

function M:init()
    MenuView.init(self)

    self.games = enumMods()
    ---@type launcher.StartGame.widget[]
    self.widgets = {}
    for k, v in pairs(self.games) do
        table.insert(self.widgets, widget(v, function()
            Settings.Game = string.sub(v, 2)

            local zip_path = string.format("game/%s.zip", Settings.Game)
            local dir_path = string.format("game/%s/", Settings.Game)
            local dir_root_script = string.format("game/%s/root.lua", Settings.Game)
            if lstg.FileManager.FileExist(zip_path) then
                lstg.LoadPack(zip_path)
            elseif lstg.FileManager.FileExist(dir_root_script) then
                lstg.FileManager.AddSearchPath(dir_path)
            end

            Include("root.lua")
            SceneManager.setNextScene("Loading")
            SceneManager.next()
        end))
    end
end

function M:frame()
    local spacing = 10
    local offsetY = Screen.height - 10

    for i = 1, #self.widgets do
        local w = self.widgets[i]
        local yTop = offsetY - w.sizeY
        local yBottom = offsetY

        if IsMouseInRect(220, w.sizeX + 220, yTop, yBottom) then
            if GetMouseState(0) == true then
                w.clicked = true
                w.callback()
            else
                w.clicked = false
            end
            w.hovered = true
        else
            w.hovered = false
        end

        offsetY = yTop - spacing
    end
end

function M:render()
    local spacing = 10
    local offsetY = Screen.height - 10

    for i = 1, #self.widgets do
        local w = self.widgets[i]
        local yTop = offsetY - w.sizeY
        local yBottom = offsetY

        if w.clicked then
            SetImageState("white", "", Color(255, 200, 200, 200))
        elseif w.hovered then
            SetImageState("white", "", Color(255, 128, 128, 128))
        else
            SetImageState("white", "", Color(255, 80, 80, 80))
        end
        RenderRect("white", 220, w.sizeX + 220, yTop, yBottom)

        SetFontState("menu", "", Color(255, 255, 255, 255))
        RenderText("menu", w.text, 230, yTop + w.sizeY/2, 0.5, "vcenter")

        offsetY = yTop - spacing
    end
end

return M