-- ========= --
-- Resources --
-- ========= --

lstg.included = {}
lstg.current_script_path = { '' }

function Include(filename)
    filename = tostring(filename)
    if string.sub(filename, 1, 1) == "~" then
        filename = lstg.current_script_path[#lstg.current_script_path] .. string.sub(filename, 2)
    end
    if not lstg.included[filename] then
        local i, j = string.find(filename, '^.+[\\/]+')
        if i then
            table.insert(lstg.current_script_path, string.sub(filename, i, j))
        else
            table.insert(lstg.current_script_path, '')
        end
        lstg.included[filename] = true
        lstg.DoFile(filename)
        lstg.current_script_path[#lstg.current_script_path] = nil
    end
end