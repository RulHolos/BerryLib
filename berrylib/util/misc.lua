--- Player Death effect
function render_circle(x, y, r, point)
    local ang = 360 / (2 * point)
    for angle = 360 / point, 360, 360 / point do
        local x1, y1 = x + r * cos(angle + ang), y + r * sin(angle + ang)
        local x2, y2 = x + r * cos(angle - ang), y + r * sin(angle - ang)
        Render4V('_rev_white',
            x, y, 0.5,
            x, y, 0.5,
            x1, y1, 0.5,
            x2, y2, 0.5)
    end
end

LoadTexture("particles", "ui/particles.png")
LoadImageGroup("parimg", "particles", 0, 0, 32, 32, 4, 4)

CopyImage("_rev_white", "white")
SetImageState('_rev_white', 'add+sub',
        Color(255, 255, 255, 255),
        Color(255, 255, 255, 255),
        Color(255, 0, 0, 0),
        Color(255, 0, 0, 0)
)