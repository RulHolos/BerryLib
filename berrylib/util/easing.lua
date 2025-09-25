local Easing = {}

---@alias EasingType
---| "linear"
---| "inQuad"
---| "outQuad"
---| "inOutQuad"

function Easing.linear(t) return t end
function Easing.inQuad(t) return t * t end
function Easing.outQuad(t) return t * (2 - t) end
function Easing.inOutQuad(t)
    if t < 0.5 then
        return 2 * t * t
    else
        return -1 + (4 - 2 * t) * t
    end
end

return Easing