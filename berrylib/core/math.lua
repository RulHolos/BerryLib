PI = math.pi
PIx2 = math.pi * 2
PI_2 = math.pi * 0.5
PI_4 = math.pi * 0.25
SQRT2 = math.sqrt(2)
SQRT3 = math.sqrt(3)
SQRT2_2 = math.sqrt(0.5)
GOLD = 360 * (math.sqrt(5) - 1) / 2
INF = 4294967296

int = math.floor
abs = math.abs
max = math.max
min = math.min
rnd = math.random
sqrt = math.sqrt
ceil = math.ceil

if not math.mod then
    math.mod = function(a, b)
        return a % b
    end
end
mod = math.mod

function sign(x)
    if x > 0 then
        return 1
    elseif x < 0 then
        return -1
    else
        return 0
    end
end

function hypot(x, y)
    return sqrt(x * x + y * y)
end

function balance(v, a, b, speed, state)
    if state then
        v = min(v + speed, b)
    else
        v = max(a, v - speed)
    end
    return v
end

---@param v number
---@param b number
---@param k number
---@return number
function approach_step(v, b, k)
    return b + (v - b) * k
end

---@generic T
---@param left boolean
---@param left_value T
---@param right_value T
---@return T
function left_or_right(left, left_value, right_value)
    if left then
        return left_value
    else
        return right_value
    end
end

---@param v number
---@param v_min number
---@param v_max number
function clamp(v, v_min, v_max)
    v_min, v_max = math.min(v_min, v_max), math.max(v_min, v_max)
    return math.max(v_min, math.min(v, v_max))
end