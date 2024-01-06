function drawGrid()
    for x = 1, gridWidth do
        grid[x] = {}
        for y = 1, gridHeight do
            grid[x][y] = ' '
        end
    end
end

function drawBlock(block, x, y)
    local color = colors[block]
    love.graphics.setColor(color)

    love.graphics.rectangle(
        'fill',
        offset_x + (x - 1) * blocksSpacing,
        offset_y + (y - 1) * blocksSpacing,
        blockSize,
        blockSize
    )
end

function drawPiece()
    for y = 1, #piecesStructures[pieceType][pieceRotation] do
        for x = 1, #piecesStructures[pieceType][pieceRotation][1] do
            local block = piecesStructures[pieceType][pieceRotation][y][x]
            if block ~= ' ' then
                drawBlock(block, x + piece_x, y + piece_y)
            end
        end
    end
end

function fillBoard()
    for x = 1, gridWidth do
        for y = 1, gridHeight do
            drawBlock(grid[x][y], x, y)
        end
    end
end

function rotate(key)
    if key == 'down' then
        pieceRotation = (pieceRotation % #piecesStructures[pieceType]) + 1        
    elseif key == 'up' then
        pieceRotation = ((pieceRotation - 2) % #piecesStructures[pieceType]) + 1
    end
end

function move(key)
    if key == 'left' then
        if piece_x > grid_left_boundary then
            piece_x = piece_x - 1
        end
    elseif key == 'right' then
        piece_right_boundary = grid_right_boundary - #piecesStructures[pieceType][pieceRotation][1]
        if piece_x < piece_right_boundary then
            piece_x = piece_x + 1
        end
    end
end

function checkCollision()
    if piece_y >= gridHeight - #piecesStructures[pieceType][pieceRotation] then
        return true
    end
    for y = 1, #piecesStructures[pieceType][pieceRotation] do
        for x = 1, #piecesStructures[pieceType][pieceRotation][1] do
            local block = piecesStructures[pieceType][pieceRotation][y][x]
            if block ~= ' ' and grid[x + piece_x][y + piece_y + 1] ~= ' ' then
                return true
            end
        end
    end
    return false
end

function lockPiece()
    for y = 1, #piecesStructures[pieceType][pieceRotation] do
        for x = 1, #piecesStructures[pieceType][pieceRotation][1] do
            local block = piecesStructures[pieceType][pieceRotation][y][x]
            if block ~= ' ' then
                grid[x + piece_x][y + piece_y] = block
            end
        end
    end
end

function generatePiece()
    pieceType = math.random(1, #piecesStructures)
    pieceRotation = 1
    piece_x = 3
    piece_y = 0
end