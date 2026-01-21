--[[
Boss Manager System

This whole class file is meant to be overriden by objected inherited from it.
In C#, `berry.boss.boss_manager` would be considered an abstract class but I have no way to tell the lua
lang server that it is.

This class can be inherited to work with the editor nicely but also can work without being abstract.

Warning: This class and all it implements isn't meant to be modified using the editor. The boss object code, ui and all
is hidden from the editor. If you want to modify how the UI for the boss looks or its WalkImage system, you will need
to get your hands dirty on this code.
]]

local boss = require("berrylib.lib.boss.boss")
local bossui = require("berrylib.lib.boss.boss_ui")
local card_system = require("berrylib.lib.boss.boss_card_system")

---@class berry.boss.boss_manager : lstg.object
local M = Class(Object)
BossManager = M

function M:init()
    lstg.var.boss_manager = self
    lstg.Signals:setStatic("BossEnded", false)

    self.addBoss = M.addBoss
    self.getBossFromIndex = M.getBossFromIndex
    self.getBossFromName = M.getBossFromName
    self.foreachBoss = M.foreachBoss
    self.scope = M.scope
    self.dealDamage = M.dealDamage
    self.setSpellBackground = M.setSpellBackground
    self.endBoss = M.endBoss
    self.explode = M.explode
    self.leave = M.leave

    ---@type berry.boss.boss[]
    self.bosses = {}
    self.card_system = card_system.create(self)
    ---@type berry.boss.ui
    self.boss_ui = bossui.create(self)

    ---@type integer Number of boss objects currently taking damage (dmg / hit_number)
    self.hit_number = 0

    ---Total name of the bosses separated by "&"
    self.boss_name = ""
end

function M:frame()
    Task.Do(self)

    self.card_system:frame()
end

function M:render()
    self.card_system:render()
end

---Adds a new boss instance to this manager.
---@param name string
---@param img string Image resource name
---@param x number Spawn x coords
---@param y number Spawn y coords
---@param aura any --TODO
function M:addBoss(name, img, x, y, aura)
    table.insert(self.bosses, boss.create(name, img, x, y, aura, self))

    self.boss_name = ""
    for k, v in ipairs(self.bosses) do
        if k == #self.bosses then
            self.boss_name = self.boss_name .. v.name
        else
            self.boss_name = self.boss_name .. v.name .. " & "
        end
    end
end

---@param id integer Index of the boss in order of addition.
---@return berry.boss.boss
function M:getBossFromIndex(id)
    return self.bosses[id]
end

---Tries to find a boss by it's name. Returns nil if not found.
---@param name string The matching name of the boss you want to find.
---@return berry.boss.boss| nil
function M:getBossFromName(name)
	for _, b in ipairs(self.bosses) do
		if b.name == name then
			return b
		end
	end
	return nil
end

---@param wait boolean If true, this will wait for every actions to be done before continuing.
---@param internal_wait boolean If true, this will wait for each action to be done before starting the other ones.
---@param f fun(boss:berry.boss.boss)
function M:foreachBoss(wait, internal_wait, f)
    local actions_to_do, actions_done = #self.bosses, 0
    for _, b in ipairs(self.bosses) do
        if internal_wait then
            f(b)
            actions_done = actions_done + 1
        else
            Task.new(self, function()
                f(b)
                actions_done = actions_done + 1
            end)
        end
    end
    if wait then
        while actions_done ~= actions_to_do do
            Task.wait()
        end
    end
end

---@param f fun(self:berry.boss.boss_manager)
function M:scope(f)
    assert(#self.bosses ~= 0, "There must be at least one boss present on the scene.")
    f(self)
    Del(self)
end

---Deals damage to the current spell card. Is called by every bosses when hit.
---@param dmg number The number of damage taken by one boss. Will be devided by all currently hit bosses count for real damage.
function M:dealDamage(dmg)
	if self.card_system.current_card == nil then
		return
	end
	if self.card_system.current_card.protect_time ~= 0 or self.card_system.current_card.timeout then
		return
	end

	assert(self.hit_number ~= 0, "self.hit_number can't be 0.")
	local dmg_taken = dmg / self.hit_number

	lstg.var.score = lstg.var.score + (8 * dmg_taken) -- Before reduction

	if self.card_system.current_card.dmg_reduction_time ~= 0 then
		dmg_taken = dmg_taken / 3
	end
	self.card_system.current_card.hp =
		clamp(self.card_system.current_card.hp - dmg_taken, 0, self.card_system.current_card.max_hp)

	self.hit_number = 0 -- Reset for next frame
end

---Sets the background for all spells of this boss instance.
---
---Please do not create the spell instance yourself, just pass the object definition.
---@param bg berry.boss.bossUI.spellBG
function M:setSpellBackground(bg)
    self.boss_ui.spell_bg = bg.create(self.boss_ui)
end

---Makes all bosses stay in place and end the boss fight.
---
---Please use in the manager Scope.
---
---WARNING: The bosses objects will NOT be deleted. Don't use this for midbosses.
function M:endBoss()
    Task.wait(30)
    self.boss_ui:fade_out()
    Task.wait(60)
    Del(self)
end

function M:leave()
    self:foreachBoss(false, false, function(b)
        local ran_x = ran:Int(-300, 300)
        b:move(ran_x, 400, 60, MOVE_ACC_DEC)
    end)
    Task.wait(30)
    self.boss_ui:fade_out()
    Task.wait(60)
    self:foreachBoss(true, false, function(b)
        Kill(b)
    end)
    Del(self)
end

function M:explode()
    self:foreachBoss(false, false, function(b)
        b:explode()
    end)
    Task.wait(30)
    self.boss_ui:fade_out()
    Task.wait(60)
    Del(self)
end

function M:del()
    lstg.Signals:setStatic("BossEnded", true)
end

---Creates a new BossManager instance.
---@nodiscard
---@return berry.boss.boss_manager
function M.create()
    return New(M)
end

lstg.RegisterGameObjectClass(M)

return M