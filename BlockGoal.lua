blockendspawn = {} -- preferred it would have a state bool for checking if its occupied or not, i.e if occupied is false then color block red else green

function occupationCheck() --checks if the tile has a block inside it and also if all blocks of said type are occupied
    local all_occupied = true
    for e,endp in ipairs(blockendspawn) do --block intersection doodad for the pushableblock
        for a,push in ipairs(pushableblock) do
            if blockendspawn[e].x == pushableblock[a].x and blockendspawn[e].y == pushableblock[a].y then
                if blockendspawn[e].occupyingBlock == nil then
                    blockendspawn[e].occupied = true
                    blockendspawn[e].occupyingBlock = pushableblock[a]
                    local successSound = Blockpoint:clone()
                    successSound:play()
                    --print(blockendspawn[e].occupied)
                    --print("found a block")
                end
                --break
            else
                if blockendspawn[e].occupyingBlock == pushableblock[a] and blockendspawn[e].x ~= pushableblock[a].x or blockendspawn[e].occupyingBlock == pushableblock[a] and blockendspawn[e].y ~= pushableblock[a].y then
                    blockendspawn[e].occupied = false
                    blockendspawn[e].occupyingBlock = nil
                    --print(blockendspawn[e].occupied)
                    --print("no block")
                end
                --break
            end
        end
        --print(blockendspawn[e].occupied)
    if endp.occupied ~= true then
        all_occupied = false
        --break
        end
    end

    if all_occupied then --play level end thing
        print("all occupied")
        nextlevel() --this is temporary untill menu is actually finished
    end
end

function blockGoalDraw() --draws the blockgoal
    for i in ipairs(blockendspawn) do
        if blockendspawn[i].occupied == false then
            love.graphics.setColor(love.math.colorFromBytes(255, 10, 0))
		    love.graphics.draw(box, blockendspawn[i].pos_x, blockendspawn[i].pos_y)
            --print("drawing red")
        elseif blockendspawn[i].occupied == true then
            love.graphics.setColor(love.math.colorFromBytes(10, 255, 0))
		    love.graphics.draw(box, blockendspawn[i].pos_x, blockendspawn[i].pos_y)
            --print("drawing green")
        end
    end
end