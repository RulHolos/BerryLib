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

---@generic T
---@generic V
---@param t T
---@param v V
table.has_ivalue = function(t, v)
    for _, val in ipairs(t) do
        if val == v then
            return true
        end
    end
    return false
end

---@generic T
---@generic V
---@param t T
---@param v V
table.has_ikey = function(t, v)
    for key, _ in ipairs(t) do
        if key == v then
            return true
        end
    end
    return false
end

---@generic T
---@generic V
---@param t T
---@param v V
table.has_value = function(t, v)
    for _, val in pairs(t) do
        if val == v then
            return true
        end
    end
    return false
end

---@generic T
---@generic V
---@param t T
---@param v V
table.has_key = function(t, v)
    for key, _ in pairs(t) do
        if key == v then
            return true
        end
    end
    return false
end

---Apply a function to each value in the given array that satisfies a predicate.
---@param tbl table
---@param predicate fun(v:any, i:integer):boolean
---@param action fun(v:any, i:integer)
table.foreach_ipairs = function(tbl, predicate, action)
	for i, v in ipairs(tbl) do
		if predicate(v, i) then
			action(v, i)
		end
	end
end

---Apply a function to each value in the given table that satisfies a predicate.
---@param tbl table
---@param predicate fun(v:any, k:any):boolean
---@param action fun(v:any, k:any)
table.foreach_pairs = function(tbl, predicate, action)
    for k, v in pairs(tbl) do
        if predicate(v, k) then
            action(v, k)
        end
    end
end