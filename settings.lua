gridWidth = 10
gridHeight = 20

blockSize = 25
blocksSpacing = blockSize + 1
piece_x = 3
piece_y = 0
offset_x = love.graphics.getWidth() / 2 - 5 * blocksSpacing
offset_y = love.graphics.getHeight() / 2 - 10 * blocksSpacing

grid_left_boundary = 0
grid_right_boundary = 10

pieces_fall_speed = 0.5

grid = {}

timer = 0
pieceType = 4
pieceRotation = 1

colors = {
    [' '] = {.87, .87, .87},
    i = {153/255, 0, 0},
    j = {153/255, 153/255, 153/255},
    l = {0, 76/255, 153/255},
    o = {76/255, 0, 153/255},
    s = {153/255, 0, 76/255},
    t = {153/255, 153/255, 0},
    z = {0, 153/255, 153/255},
}