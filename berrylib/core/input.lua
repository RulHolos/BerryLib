---@diagnostic disable-next-line: undefined-field
local Keyboard = lstg.Input.Keyboard

---@class Input
local M = {}

---@type table<string, boolean>
local KeyState = {}
---@type table<string, boolean>
local KeyStatePrev = {}
local KeyDirectionTimer = {
    Left = 0,
    Right = 0,
    Up = 0,
    Down = 0,
}

function GetInput()
    for i = 1, 2 do
        for k, v in pairs(Settings["Keys_p" .. i]) do
            KeyStatePrev[k] = KeyState[k]
            KeyState[k] = Keyboard.GetKeyState(v)

            if KeyStatePrev[k] ~= KeyState[k] then
                -- Arguments: p_index, key name, is down
                lstg.Signals:emit("KeyStateChanged", i, k, KeyState[k])
            end
        end
    end

    for k, _ in pairs(KeyDirectionTimer) do
        if KeyState[k] then
            KeyDirectionTimer[k] = KeyDirectionTimer[k] + 1
        else
            KeyDirectionTimer[k] = 0
        end
    end
end

---@param key KnownKeys
---@return boolean
function KeyIsDown(key)
    return KeyState[key]
end

---@return boolean
function KeyIsPressed(key)
    if KeyDirectionTimer[key] then
        local t = KeyDirectionTimer[key]
        if t >= 30 then
            t = t - 30
            if (t % 6) == 0 then
                return true
            end
        end
    end
    return (not KeyStatePrev[key]) and KeyState[key]
end

---@param code number
---@return string
function KeyToName(code)
    if type(code) ~= "number" then
        return "KEY INVALID"
    end
    if code == Keyboard.None then
        return "-"
    end
    for k, v in pairs(Keyboard) do
        if v == code then
            return k
        end
    end
    return ("KEY %d"):format(code)
end