-------------------------------- Strings
---@param str string
---@return string
local function json_pretty(str)
	local ret = ''
	local indent = '	'
	local level = 0
	local in_string = false
	for i = 1, #str do
		local s = string.sub(str, i, i)
		if s == '{' and (not in_string) then
			level = level + 1
			ret = ret .. '{\n' .. string.rep(indent, level)
		elseif s == '}' and (not in_string) then
			level = level - 1
			ret = string.format(
				'%s\n%s}', ret, string.rep(indent, level))
		elseif s == '"' then
			in_string = not in_string
			ret = ret .. '"'
		elseif s == ':' and (not in_string) then
			ret = ret .. ': '
		elseif s == ',' and (not in_string) then
			ret = ret .. ',\n'
			ret = ret .. string.rep(indent, level)
		elseif s == '[' and (not in_string) then
			level = level + 1
			ret = ret .. '[\n' .. string.rep(indent, level)
		elseif s == ']' and (not in_string) then
			level = level - 1
			ret = string.format(
				'%s\n%s]', ret, string.rep(indent, level))
		else
			ret = ret .. s
		end
	end
	return ret
end

string.json_pretty = json_pretty

-------------------------------- Tables

---Check if a value exists in the given array.
---@param tbl table
---@param val any
---@return boolean
function contains_ipairs(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end
table.has_ipairs = contains_ipairs

---Check if a value exists in a given table.
---@param tbl table
---@param val any
---@return boolean
function contains_pairs(tbl, val)
    for _, v in pairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end
table.has_pairs = contains_pairs

---Apply a function to each value in the given array that satisfies a predicate.
---@param tbl table
---@param predicate fun(v:any, i:integer):boolean
---@param action fun(v:any, i:integer)
function foreach_ipairs(tbl, predicate, action)
	for i, v in ipairs(tbl) do
		if predicate(v, i) then
			action(v, i)
		end
	end
end
table.foreach_ipairs = foreach_ipairs

---Apply a function to each value in the given table that satisfies a predicate.
---@param tbl table
---@param predicate fun(v:any, k:any):boolean
---@param action fun(v:any, k:any)
function foreach_pairs(tbl, predicate, action)
    for k, v in pairs(tbl) do
        if predicate(v, k) then
            action(v, k)
        end
    end
end
table.foreach_pairs = foreach_pairs