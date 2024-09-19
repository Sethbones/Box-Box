function leveldelete() --deletes the entire scene
    --leveldata = love.image.newImageData("testsmall.png")
    -- level = love.graphics.newImage(leveldata) 
    -- levelwidth = level:getWidth() --width in pixels of the level image
    -- levelheight = level:getHeight() --height in pixels of the level image
    -- boxdata = love.image.newImageData("box.png")
    -- box = love.graphics.newImage(boxdata)
    -- tilelengthx, tilelengthy = box:getWidth(),box:getHeight()
    -- draw_screen = true
    --maid64(levelwidth * tilelengthx, levelheight * tilelengthy)
    if lvlnum ~= 25 then
        for i in ipairs(floorspawn) do
            floorspawn[i] = nil
        end
        for i in ipairs(playerspawn) do
            playerspawn[i] = nil
        end
        for i in ipairs(blockspawn) do
            blockspawn[i] = nil
        end
        for i in ipairs(pushableblock) do
            pushableblock[i] = nil
        end
        for i in ipairs(blockendspawn) do
            blockendspawn[i] = nil
        end
        print("loading next level 2")
    end
end

function levelRestart()
    leveldelete()
    levelgen()
end

function nextlevel()
    if lvlnum ~= 25 then
        leveldelete()
        lvlnum = lvlnum + 1
        leveldata = love.image.newImageData(lvltype..lvlnum..lvlfiletype)
        level = love.graphics.newImage(leveldata)
        levelwidth = level:getWidth() --width in pixels of the level image
        levelheight = level:getHeight()
        levelgen() 
    end
end

function levelgen() -- level generation code, takes rgb values from an inputted image an spawns accordingly, flexible
    maid64(levelwidth * tilelengthx, levelheight * tilelengthy)
    -- maid64(levelwidth * tilelengthx, levelheight * tilelengthy)
    -- maid_draw()
    --maid64(levelwidth * tilelengthx, levelheight * tilelengthy)
    for x = 0, levelwidth - 1, 1 do --basically since the draw command draws every single frame  
        for y = 0, levelheight - 1, 1 do
            --print(x,y)
            local r, g, b = love.math.colorToBytes(leveldata:getPixel(x,y))
            table.insert(floorspawn, {x = x * tilelengthx, y = y * tilelengthy})
            --the following part currently spawns 148 boxes (for each line) stacked on top of each other for now
            --note this entire thing might just get removed and a puzzle will use the lack of outer walls as a gimmick
            --or here's a better idea calculate it based on out of bounds x grid position and y grid position
            -- table.insert(blockspawn, {x = tilelengthx * levelwidth, y = y * tilelengthy }) -- spawn walls on right side
            -- table.insert(blockspawn, {x = -tilelengthx, y = y * tilelengthy }) -- spawn walls on left side
            -- table.insert(blockspawn, {x = x * tilelengthx, y = tilelengthy * levelheight }) -- spawn walls on bottom side
            -- table.insert(blockspawn, {x = x * tilelengthx, y = -tilelengthy }) -- spawn walls on top side
            if r == 128 and g == 128 and b == 128 then
                table.insert(blockspawn, {x = x, y = y, pos_x = x * tilelengthx, pos_y = y * tilelengthy})
            elseif r == 140 and g == 80 and b == 0 then
                table.insert(playerspawn, {x = x  , y = y, pos_x = x * tilelengthx, pos_y = y * tilelengthy, speed = 64, movedRight = false, movedLeft = false, movedUp = false, movedDown = false, moveDir = 0})
            elseif r == 255 and g == 190 and b == 0 then
                table.insert(pushableblock, {x = x, y = y, pos_x = x * tilelengthx , pos_y = y * tilelengthy, pushedRight = false, pushedLeft = false, pushedUp = false, pushedDown = false, speed = 64, pushingplayer = nil})
            elseif r == 10 and g == 255 and b == 0  then
                table.insert(blockendspawn, {x = x, y = y, pos_x = x * tilelengthx , pos_y = y * tilelengthy, occupied = false, occupyingBlock = nil})
            end
            if x == levelwidth - 1 and y == levelheight - 1 then
                print("level drawn yo")
                break
            end
        end
    end
    for i,goal in ipairs(blockendspawn) do
        goal.occupied = false
    end
    if lvlnum == 1 then
        lvldescription = "welcome to BoxBox"
    elseif lvlnum == 2 then
        lvldescription = "there can be more then one"
    elseif lvlnum == 3 then
        lvldescription = "Reverse"
    elseif lvlnum == 4 then
        lvldescription = "crossroads"
    elseif lvlnum == 5 then
        lvldescription = "the key to success"
    elseif lvlnum == 6 then
        lvldescription = "crowded"
    elseif lvlnum == 7 then
        lvldescription = "Straight Line"
    elseif lvlnum == 8 then
        lvldescription = "mirrored realms"
    elseif lvlnum == 9 then
        lvldescription = "aim and shoot"
    elseif lvlnum == 10 then
        lvldescription = "BoxBoxBoxBox"
    elseif lvlnum == 11 then
        lvldescription = "Spiral Maze"
    elseif lvlnum == 12 then
        lvldescription = "take a second"
    elseif lvlnum == 13 then
        lvldescription = "take a minute"
    elseif lvlnum == 14 then
        lvldescription = "hivemind"
    elseif lvlnum == 15 then
        lvldescription = "a breather"
    elseif lvlnum == 16 then
        lvldescription = "Count Your Steps"
    elseif lvlnum == 17 then
        lvldescription = "confusion in three"
    elseif lvlnum == 18 then
        lvldescription = "mind your position"
    elseif lvlnum == 19 then
        lvldescription = "piano lesson"
    elseif lvlnum == 20 then
        lvldescription = "Chasm"
    elseif lvlnum == 21 then
        lvldescription = "Staring at a screen"
    elseif lvlnum == 22 then
        lvldescription = "obligatory phone level"
    elseif lvlnum == 23 then
        lvldescription = "once more into darkness"
    elseif lvlnum == 24 then
        lvldescription = "Quadruple Mirror"
    elseif lvlnum == 25 then
        lvldescription = "thanks for playing"
    end
end