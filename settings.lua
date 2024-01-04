gridWidth = 10
gridHeight = 20

blockSize = 25
blocksSpacing = blockSize + 1
offset_x = love.graphics.getWidth() / 2 - 5 * blocksSpacing
offset_y = love.graphics.getHeight() / 2 - 10 * blocksSpacing

colors = {
    [' '] = {.87, .87, .87},
    i = {.47, .76, .94},
    j = {.93, .91, .42},
    l = {.49, .85, .76},
    o = {.92, .69, .47},
    s = {.83, .54, .93},
    t = {.97, .58, .77},
    z = {.66, .83, .46},
}