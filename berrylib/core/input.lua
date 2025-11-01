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
            local key_name = "Keys_p" .. i .. "-" .. k
            local key_state = Keyboard.GetKeyState(v)
            KeyStatePrev[key_name] = KeyState[key_name] or false
            KeyState[key_name] = key_state

            if KeyStatePrev[key_name] ~= key_state then
                -- Arguments: p_index, NOT SIDED key name, is down
                lstg.Signals:emit("KeyStateChanged", i, k, key_state)
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

    for k, v in pairs(KeyState) do
        if KeyIsPressed(k) then
            print(k, "was just pressed!")
        end
    end
end

---@param key KnownKeys
---@return boolean
function KeyIsDown(key, ignore_side)
    if not ignore_side then
        return KeyState[key] or false
    end
    for k, v in pairs(KeyState) do
        if k:match("%-" .. key .. "$") and v then
            return true
        end
    end
    return false
end

---@param key KnownKeys
---@return boolean
function KeyIsPressed(key, ignore_side)
    local function is_pressed_for(fullkey)
        local t = KeyDirectionTimer[key] or 0
        if t >= 30 and (t - 30) % 60 == 0 then
            return true
        end
        return KeyState[fullkey] and not KeyStatePrev[fullkey]
    end

    if not ignore_side then
        return is_pressed_for(key)
    end

    for fullkey, _ in pairs(KeyState) do
        if fullkey:match("%-" .. key .. "$") and is_pressed_for(fullkey) then
            return true
        end
    end
    return false
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
---@retrun boolean
function IsMouseInRect(left, right, bottom, top)
    local x, y = GetMousePosition()
    local xRect = x > left and x < right
    local yRect = y > bottom and y < top

    return xRect and yRect
end