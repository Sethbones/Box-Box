pushableblock = {}

function pushBlockMovUpdate(dt) --smooths out the pushed block. same bugs as the player
    for i,push in ipairs(pushableblock) do
        -- push.pos_x = push.pos_x - ((push.pos_x - (push.x * box:getWidth())) * push.speed * dt)
        -- push.pos_y = push.pos_y - ((push.pos_y - (push.y * box:getHeight())) * push.speed * dt)
        push.pos_x = push.pos_x - (push.pos_x - (push.x * tilelengthx)) * (tilelengthx * 2 * averagedelta)
        push.pos_y = push.pos_y - (push.pos_y - (push.y * tilelengthy)) * (tilelengthy * 2 * averagedelta)
    end
end

function pushBlockCollision() --pushes itself the block away from the wall and the player away from itself when applicable
    for i in ipairs(pushableblock) do
        for c,col in ipairs(blockspawn) do --pushes away from wall
            if pushableblock[i].x == col.x and pushableblock[i].y == col.y then
                if pushableblock[i].pushedRight then
                    pushableblock[i].x = pushableblock[i].x - 1
                    resetblockdir()
                elseif pushableblock[i].pushedLeft then
                    pushableblock[i].x = pushableblock[i].x + 1
                    resetblockdir()
                elseif pushableblock[i].pushedUp then
                    pushableblock[i].y = pushableblock[i].y + 1
                    resetblockdir()
                elseif pushableblock[i].pushedDown then
                    pushableblock[i].y = pushableblock[i].y - 1
                    resetblockdir()
                end
            end
        end
        for o, pushOther in ipairs(pushableblock) do --pushes itself away from other blocks
            if i ~= o and o ~= i and pushOther.x == pushableblock[i].x and pushOther.y == pushableblock[i].y then --good to know that ~= in lua is != (i.e not equal) everywhere else, should've read the lua docs
                --print("block intersection between", i,"and",i)
                if pushOther.pushedRight then
                    pushOther.x = pushOther.x - 1
                    resetblockdir()
                elseif pushOther.pushedLeft then
                    pushOther.x = pushOther.x + 1
                    resetblockdir()
                elseif pushOther.pushedUp then
                    pushOther.y = pushOther.y + 1
                    resetblockdir()
                elseif pushOther.pushedDown then
                    pushOther.y = pushOther.y - 1
                    resetblockdir()
                end
            end
        end
        --ancient ass code
        -- for p,player in ipairs(playerspawn) do --pushes player away from itself
        --     if push.x == player.x and push.y == player.y then
        --         if player.movedRight then
        --             player.x = player.x - 1
        --         elseif player.movedLeft then
        --             player.x = player.x + 1
        --         elseif player.movedUp then
        --             player.y = player.y + 1
        --         elseif player.movedDown then
        --             player.y = player.y - 1
        --         end
        --     end
        -- end
    end
end
function resetblockdir()
    for i,push in ipairs(pushableblock) do --block pushing logic
        push.pushedRight = false
        push.pushedLeft = false
        push.pushedUp = false
        push.pushedDown = false
    end
end

