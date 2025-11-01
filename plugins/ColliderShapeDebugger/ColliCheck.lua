LoadTexture("Collision_render", "render_colli.png")
LoadImage("collision_rect", "Collision_render", 0, 0, 128, 128)
LoadImage("collision_rect1", "Collision_render", 0, 0, 32, 128)
LoadImage("collision_rect2", "Collision_render", 32, 0, 64, 128)
LoadImage("collision_rect3", "Collision_render", 96, 0, 32, 128)
LoadImage("collision_ring", "Collision_render", 130, 0, 128, 128)

local function match_base(class, match)
    if class == match then
        return true
    elseif class.base then
        return match_base(class.base, match)
    end
end

local toggle = false
Collision_Checker = {}
Collision_Checker.list = {
    {GROUP_PLAYER, Color(255, 50, 255, 50)},
    {GROUP_PLAYER_BULLET, Color(255, 127, 127, 192)},
    {GROUP_SPELL, Color(255, 255, 50, 255)},
    {GROUP_NONTJT, Color(255, 128, 255, 255)},
    {GROUP_ENEMY, Color(255, 255, 255, 128)},
    {GROUP_BOSS, Color(255, 255, 255, 128)},
    {GROUP_ENEMY_BULLET, Color(255, 255, 50, 50)},
    {GROUP_INDES, Color(255, 255, 165, 10)},
    {GROUP_ITEM, Color(255, 50, 50, 255)}
}
function Collision_Checker.init()
    lstg.Signals:register("frame", "Collision_Checker:frame", Collision_Checker.frame)
    lstg.Signals:register("render", "Collision_Checker:render", function()
        SetViewMode("world")
        DrawCollider()
        Collision_Checker.render()
    end, 1000)
end
function Collision_Checker.frame()
    if KeyIsPressed("Special", true) then
        toggle = not toggle
    end
end
function Collision_Checker.render()
    if not toggle then
        return
    end
    for i = 1, #Collision_Checker.list do
        local c = Collision_Checker.list[i][2]
        SetImageState("collision_rect", "", c)
        SetImageState("collision_rect1", "", c)
        SetImageState("collision_rect2", "", c)
        SetImageState("collision_rect3", "", c)
        SetImageState("collision_ring", "", c)
        for _, unit in ObjList(Collision_Checker.list[i][1]) do
            if unit.colli then
                local img
                if unit.rect == true then
                    img = "collision_rect"
                else
                    img = "collision_ring"
                end
                Render(img, unit.x, unit.y, unit.rot,
                    unit.a / 64, unit.b / 64)
            end
        end
    end
end

Collision_Checker.init()