require "settings"
require "pieces"
require "functions"

function love.load()
    love.graphics.setBackgroundColor(187/255,208/255,150/255)
    drawGrid()
end

function love.draw()
    fillBoard()
    drawPiece()
end

function love.keypressed(key)
    rotate(key)
    move(key)
end

function love.update(dt)
    math.randomseed(os.clock()*100000000000)
    timer = timer + dt
    if timer >= pieces_fall_speed then
        timer = 0
        if piece_y < gridHeight - #piecesStructures[pieceType][pieceRotation] then
            piece_y = piece_y + 1
        else
            lockPiece()
            pieceType = math.random(1, #piecesStructures)
            pieceRotation = 1
            piece_x = 3
            piece_y = 0
        end
    end
end