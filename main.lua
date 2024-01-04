require "settings"
require "pieces"

function love.load()
    love.graphics.setBackgroundColor(187/255,208/255,150/255)

    grid = {}
    for y = 1, gridHeight do
        grid[y] = {}
        for x = 1, gridWidth do
            grid[y][x] = ' '
        end
    end
end

function love.draw()
    for y = 1, gridHeight do
        for x = 1, gridWidth do
            love.graphics.setColor(231/255,238/255,218/255)
            love.graphics.rectangle(
                'fill',
                offset_x + (x - 1) * blocksSpacing,
                offset_y + (y - 1) * blocksSpacing,
                blockSize,
                blockSize
            )
        end
    end
end