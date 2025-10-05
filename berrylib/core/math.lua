PI = math.pi
PIx2 = math.pi * 2
PI_2 = math.pi * 0.5
PI_4 = math.pi * 0.25
SQRT2 = math.sqrt(2)
SQRT3 = math.sqrt(3)
SQRT2_2 = math.sqrt(0.5)
GOLD = 360 * (math.sqrt(5) - 1) / 2

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