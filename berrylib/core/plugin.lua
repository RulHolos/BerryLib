-- ============== --
-- Plugin Manager --
-- ============== --

local cjson = require("cjson")

---@param file_path string
---@return boolean
local function isFileZip(file_path)
    if string.len(file_path) < 4 then
        return false
    end
    return string.sub(file_path, string.len(file_path) - 3) == ".zip"
end

---@param cfg lstg.plugin.Config.Entry[]
local function printConfiglist(cfg)
    lstg.Print("============== Plugin ==============")
    for i, v in ipairs(cfg) do
        lstg.Print(tostring(i), v.name, v.path, v.directory_mode)
    end
    lstg.Print("====================================")
end

-----------------------------------

---@class plugin
lstg.plugin = {}

local PLUGIN_PATH = "plugin/"
local ENTRY_POINT = "init.lua"

---@return lstg.plugin.Config.Entry[]
function lstg.plugin.ListPlugins()
    local list = lstg.FileManager.EnumFiles(PLUGIN_PATH)
    local result = {}
    for _, v in ipairs(list) do
        if v[2] then
            if lstg.FileManager.FileExist(v[1] .. ENTRY_POINT) then
                table.insert(result, {
                    name = string.sub(v[1], string.len(PLUGIN_PATH) + 1, string.len(v[1]) -1),
                    path = v[1],
                    directory_mode = true,
                    enable = true,
                })
            end
        elseif isFileZip(v[1]) then
            lstg.LoadPack(v[1])
            local file_exists = lstg.FileManager.GetArchive(v[1]):FileExist(ENTRY_POINT)
            lstg.UnloadPack(v[1])
            if file_exists then
                table.insert(result, {
                    name = string.sub(v[1], string.len(PLUGIN_PATH) + 1, string.len(v[1]) - 4),
                    path = v[1],
                    directory_mode = false,
                    enable = true,
                })
            end
        end
    end
    return result
end

---@param entry lstg.plugin.Config.Entry
---@return boolean
function lstg.plugin.LoadPlugin(entry)
    if entry.directory_mode then
        lstg.FileManager.AddSearchPath(entry.path)
        lstg.DoFile(entry.path .. ENTRY_POINT)
    else
        lstg.LoadPack(entry.path)
        lstg.DoFile(ENTRY_POINT, entry.path)
    end
    return true
end

-----------------------------------

local CONFIG_FILE = "plugin.json"

---@class lstg.plugin.Config.Entry
---@field name string
---@field path string
---@field directory_mode boolean
---@field enable boolean

---Creates the plugin folder just in case it doesn't exist.
local function checkDirectory()
    lstg.FileManager.CreateDirectory(PLUGIN_PATH)
end

---Load the plugin configuration file for checking which plugins are to be loaded.
---@return lstg.plugin.Config.Entry[]
function lstg.plugin.LoadConfig()
    checkDirectory()

    local f = io.open(PLUGIN_PATH .. CONFIG_FILE, "rb")
    if f then
        local src = f:read('*a')
        f:close()
        local ret, val = pcall(cjson.decode, src)
        if ret then
            return val
        else
            lstg.Log(4, string.format("Deserializing '%s' failed: %s", PLUGIN_PATH .. CONFIG_FILE, val))
            return {}
        end
    else
        return {}
    end
end

---Saves the config to config file.
function lstg.plugin.SaveConfig(cfg)
    checkDirectory()
    local f, msg = io.open(PLUGIN_PATH .. CONFIG_FILE, "wb")
    if f then
        f:write(cjson.encode(cfg))
        f:close()
    else
        error(msg)
    end
end

---Creates a new config from the already existing plugins in the plugins folder.
---If the plugin already exists, refresh it.
---@param cfg lstg.plugin.Config.Entry[]
---@return lstg.plugin.Config.Entry[]
function lstg.plugin.FreshConfig(cfg)
    local new_cfg = lstg.plugin.ListPlugins()
    if type(cfg) == "table" then
        for _, v in ipairs(cfg) do
            for _, new_v in ipairs(new_cfg) do
                if v.name == new_v.name and v.path == new_v.path and v.directory_mode == new_v.directory_mode then
                    new_v.enable = v.enable
                    break
                end
            end
        end
    end
    return new_cfg
end

---Load all the enabled plugins judging from config.
---@param cfg lstg.plugin.Config.Entry[]
function lstg.plugin.LoadPluginsByConfig(cfg)
    for _, v in ipairs(cfg) do
        if v.enable then
            lstg.plugin.LoadPlugin(v)
        end
    end
end

-----------------------------------
--- Events

---@class lstg.plugin.Event.Entry
---@field name string
---@field priority integer
---@field callback fun()

local _events = {
    ---@type lstg.plugin.Event.Entry[]
    beforeLib = {},
    ---@type lstg.plugin.Event.Entry[]
    afterGame = {},
    ---@type lstg.plugin.Event.Entry[]
    afterLib = {},
}

---@param list lstg.plugin.Event.Entry[]
local function sortEvents(list)
    table.sort(list, function(a, b)
        return a.priority > b.priority
    end)
end

---@param type '"beforeLib"' | '"afterGame"' | '"afterLib"'
---@param name string
---@param priority integer
---@param callback fun()
function lstg.plugin.RegisterEvent(type, name, priority, callback)
    assert(_events[type], ("There isn't any event type called %s"):format(type))
    local list = _events[type]
    local exists = false

    for i, v in ipairs(list) do
        if v.name == name then
            list[i].priority = priority
            list[i].callback = callback
            exists = true
            break
        end
    end
    if not exists then
        table.insert(list, {
            name = name,
            priority = priority,
            callback = callback,
        })
    end
    sortEvents(list)
end

---@param type '"beforeLib"' | '"afterGame"' | '"afterLib"'
function lstg.plugin.DispatchEvent(type)
    assert(_events[type], ("There isn't any event type called %s"):format(type))
    for _, v in ipairs(_events[type]) do
        v.callback()
    end
end

-----------------------------------

function lstg.plugin.LoadPlugins()
    local cfg = lstg.plugin.LoadConfig()
    local new_cfg = lstg.plugin.FreshConfig(cfg)
    lstg.plugin.SaveConfig(new_cfg)
    lstg.plugin.LoadPluginsByConfig(new_cfg)
end