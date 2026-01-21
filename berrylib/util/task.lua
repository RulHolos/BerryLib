---@diagnostic disable: undefined-field
-- =========== --
-- Task System --
-- =========== --

---@class Task
Task = {}
---@class Task.Stack
Task.Stack = {}
---@class Task.Coroutines
Task.co = {}

---Creates a new task belonging to `target`.
---@generic T
---@param target T
---@param f fun()
---@return thread
function Task.new(target, f)
    if not target.Tasks then
---@diagnostic disable-next-line: inject-field
        target.Tasks = {}
    end
    local rt = coroutine.create(f)
    table.insert(target.Tasks, rt)
    return rt
end

---Resumes all the coroutines in the `target` object for one frame.
---@generic T
---@param target T
function Task.Do(target)
    if target.Tasks then
        for _, co in pairs(target.Tasks) do
            if coroutine.status(co) ~= 'dead' then
                table.insert(Task.Stack, target)
                table.insert(Task.co, co)
                local flag, err = coroutine.resume(co)
                if err then
                    error(tostring(err) .. "\n========= Coroutine Traceback =========\n" .. debug.traceback(co) .. "\n========= C traceback =========")
                end
                Task.Stack[#Task.Stack] = nil
                Task.co[#Task.co] = nil
            end
        end
    end
end

---Makes the current task wait for the specified amount of frames.
---
---Must be used in a task context!
---@param time_in_frames integer? Time to wait in frames
function Task.wait(time_in_frames)
    time_in_frames = time_in_frames or 1
    time_in_frames = max(1, int(time_in_frames))
    for _ = 1, time_in_frames do
        coroutine.yield()
    end
end

MOVE_NORMAL = 0
MOVE_ACCEL = 1
MOVE_DECEL = 2
MOVE_ACC_DEC = 3

---Moves an object to a position with a easing mode.
---@param obj lstg.object
---@param x number x target position
---@param y number y target position
---@param t integer frame time
---@param mode 0|1|2|3
function Task.moveToObj(obj, x, y, t, mode)
    local self = obj
    t = max(1, int(t))

    ---@type EasingType
    local easing = "linear"
    if mode == 1 then
        easing = "inQuad"
    elseif mode == 2 then
        easing = "outQuad"
    elseif mode == 3 then
        easing = "inOutQuad"
    end

    local tw = Tween.to(self, { x = x, y = y }, t)
        :ease(easing)
    Tween.wait(tw)
end