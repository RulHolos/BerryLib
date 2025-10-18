local patch = "lib.players.reimu_player.behaviors."
local shoot = require(patch .. "shoot")
local render = require(patch .. "render")

---@class lstg.Player.ReimuPlayer : lstg.Player
ReimuPlayer = Class(PlayerSystem)

function ReimuPlayer:init(slot)
    PlayerSystem.init(self, slot)

    self.name = "Reimu"
    self.A, self.B = 0.5, 0.5

    self:attachBehavior(render)
    self:attachBehavior(shoot)

    self:getBehavior("Move").normal_speed = 4.5
end

AddPlayerToPlayerList("Reimu Hakurei", "Reimu", ReimuPlayer)