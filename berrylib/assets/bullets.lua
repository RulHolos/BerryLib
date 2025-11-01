local M = {}

M.resdesc = {
    { name = "bullet:1", type = "tex", args = {"bullets/1.png", true} },
    { name = "bullet:2", type = "tex", args = {"bullets/2.png", true} },
    { name = "bullet:3", type = "tex", args = {"bullets/3.png", true} },
    { name = "bullet:4", type = "tex", args = {"bullets/4.png", true} },
    { name = "bullet:5", type = "tex", args = {"bullets/5.png", true} },
    { name = "bullet:6", type = "tex", args = {"bullets/6.png", true} },
    { name = "bullet:7", type = "tex", args = {"bullets/7.png", true} },
    { name = "bullet:8", type = "tex", args = {"bullets/8.png", true} },
    { name = "bullet:9", type = "tex", args = {"bullets/9.png", true} },
    { name = 'bullet:arrow_big', type = 'imggrp', args = {'bullet:1', 0, 0, 129, 132, 1, 16, 2.5, 2.5} },
    { name = 'bullet:gun_bullet', type = 'imggrp', args = {'bullet:1', 129, 0, 123, 65, 1, 16, 2.5, 2.5} },
    { name = 'bullet:butterfly', type = 'imggrp', args = {'bullet:1', 252, 0, 250, 300, 1, 8, 4, 4} },
    { name = 'bullet:square', type = 'imggrp', args = {'bullet:1', 502, 0, 179, 156, 1, 16, 6, 7, true} },
    { name = 'bullet:ball_mid', type = 'imggrp', args = {'bullet:1', 681, 0, 206, 206, 1, 8, 4, 4} },
    { name = 'bullet:mildew', type = 'imggrp', args = {'bullet:1', 1075, 0, 192, 192, 1, 16, 2, 2} },
    { name = 'bullet:ellipse', type = 'imggrp', args = {'bullet:1', 887, 0, 188, 114, 1, 8, 4.5, 4.5} },
    { name = 'bullet:star_small', type = 'imggrp', args = {'bullet:3', 300, 0, 172, 173, 1, 16, 3, 3} },
    { name = 'bullet:star_big', type = 'imggrp', args = {'bullet:3', 472, 0, 177, 180, 1, 8, 5.5, 5.5} },
    { name = 'bullet:ball_big', type = 'imggrp', args = {'bullet:3', 1213, 0, 211, 211, 1, 8, 8, 8} },
    { name = 'bullet:ball_small', type = 'imggrp', args = {'bullet:3', 1012, 0, 201, 201, 1, 16, 2, 2} },
    { name = 'bullet:grain_a', type = 'imggrp', args = {'bullet:3', 832, 0, 180, 99, 1, 16, 2.5, 2.5} },
    { name = 'bullet:grain_b', type = 'imggrp', args = {'bullet:3', 649, 0, 183, 84, 1, 16, 2.5, 2.5} },
    { name = 'bullet:knife', type = 'imggrp', args = {'bullet:4', 0, 0, 233, 135, 1, 8, 4, 4} },
    { name = 'bullet:grain_c', type = 'imggrp', args = {'bullet:4', 233, 0, 223, 126, 1, 16, 2.5, 2.5} },
    { name = 'bullet:arrow_small', type = 'imggrp', args = {'bullet:4', 456, 0, 142, 74, 1, 16, 2.5, 2.5} },
    { name = 'bullet:kite', type = 'imggrp', args = {'bullet:4', 598, 0, 187, 119, 1, 16, 2.5, 2.5} },
    { name = 'bullet:star_big_b', type = 'imggrp', args = {'bullet:5', 0, 0, 146, 146, 1, 8, 6, 6} },
    { name = 'bullet:ball_mid_b', type = 'imggrp', args = {'bullet:5', 146, 0, 188, 188, 1, 8, 4, 4} },
    { name = 'bullet:arrow_mid', type = 'imggrp', args = {'bullet:5', 334, 0, 154, 60, 1, 8, 3.5, 3.5} },
    { name = 'bullet:heart', type = 'imggrp', args = {'bullet:5', 488, 0, 158, 158, 1, 8, 9, 9} },
    { name = 'bullet:knife_b', type = 'imggrp', args = {'bullet:5', 877, 0, 233, 135, 1, 8, 3.5, 3.5} },
    { name = 'bullet:ball_mid_c', type = 'imggrp', args = {'bullet:5', 1110, 0, 141, 141, 1, 8, 4, 4} },
    { name = 'bullet:money', type = 'imggrp', args = {'bullet:5', 646, 0, 145, 145, 1, 8, 4, 4} },
    { name = 'bullet:ball_mid_d', type = 'imggrp', args = {'bullet:5', 791, 0, 86, 86, 1, 8, 3, 3} },
    { name = 'bullet:ball_light', type = 'imggrp', args = {'bullet:6', 0, 0, 228, 228, 4, 2, 11.5, 11.5} },
    { name = 'bullet:ball_light_dark', type = 'imggrp', args = {'bullet:6', 0, 0, 228, 228, 4, 2, 11.5, 11.5} },
    { name = 'bullet:ball_huge', type = 'imggrp', args = {'bullet:2', 0, 0, 300, 300, 4, 2, 13.5, 13.5} },
    { name = 'bullet:ball_huge_dark', type = 'imggrp', args = {'bullet:2', 0, 0, 300, 300, 4, 2, 13.5, 13.5} },
    { name = 'bullet:silence', type = 'imggrp', args = {'bullet:7', 0, 0, 126, 55, 1, 8, 4.5, 4.5} },
    { name = 'bullet:water_drop1', type = 'ani', args = {'bullet:9', 0 * 300, 0, 300, 300, 1, 4, 4, 4, 4} },
    { name = 'bullet:water_drop2', type = 'ani', args = {'bullet:9', 1 * 300, 0, 300, 300, 1, 4, 4, 4, 4} },
    { name = 'bullet:water_drop3', type = 'ani', args = {'bullet:9', 2 * 300, 0, 300, 300, 1, 4, 4, 4, 4} },
    { name = 'bullet:water_drop4', type = 'ani', args = {'bullet:9', 3 * 300, 0, 300, 300, 1, 4, 4, 4, 4} },
    { name = 'bullet:water_drop5', type = 'ani', args = {'bullet:9', 4 * 300, 0, 300, 300, 1, 4, 4, 4, 4} },
    { name = 'bullet:water_drop6', type = 'ani', args = {'bullet:9', 5 * 300, 0, 300, 300, 1, 4, 4, 4, 4} },
    { name = 'bullet:water_drop7', type = 'ani', args = {'bullet:9', 6 * 300, 0, 300, 300, 1, 4, 4, 4, 4} },
    { name = 'bullet:water_drop8', type = 'ani', args = {'bullet:9', 7 * 300, 0, 300, 300, 1, 4, 4, 4, 4} },
    { name = 'bullet:water_drop_dark1', type = 'ani', args = {'bullet:9', 0 * 300, 0, 300, 300, 1, 4, 4, 4, 4} },
    { name = 'bullet:water_drop_dark2', type = 'ani', args = {'bullet:9', 1 * 300, 0, 300, 300, 1, 4, 4, 4, 4} },
    { name = 'bullet:water_drop_dark3', type = 'ani', args = {'bullet:9', 2 * 300, 0, 300, 300, 1, 4, 4, 4, 4} },
    { name = 'bullet:water_drop_dark4', type = 'ani', args = {'bullet:9', 3 * 300, 0, 300, 300, 1, 4, 4, 4, 4} },
    { name = 'bullet:water_drop_dark5', type = 'ani', args = {'bullet:9', 4 * 300, 0, 300, 300, 1, 4, 4, 4, 4} },
    { name = 'bullet:water_drop_dark6', type = 'ani', args = {'bullet:9', 5 * 300, 0, 300, 300, 1, 4, 4, 4, 4} },
    { name = 'bullet:water_drop_dark7', type = 'ani', args = {'bullet:9', 6 * 300, 0, 300, 300, 1, 4, 4, 4, 4} },
    { name = 'bullet:water_drop_dark8', type = 'ani', args = {'bullet:9', 7 * 300, 0, 300, 300, 1, 4, 4, 4, 4} },
    { name = 'bullet:music1', type = 'ani', args = {'bullet:9', 0 * 157, 0, 157, 157, 1, 3, 8, 4, 4} },
    { name = 'bullet:music2', type = 'ani', args = {'bullet:9', 1 * 157, 0, 157, 157, 1, 3, 8, 4, 4} },
    { name = 'bullet:music3', type = 'ani', args = {'bullet:9', 2 * 157, 0, 157, 157, 1, 3, 8, 4, 4} },
    { name = 'bullet:music4', type = 'ani', args = {'bullet:9', 3 * 157, 0, 157, 157, 1, 3, 8, 4, 4} },
    { name = 'bullet:music5', type = 'ani', args = {'bullet:9', 4 * 157, 0, 157, 157, 1, 3, 8, 4, 4} },
    { name = 'bullet:music6', type = 'ani', args = {'bullet:9', 5 * 157, 0, 157, 157, 1, 3, 8, 4, 4} },
    { name = 'bullet:music7', type = 'ani', args = {'bullet:9', 6 * 157, 0, 157, 157, 1, 3, 8, 4, 4} },
    { name = 'bullet:music8', type = 'ani', args = {'bullet:9', 7 * 157, 0, 157, 157, 1, 3, 8, 4, 4} },
}

