-- ============== --
-- Logging System --
-- ============== --

---@param level 0|1|2|3|4 Debug, info, warning, error, fatal
---@vararg string
function Log(level, ...)
    local arg = {...}
    for i, v in ipairs(arg) do
        arg[i] = tostring(v)
    end
    local msg = table.concat(arg, "\t")
    lstg.Log(level, msg)
end

function lstg.MsgBoxWarn(msg)
    local ret = lstg.MessageBox("Warning", tostring(msg), 49)
    if ret == 2 then
        QuitGame()
    end
end

function lstg.MsgBoxError(msg, title, exit)
    local ret = lstg.MessageBox(title, tostring(msg), 16)
    if ret == 1 and exit then
        QuitGame()
    end
end