function pushPlayerCollision() --player pushing the block collision check
    for i in ipairs(pushableblock) do --block pushing logic
        for c in ipairs(playerspawn) do
            if blockbuffer == 0 then
                if playerspawn[c].x == pushableblock[i].x and playerspawn[c].y == pushableblock[i].y then
                    print("intersection")
                    pushableblock[i].pushingplayer = playerspawn[c]
                    if playerspawn[c].moveDir == 1 then --right
                        pushableblock[i].x = pushableblock[i].x + 1
                        pushableblock[i].pushedRight = true
                        pushableblock[i].pushedLeft = false
                        pushableblock[i].pushedUp = false
                        pushableblock[i].pushedDown = false
                        pushableblock[i].pushingplayer.moveDir = 1
                        local thumpsound = BoxThump:clone()
                        thumpsound:play()
                        blockbuffer = 3
                    elseif playerspawn[c].moveDir == 2 then --left
                        pushableblock[i].x = pushableblock[i].x - 1
                        pushableblock[i].pushedRight = false
                        pushableblock[i].pushedLeft = true
                        pushableblock[i].pushedUp = false
                        pushableblock[i].pushedDown = false
                        pushableblock[i].pushingplayer.moveDir = 2
                        local thumpsound = BoxThump:clone()
                        thumpsound:play()
                        blockbuffer = 3
                    elseif playerspawn[c].moveDir == 3 then --up
                        pushableblock[i].y = pushableblock[i].y - 1
                        pushableblock[i].pushedRight = false
                        pushableblock[i].pushedLeft = false
                        pushableblock[i].pushedUp = true
                        pushableblock[i].pushedDown = false
                        pushableblock[i].pushingplayer.moveDir = 3
                        local thumpsound = BoxThump:clone()
                        thumpsound:play()
                        blockbuffer = 3
                    elseif playerspawn[c].moveDir == 4 then --down
                        pushableblock[i].y = pushableblock[i].y + 1
                        pushableblock[i].pushedRight = false
                        pushableblock[i].pushedLeft = false
                        pushableblock[i].pushedUp = false
                        pushableblock[i].pushedDown = true
                        pushableblock[i].pushingplayer.moveDir = 4
                        local thumpsound = BoxThump:clone()
                        thumpsound:play()
                        blockbuffer = 3
                    end
                end
            end
            for b,wall in ipairs(blockspawn) do
                if pushableblock[i].x == wall.x and pushableblock[i].y == wall.y then
                    if pushableblock[i].pushingplayer ~= nil and pushableblock[i].pushingplayer == playerspawn[c] then
                        print(pushableblock[i].pushingplayer)
                        print("intersection with wall with object: ", pushableblock[i].pushingplayer)
                        if pushableblock[i].pushingplayer.moveDir == 1 then
                            pushableblock[i].pushingplayer.x = pushableblock[i].pushingplayer.x - 1
                            --pushableblock[i].pushingplayer = nil
                        elseif pushableblock[i].pushingplayer.moveDir == 2 then
                            pushableblock[i].pushingplayer.x = pushableblock[i].pushingplayer.x + 1
                            --pushableblock[i].pushingplayer = nil
                        elseif pushableblock[i].pushingplayer.moveDir == 3 then
                            pushableblock[i].pushingplayer.y = pushableblock[i].pushingplayer.y + 1
                            --pushableblock[i].pushingplayer = nil
                        elseif pushableblock[i].pushingplayer.moveDir == 4 then
                            pushableblock[i].pushingplayer.y = pushableblock[i].pushingplayer.y - 1
                            --pushableblock[i].pushingplayer = nil
                        end
                    end
                    --for some odd reason its pushing the player away by player count instead of just moving the player
                    --i.e if player 1 moves a block into a wall it acts once
                    --but for some reason if player 15 or whatever moves a block into a wall it will act 15 times
                    --print("intersection with wall")
                end
            end
            for o, pushOther in ipairs(pushableblock) do --pushes player away from 2 other blocks
                if i ~= o and pushOther.x == pushableblock[i].x and pushOther.y == pushableblock[i].y then --good to know that ~= in lua is != (i.e not equal) everywhere else, should've read the lua docs
                    print("player block intersection between", i,"and",o)
                    if pushableblock[i].pushedRight then
                        playerspawn[c].x = playerspawn[c].x - 1
                    elseif pushOther.pushedLeft or pushableblock[i].pushedLeft then
                        playerspawn[c].x = playerspawn[c].x + 1
                    elseif pushableblock[i].pushedUp then
                        playerspawn[c].y = playerspawn[c].y + 1
                    elseif pushOther.pushedDown or pushableblock[i].pushedDown then
                        playerspawn[c].y = playerspawn[c].y - 1
                    end
                end
            end
        end
    end
end

function pushableBlockDraw() --draws the pushableblock to the screen
    for i,push in ipairs(pushableblock) do
        BoxDraw(push.pos_x,push.pos_y, 0,0,0, 85,52,2, 128,88,3, 167,114,4, 200,137,5)
        --love.graphics.setColor(love.math.colorFromBytes(213, 146, 5))
		--love.graphics.draw(box, push.pos_x, push.pos_y)

        --debug draw
        -- love.graphics.setColor(love.math.colorFromBytes(50, 50, 50, 150))
        -- love.graphics.rectangle("fill", push.pos_x - 16, push.pos_y + 24, tilelengthx * 3, tilelengthy * 2)
        -- love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
        -- love.graphics.print("gridX:"..push.x, push.pos_x - 16, push.pos_y + 24, 0,0.75,0.75)
        -- love.graphics.print("gridY:"..push.y, push.pos_x - 16, push.pos_y + 32, 0,0.75,0.75)
        -- love.graphics.print("pushedRight:"..tostring(push.pushedRight), push.pos_x - 16, push.pos_y + 40, 0,0.75,0.75)
        -- love.graphics.print("pushedLeft:"..tostring(push.pushedLeft), push.pos_x - 16, push.pos_y + 48, 0,0.75,0.75)
        -- love.graphics.print("pushedUp:"..tostring(push.pushedUp), push.pos_x - 16, push.pos_y + 56, 0,0.75,0.75)
        -- love.graphics.print("pushedDown:"..tostring(push.pushedDown), push.pos_x - 16, push.pos_y + 64, 0,0.75,0.75)
    end
end