function M.postLoad()
    for i = 1, 16 do
        lstg.SetImageScale('bullet:arrow_big' .. i, 1/8.25)
        lstg.SetImageScale('bullet:gun_bullet' .. i, 1/7.69)
        lstg.SetImageScale('bullet:square' .. i, 1/11.19)
        lstg.SetImageScale('bullet:mildew' .. i, 1/12)
        lstg.SetImageScale('bullet:star_small' .. i, 1/10.75)
        lstg.SetImageScale('bullet:ball_small' .. i, 1/15.56)
        lstg.SetImageScale('bullet:grain_a' .. i, 1/11.25)
        lstg.SetImageScale('bullet:grain_b' .. i, 1/11.44)
        lstg.SetImageScale('bullet:grain_c' .. i, 1/13.94)
        lstg.SetImageScale('bullet:arrow_small' .. i, 1/8)
        lstg.SetImageScale('bullet:kite' .. i, 1/11.69)
    end
    for i = 1, 8 do
        lstg.SetImageScale('bullet:butterfly' .. i, 1/9.38)
        lstg.SetImageScale('bullet:ball_mid' .. i, 1/9.44)
        lstg.SetImageScale('bullet:ellipse' .. i, 1/5.88)
        lstg.SetImageScale('bullet:star_big' .. i, 1/5.53)
        lstg.SetImageScale('bullet:ball_big' .. i, 1/6.59)
        lstg.SetImageScale('bullet:knife' .. i, 1/6)
        lstg.SetImageScale('bullet:star_big_b' .. i, 1/4.56)
        lstg.SetImageScale('bullet:ball_mid_b' .. i, 1/5.88)
        lstg.SetImageScale('bullet:arrow_mid' .. i, 1/4.81)
        lstg.SetImageScale('bullet:heart' .. i, 1/4.94)
        lstg.SetImageScale('bullet:knife_b' .. i, 1/6)
        lstg.SetImageScale('bullet:ball_mid_c' .. i, 1/8.81)
        lstg.SetImageScale('bullet:money' .. i, 1/9.06)
        lstg.SetImageScale('bullet:ball_mid_d' .. i, 1/5.38)
        lstg.SetImageState('bullet:ball_mid_d' .. i, 'mul+add')
        lstg.SetImageScale('bullet:ball_light' .. i, 1/3.56)
        lstg.SetImageScale('bullet:ball_light_dark' .. i, 1/3.56)
        lstg.SetImageState('bullet:ball_light' .. i, 'mul+add')
        lstg.SetImageScale('bullet:ball_huge' .. i, 1/4.69)
        lstg.SetImageScale('bullet:ball_huge_dark' .. i, 1/4.69)
        lstg.SetImageState('bullet:ball_huge' .. i, 'mul+add')
        lstg.SetAnimationScale('bullet:water_drop' .. i, 1/6.25)
        lstg.SetAnimationState('bullet:water_drop' .. i, 'mul+add')
        lstg.SetAnimationScale('bullet:water_drop_dark' .. i, 1/6.25)
        lstg.SetAnimationScale('bullet:music' .. i, 1/4.91)
        lstg.SetImageScale('bullet:silence' .. i, 1/3.94)
    end
