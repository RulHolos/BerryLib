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
function Task.New(target, f)
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
function Task.Wait(time_in_frames)
    time_in_frames = time_in_frames or 1
    time_in_frames = max(1, int(time_in_frames))
    for _ = 1, time_in_frames do
        coroutine.yield()
    end
end