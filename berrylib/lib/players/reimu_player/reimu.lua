local patch = "lib.players.reimu_player.behaviors."
local shoot = require(patch .. "shoot")
local render = require(patch .. "render")
local spell = require(patch .. "spell")

---@class lstg.Player.ReimuPlayer : lstg.Player
ReimuPlayer = Class(PlayerSystem)

function ReimuPlayer:init()
    PlayerSystem.init(self)
    -----------------------------------------
    LoadTexture("reimu_player", "players/reimu_player/reimu.png")
    -----------------------------------------
    LoadImage("reimu_bullet_main", "reimu_player", 192, 160, 64, 16, 16, 16)
    SetImageState("reimu_bullet_main", "", Color(0xA0FFFFFF))
    SetImageCenter("reimu_bullet_main", 56, 8)
    -----------------------------------------

    self.name = "Reimu"
    self.A, self.B = 0.5, 0.5

    self:attachBehavior(render)
    self:attachBehavior(shoot)
    self:attachBehavior(spell)

    self:getBehavior("Move").normal_speed = 4.5
end

AddPlayerToPlayerList("Reimu Hakurei", "Reimu", ReimuPlayer)