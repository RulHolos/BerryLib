local patch = "lib.players.reimu_player.behaviors."
local shoot = require(patch .. "shoot")
local render = require(patch .. "render")
local spell = require(patch .. "spell")
local support = require(patch .. "support")

---@class lstg.Player.ReimuPlayer : lstg.Player
ReimuPlayer = Class(PlayerSystem)

function ReimuPlayer:init()
    PlayerSystem.init(self)
    -----------------------------------------
    LoadTexture("reimu_player", "players/reimu_player/reimu.png")
    -----------------------------------------

    self.name = "Reimu"
    self.A, self.B = 0.5, 0.5

    -- Order matters
    self:attachBehavior(support)
    self:attachBehavior(render)
    self:attachBehavior(spell)
    self:attachBehavior(shoot)

    self:getBehavior("Move").normal_speed = 4.5
end

AddPlayerToPlayerList("Reimu Hakurei", "Reimu", ReimuPlayer)