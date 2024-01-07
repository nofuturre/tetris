require "settings"
require "pieces"
require "functions"

function love.load()
    love.graphics.setBackgroundColor(107/255,134/255,59/255)
    currentScreen = 'menu'
    initGrid()
end

function love.draw()
    if currentScreen == 'menu' then
        drawMenu()
    elseif currentScreen == 'game' then
        fillBoard()
        drawPiece()
    end
end

function love.keypressed(key)
    rotate(key)
    move(key)
    save_game(key)
end

function love.update(dt)
    if currentScreen == 'menu' then
        menuUpdate(dt)
    elseif currentScreen == 'game' then
        math.randomseed(os.clock()*100000000000)
        timer = timer + dt
        if timer >= pieces_fall_speed then
            timer = 0
            if checkCollision('v') then
                if piece_y <= 1 then
                    currentScreen = 'menu'
                end
                lockPiece()
                findCompleteRows()
                generatePiece()
            else
                piece_y = piece_y + 1
            end
        end
    end
end