playerspawn = {}   -- x pos, y pos, can_move, movex,movey
--moveDir integers
--right = 1
--left = 2
--up = 3
--down = 4
function playerMovUpdate(dt) -- player movement smoothing, jittes the fuck out on fps change, so uh.. uh oh. the solution, stop using delta, delta is not good for this script
    for i,player in ipairs(playerspawn) do
        --reminder to put an option in an eventual settings menu to enable and disable smooth movement
        player.pos_x = player.pos_x - (player.pos_x - (player.x * tilelengthx)) * (tilelengthx * 2 * averagedelta)
        player.pos_y = player.pos_y - (player.pos_y - (player.y * tilelengthy)) * (tilelengthy * 2 * averagedelta)
        -- if player.moveDir == 1 then --right
        --     player.x = player.x + 1
        --     player.moveDir = 0
        -- elseif player.moveDir == 2 then --left
        --     player.x = player.x - 1
        --     player.moveDir = 0
        -- elseif player.moveDir == 3 then --up
        --     player.y = player.y - 1
        --     player.moveDir = 0
        -- elseif player.moveDir == 4 then --down
        --     player.y = player.y + 1
        --     player.moveDir = 0
        -- end
        -- player.move_dir.right = 1
        -- player.move_dir.left = 2
        -- player.move_dir.up = 3
        -- player.move_dir.down = 4
        -- player.pos_x = player.pos_x - ((player.pos_x - (player.x * box:getWidth())))
        -- player.pos_y = player.pos_y - ((player.pos_y - (player.y * box:getHeight())))--new player movement collision
        -- for w,wall in ipairs(blockspawn) do
        --     if player.moveDir == 1 and player.x + 1 == wall.x and player.y == wall.y then
        --         print("wall to the right")
        --         player.moveDir = 0
        --     end
        --     if player.moveDir == 1 and player.x + 1 ~= wall.x and player.y ~= wall.y then
        --         print("no wall to the right")
        --         player.moveDir = 0
        --         player.x = player.x + 1
        --     end
        --     -- if player.moveDir == 1 then
        --     --     if player.x + 1 == wall.x and player.y == wall.y then
        --     --         print("cannot move here")
        --     --         player.moveDir = 0
        --     --     else
        --     --         print("can move here")
        --     --         player.x = player.x + 1
        --     --         player.moveDir = 0
        --     --     end
        --     if player.moveDir == 2 then
        --         player.x = player.x - 1
        --         player.moveDir = 0
        --     elseif player.moveDir == 3 then
        --         player.y = player.y - 1
        --         player.moveDir = 0
        --     elseif player.moveDir == 4 then
        --         player.y = player.y + 1
        --         player.moveDir = 0
        --     end
        -- end
    end
end

function playermove(key) --controls player movement for keyboard button presses
    for i in ipairs(playerspawn) do
        --print(player.x)
        if key == "d" or key == "right" then --right
            moveRight()
        elseif key == "a" or key == "left" then --left
            moveLeft()
        elseif key == "w" or key == "up" then --up
            moveUp()
        elseif key == "s" or key == "down" then --down
            moveDown()
        end
    end
end

function moveRight()
    if movebuffer <= 0 then
        for i,player in ipairs(playerspawn) do
            player.moveDir = 1
            playerspawn[i].x = player.x + 1
            local movesound = MoveWoosh:clone()
            movesound:play()
        end  
    end
    movebuffer = 1
end

function moveLeft()
    if movebuffer <= 0 then
        for i,player in ipairs(playerspawn) do
            player.moveDir = 2
            player.x = player.x - 1
            local movesound = MoveWoosh:clone()
            movesound:play()
        end  
    end
    movebuffer = 1
end

function moveUp()
    if movebuffer <= 0 then
        for i,player in ipairs(playerspawn) do
            player.moveDir = 3
            player.y = player.y - 1
            local movesound = MoveWoosh:clone()
            movesound:play()
        end
    end
    movebuffer = 1
end

function moveDown()
    if movebuffer <= 0 then
        for i,player in ipairs(playerspawn) do
            player.moveDir = 4
            player.y = player.y + 1
            local movesound = MoveWoosh:clone()
            movesound:play()
        end
    end
    movebuffer = 1
end

function resetdir()
    for i,player in ipairs(playerspawn) do
        player.moveDir = 0
    end
