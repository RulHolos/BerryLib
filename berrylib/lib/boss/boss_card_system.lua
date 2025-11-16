---@class berry.boss.boss_card_system
local M = {}

---@param manager berry.boss.boss_manager
function M:init(manager)
    ---@type berry.boss.card[] | berry.boss.card[][]
    self.card_queue = {}
    ---@type berry.boss.card[] | berry.boss.card[][]
    self.card_queue_total = {}
    ---@type berry.boss.card
    self.current_card = nil
    ---@type berry.boss.card
    self.next_card = nil

    ---@private
    self.manager = manager

    ---@type integer Total spell count, counting deleted ones. (Mainly for UI)
    self.total_card_count = 0
end

function M:frame()
    if self.current_card then
        self.current_card:frame()
        self.current_card.timer = self.current_card.timer + 1
        self.current_card.timer_time = max(0, self.current_card.timer_time - 1)
        self.current_card.protect_time = max(0, self.current_card.protect_time - 1)
        self.current_card.dmg_reduction_time = max(0, self.current_card.dmg_reduction_time - 1)

        if self.current_card.timer_time == 0 then
            self.current_card.hp = 0
        end
    end
end

function M:render()
    if self.current_card then
        self.current_card:render()
    end
end

---Adds a single card to the card queue.
---@param card berry.boss.card
function M:addCard(card)
    card.manager = self.manager
    table.insert(self.card_queue, card)
    table.insert(self.card_queue_total, card)
    self.total_card_count = self.total_card_count + 1
end

---Adds all the cards in `cards` to the card queue.
---@param cards berry.boss.card[]
function M:addCardRange(cards)
    for i = 1, #cards do
        self:addCard(cards[i])
    end
end

---@return berry.boss.card|nil @The current active card, or nil if there is none.
function M:getCurrentCard()
    return self.current_card
end

function M:getNextCard()
    if #self.card_queue == 0 then return nil end

    self.next_card = self.card_queue[1]

    return self.next_card
end

---Moves to the next spell card in the queue, if any.
---@param cast boolean? Force the spell card cast animation to play. Will cast by default if the spell-card is not a non-spell.
function M:goToNext(cast)
    if self.next_card then
        self.current_card = self.next_card
        table.remove(self.card_queue, 1)
        self.next_card = nil
    else
        self.current_card = table.remove(self.card_queue, 1)
    end

    if self.current_card then
        self.current_card:before()
        self.current_card:init()
        if not self.current_card.is_non_spell or cast then
            self.manager.boss_ui:cast_spell()
        end

        while self.current_card.hp > 0 do
            Task.wait(1)
        end
    end

    while self.current_card.hp > 0 do
        Task.wait()
    end

    self.current_card:beforedel()
    self.current_card:del()
    if not self.current_card.is_non_spell and self.manager.boss_ui.spell_bg ~= nil then
        --bg.fade_out(self.manager.boss_ui.spell_bg, 60)
    end
    self.current_card:afterdel()
    self.current_card = nil
end

---@nodiscard
---@param manager berry.boss.boss_manager
---@return berry.boss.boss_card_system
function M.create(manager)
    local cs = makeInstance(M)
    cs:init(manager)
    return cs
end

return M