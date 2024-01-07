require "menu_settings"

function coursorOnLoadGame(x, y)
    if x > button1_x and x < button1_x + button_width and y > buttons_y and y < buttons_y + button_height then
        return true
    end
    return false
end

function coursorOnNewGame(x, y)
    if x > button2_x and x < button2_x + button_width and y > buttons_y and y < buttons_y + button_height then
        return true
    end
    return false
end

function menuUpdate(dt)
    if love.mouse.isDown(1) then
        local x, y = love.mouse.getX(), love.mouse.getY()
        if coursorOnNewGame(x, y) then
            currentScreen = 'game'
        elseif coursorOnLoadGame(x, y) then
            loadGame()
            currentScreen = 'game'
        end
    end
end

function loadGame()
    local file = io.open("game_state.txt", "r")

    if file then
        local x = 1
        local y = 1
        local char = file:read(1)

        while char do
            grid[x][y] = char
            y = y + 1
            char = file:read(1)
            if char == ';' then
                x = x + 1
                y = 1
                char = file:read(1)
            end
        end

        file:close()
    else
        print("Error: Unable to open file for reading.")
    end
end

function drawMenu()
    love.graphics.reset()
    love.graphics.setBackgroundColor(107/255,134/255,59/255)
    love.graphics.draw(button_load_game, button1_x, buttons_y)
    love.graphics.draw(button_new_game, button2_x, buttons_y)
end

function initGrid()
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

function allignToBorder(new_rotation)
    if  piece_x == grid_right_boundary - #piecesStructures[pieceType][pieceRotation][1] then
        len_diff = #piecesStructures[pieceType][new_rotation][1] - #piecesStructures[pieceType][pieceRotation][1]
        if len_diff > 0 then
            piece_x = piece_x - len_diff
        end
    end
end

function rotate(key)
    if key == 'down' then
        new_rotation = (pieceRotation % #piecesStructures[pieceType]) + 1
        allignToBorder(new_rotation)
        pieceRotation = new_rotation
        rotate_piece:play()
    elseif key == 'up' then
        new_rotation = ((pieceRotation - 2) % #piecesStructures[pieceType]) + 1
        allignToBorder(new_rotation)
        pieceRotation = new_rotation
        rotate_piece:play()
    end
end

function move(key)
    if key == 'left' then
        if piece_x > grid_left_boundary and not checkCollision('hl') then
            piece_x = piece_x - 1
        end
    elseif key == 'right' then
        piece_right_boundary = grid_right_boundary - #piecesStructures[pieceType][pieceRotation][1]
        if piece_x < piece_right_boundary and not checkCollision('hr') then
            piece_x = piece_x + 1
        end
    end
end

function save_game(key)
    if key == 's' then
        local file = io.open("game_state.txt", "w")
    
        if file then
            for x = 1, gridWidth do
                for y = 1, gridHeight do
                  file:write(grid[x][y])
                end
                file:write(";")
              end
            
            file:close()
        else
            print("Error opening file for writing.")
        end
        currentScreen = 'menu'
    end
end

function checkHorizontalLeftCollision(block, x, y)
    if block ~= ' ' and grid[x + piece_x - 1][y + piece_y] ~= ' ' then
        return true
    end
end

function checkHorizontalRightCollision(block, x, y)
    if block ~= ' ' and grid[x + piece_x + 1][y + piece_y] ~= ' ' then
        return true
    end
end

function checkVerticalCollision(block, x, y)
    if block ~= ' ' and grid[x + piece_x][y + piece_y + 1] ~= ' ' then
        return true
    end
end

function checkCollision(type)
    if piece_y >= gridHeight - #piecesStructures[pieceType][pieceRotation] then
        return true
    end
    for y = 1, #piecesStructures[pieceType][pieceRotation] do
        for x = 1, #piecesStructures[pieceType][pieceRotation][1] do
            local block = piecesStructures[pieceType][pieceRotation][y][x]
            if type == 'hl' then
                if checkHorizontalLeftCollision(block, x, y) then
                    return true
                end
            elseif type == 'hr' then
                if checkHorizontalRightCollision(block, x, y) then
                    return true
                end
            elseif type == 'v' then
                if checkVerticalCollision(block, x, y) then
                    return true
                end
            end
        end
    end
    return false
end

function lockPiece()
    lock_piece:setVolume(0.2)
    lock_piece:play()
    for y = 1, #piecesStructures[pieceType][pieceRotation] do
        for x = 1, #piecesStructures[pieceType][pieceRotation][1] do
            local block = piecesStructures[pieceType][pieceRotation][y][x]
            if block ~= ' ' then
                grid[x + piece_x][y + piece_y] = block
            end
        end
    end
end

function clearRow(complete_row)
    clear_row:play()
    for x = 1, gridWidth do
        for y = complete_row, 2, -1 do
            grid[x][y] = grid[x][y - 1]
        end
    end
end

function findCompleteRows()
    for y = 1, gridHeight do
        local complete_row = true
        for x = 1, gridWidth do
            if grid[x][y] == ' ' then
                complete_row = false
            end
        end
        if complete_row then
            clearRow(y)
        end
    end
end

function generatePiece()
    pieceType = math.random(1, #piecesStructures)
    pieceRotation = 1
    piece_x = 3
    piece_y = 0
end