end

function wallcollision() --pushes the player away from the wall if it detects where it was going
    for c,player in ipairs(playerspawn) do --pushback collision cleaned up and simplified edition
        for i,col in ipairs(blockspawn) do
            if playerspawn[c].x == blockspawn[i].x and playerspawn[c].y == blockspawn[i].y then
                --print("intersection occurred")
                if playerspawn[c].moveDir == 1 then --right
                    playerspawn[c].x = playerspawn[c].x - 1
                    playerspawn[c].moveDir = 0
                    local wallsound = WallBlock:clone()
                    wallsound:play()
                elseif player.moveDir == 2 then --left
                    playerspawn[c].x = playerspawn[c].x + 1
                    playerspawn[c].moveDir = 0
                    local wallsound = WallBlock:clone()
                    wallsound:play()
                elseif player.moveDir == 3 then --up
                    playerspawn[c].y = playerspawn[c].y + 1
                    playerspawn[c].moveDir = 0
                    local wallsound = WallBlock:clone()
                    wallsound:play()
                elseif player.moveDir == 4 then --down
                    playerspawn[c].y = playerspawn[c].y - 1
                    playerspawn[c].moveDir = 0
                    local wallsound = WallBlock:clone()
                    wallsound:play()
                end
            end
        end
    end
end

-- function playercolcheck() -- well this didn't work
--     for i,player in ipairs(playerspawn) do
--         for i,wall in ipairs (blockspawn) do
--             if player.moveDir == 1 and player.x + 1 == wall.x and player.y == wall.y then
--                 print("wall next to you")
--                 break
--             else
--                 print("valid move")
--                 player.x = player.x + 1
--                 break
--             end
--         end
--     end
-- end

function playerDraw() --draws the player to the screen
    for i,v in ipairs(playerspawn) do --love.graphics.setColor(love.math.colorFromBytes(145, 88, 28))
        BoxDraw(v.pos_x,v.pos_y, 0,0,0, 30,17,9, 59,30,10, 95,51,10, 136,81,23)
        --love.graphics.setColor(love.math.colorFromBytes(145, 88, 28))
		--love.graphics.draw(box, v.pos_x, v.pos_y)
        -- love.graphics.setColor(love.math.colorFromBytes(0, 0, 0))
        -- love.graphics.draw(BoxAsset.BoxResource, BoxAsset.BoxSpriteA, v.pos_x, v.pos_y)
        -- love.graphics.setColor(love.math.colorFromBytes(30, 17, 9))
        -- love.graphics.draw(BoxAsset.BoxResource, BoxAsset.BoxSpriteB, v.pos_x, v.pos_y)
        -- love.graphics.setColor(love.math.colorFromBytes(59, 30, 10))
        -- love.graphics.draw(BoxAsset.BoxResource, BoxAsset.BoxSpriteC, v.pos_x, v.pos_y)
        -- love.graphics.setColor(love.math.colorFromBytes(98, 51, 10))
        -- love.graphics.draw(BoxAsset.BoxResource, BoxAsset.BoxSpriteD, v.pos_x, v.pos_y)
        -- love.graphics.setColor(love.math.colorFromBytes(136, 81, 23))
        -- love.graphics.draw(BoxAsset.BoxResource, BoxAsset.BoxSpriteE, v.pos_x, v.pos_y)
        -- for i,wall in ipairs(blockspawn) do
        --     if v.x + 1 == wall.x and v.y == wall.y then
        --         love.graphics.rectangle("fill", (v.x + 1) * tilelengthx, v.y * tilelengthy, tilelengthx, tilelengthy)
        --     end
        --     if v.x - 1 == wall.x and v.y == wall.y then
        --         love.graphics.rectangle("fill", (v.x - 1) * tilelengthx, v.y * tilelengthy, tilelengthx, tilelengthy)
        --     end
        --     if v.x == wall.x and v.y - 1 == wall.y then
        --         love.graphics.rectangle("fill", v.x * tilelengthx, (v.y - 1) * tilelengthy, tilelengthx, tilelengthy)
        --     end
        --     if v.x == wall.x and v.y + 1 == wall.y then
        --         love.graphics.rectangle("fill", v.x * tilelengthx, (v.y + 1) * tilelengthy, tilelengthx, tilelengthy)
        --     end
        -- end
    end
end