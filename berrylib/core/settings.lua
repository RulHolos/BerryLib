local cjson = require("cjson")
---@diagnostic disable-next-line: undefined-field
local keyboard = lstg.Input.Keyboard

---@alias KnownKeys
---| "Up"
---| "Down"
---| "Right"
---| "Left"
---| "Shoot"
---| "Bomb"
---| "Special"
---| "Focus"
---| "Snapshot"
---| "Retry"

Default_Settings = {
    Username = "Player",
    Locale = "en_us",
    TZ = 0,
    XResolution = 640,
    YResolution = 480,
    Windowed = true,
    VSync = true,
    SEVolume = 25,
    BGMVolume = 30,
    Keys_p1 = {
        Up = keyboard.Up,
        Down = keyboard.Down,
        Right = keyboard.Right,
        Left = keyboard.Left,
        Shoot = keyboard.Z,
        Bomb = keyboard.X,
        Special = keyboard.C,
        Focus = keyboard.LeftShift,
        Snapshot = keyboard.Home,
        Retry = keyboard.R,
    },
    Keys_p2 = {
        Up = keyboard.Up,
        Down = keyboard.Down,
        Right = keyboard.Right,
        Left = keyboard.Left,
        Shoot = keyboard.Z,
        Bomb = keyboard.X,
        Special = keyboard.C,
        Focus = keyboard.LeftShift,
        Snapshot = keyboard.Home,
        Retry = keyboard.R,
    }
}

local function get_settings_file()
    return lstg.LocalUserData.GetRootDirectory() .. "/Settings.json"
end

---Visits a table and serializes it to json.
function Serialize(o)
    if type(o) == "table" then
        ---Visits a table recursively.
        function visitTable(t)
            local ret = {}
            if getmetatable(t) and getmetatable(t).data then
                t = getmetatable(t).data
            end
            for k, v in pairs(t) do
                if type(v) == "table" then
                    ret[k] = visitTable(v)
                else
                    ret[k] = v
                end
            end
            return ret
        end

        o = visitTable(o)
    end
    return cjson.encode(o)
end

---Transforms a serialized string into a table, ignores functions.
---@param s string Serialized json
function Deserialize(s)
    return cjson.decode(s)
end

function LoadConfig()
    local f, msg = io.open(get_settings_file(), 'r')
    if f then
        Settings = Deserialize(f:read('*a'))
        f:close()
    else
        Settings = Default_Settings
    end
end

function SaveConfig()
    local f, msg = io.open(get_settings_file(), 'w')
    if f then
        f:write(string.json_pretty(Serialize(Settings)))
        f:close()
    else
        error(msg)
    end
end

LoadConfig() -- Creates a Settings object in any case.