end

M.data = {
    bullet_data = {
        ['arrow_big'] = { 16, 0.6, '', 1, 1, false },
        ['gun_bullet'] = { 16, 0.4, '' },
        ['square'] = { 16, 0.8, '' },
        ['mildew'] = { 16, 0.401, '' },
        ['star_small'] = { 16, 0.5, '' },
        ['ball_small'] = { 16, 0.402, '' },
        ['grain_a'] = { 16, 0.403, '' },
        ['grain_b'] = { 16, 0.404, '' },
        ['grain_c'] = { 16, 0.405, '' },
        ['kite'] = { 16, 0.406, '' },
        ['arrow_small'] = { 16, 0.407, '' },
        ['butterfly'] = { 8, 0.7, '' },
        ['ellipse'] = { 8, 0.701, '' },
        ['water_drop'] = { 8, 0.702, 'mul+add' },
        ['water_drop_dark'] = { 8, 0.702, '' },
        ['ball_mid'] = { 8, 0.75, '' },
        ['ball_mid_b'] = { 8, 0.751, '' },
        ['ball_mid_c'] = { 8, 0.752, '' },
        ['ball_mid_d'] = { 8, 0.753, 'mul+add' },
        ['money'] = { 8, 0.753, '' },
        ['knife'] = { 8, 0.754, '' },
        ['knife_b'] = { 8, 0.755, '' },
        ['star_big'] = { 8, 0.998, '' },
        ['star_big_b'] = { 8, 0.999, '' },
        ['ball_big'] = { 8, 1.0, '' },
        ['heart'] = { 8, 1.0, '' },
        ['arrow_mid'] = { 8, 0.61, '' },
        ['ball_light'] = { 8, 2.0, 'mul+add' },
        ['ball_light_dark'] = { 8, 2.0, '' },
        ['ball_huge'] = { 8, 2.0, 'mul+add' },
        ['ball_huge_dark'] = { 8, 2.0, '' },
        ['music'] = { 8, 0.8, '' },
        ['silence'] = { 8, 0.8, '' },
    },
}

return M