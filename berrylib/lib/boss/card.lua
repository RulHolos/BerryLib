---@class berry.boss.card
---@field name string Full name of the spell card
---@field protect_time integer
---@field dmg_reduction_time integer
---@field timer_time integer
---@field timer_time_max integer
---@field max_hp integer
---@field hp integer
---@field is_non_spell boolean
---@field drop_table table Eg { power = 2, point = 3 }
---@field immune_to_bomb boolean
---@field timeout boolean
---@field timer integer
---@field manager berry.boss.boss_manager
local card = {}

function card:before() end

function card:init() end
function card:frame() end
function card:render() end

function card:beforedel() end
function card:del() end
function card:afterdel() end

---Creates a new spellcard instance
---@param name string Full name of the spell card
function card.create(name, protect_time, dmg_reduction_time, timer_time, hp, drop_table, immune_to_bomb, timeout)
    if protect_time > dmg_reduction_time or dmg_reduction_time > timer_time then
        error('(protect_time <= dmg_reduction_time <= timer_time) must be satisfied.')
    end

    ---@type berry.boss.card
---@diagnostic disable-next-line: missing-fields Expected since manager is set after.
    local c = {
        name = name,
        protect_time = int(protect_time) * 60,
        dmg_reduction_time = int(dmg_reduction_time) * 60,
        timer_time = int(timer_time) * 60,
        timer_time_max = int(timer_time) * 60,
        max_hp = hp,
        hp = hp,
        is_non_spell = name == '',
        drop_table = drop_table,
        immune_to_bomb = immune_to_bomb or false,
        timeout = timeout or false,
        timer = 0
    }

    for k, v in pairs(card) do
        c[k] = v
    end

    return c
end

---Deletes all INDES, ENEMY BULLET and ENEMY. Doesn't destroy boss objects.
function card.delete_all_danger()
    for _,unit in ObjList(GROUP_INDES) do
		Del(unit)
	end
	for _,unit in ObjList(GROUP_ENEMY_BULLET) do
		Del(unit)
	end
	for _,unit in ObjList(GROUP_ENEMY) do
		Del(unit)
	end
end

return card