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
    for k, v in pairs(Settings.Keys) do
        local key_state = Keyboard.GetKeyState(v)
        KeyStatePrev[k] = KeyState[k] or false
        KeyState[k] = key_state

        if KeyStatePrev[k] ~= key_state then
            -- Arguments: key name, is down
            lstg.Signals:emit("KeyStateChanged", k, key_state)
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
    return KeyState[key] or false
end

---@param key KnownKeys
---@return boolean
function KeyIsPressed(key)
    local t = KeyDirectionTimer[key] or 0
    if t >= 30 and (t - 30) % 60 == 0 then
        return true
    end
    return KeyState[key] and not KeyStatePrev[key]
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

local old_GetMousePosition = lstg.GetMousePosition
function GetMousePosition()
    local mx, my = old_GetMousePosition()

    mx, my = mx / Screen.scale, my / Screen.scale

    return mx, my
end
lstg.GetMousePosition = GetMousePosition

---@param left number
---@param right number
---@param bottom number
---@param top number
---@return boolean
function IsMouseInRect(left, right, bottom, top)
    local x, y = GetMousePosition()
    local xRect = x > left and x < right
    local yRect = y > bottom and y < top

    return xRect and yRect
end