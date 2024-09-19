--to do list reminders:
--the main should be nothing then an init file
--i.e this should not be the file with all the main functions
--but just for all the ones the game calls for like load update keypressed and mouspressed
--everything should be moved to its own file could game.lua
--also a good reminder to create a globalvars.lua file to store most of this junk
leveldata = love.image.newImageData("level1.png")
level = love.graphics.newImage(leveldata)
levelwidth = level:getWidth() --width in pixels of the level image
levelheight = level:getHeight() --height in pixels of the level image
boxdata = love.image.newImageData("box.png")
box = love.graphics.newImage(boxdata)
tilelengthx, tilelengthy = box:getWidth(),box:getHeight()
--local blockcollision = {image=box, x = 0, y = 0}
local levelsize = 1 --currently not sure what to do with this, was thinking of just changing this to a resolution switch thing. that or a local cameraType that checks if it should follow the player or not depending on the level 
draw_screen = true

if love.system.getOS() == "Windows" then
    ---@diagnostic disable-next-line: assign-type-mismatch
    love.window.setMode(960, 540, {vsync = 1, resizable = true}) --currently being used for testing
elseif love.system.getOS() == "Android" then
    ---@diagnostic disable-next-line: assign-type-mismatch
    love.window.setMode(960, 540, {vsync = 1, resizable = false, usedpiscale = false })
---@diagnostic disable-next-line: assign-type-mismatch
else love.window.setMode(960, 540, {vsync = 1, resizable = true})
end
tempPauseGraphic = love.graphics.newImage("PauseTemp.png")
tempRestartGraphic = love.graphics.newImage("ResartTemp.png")
RestartButtonGraphic = love.graphics.newImage("RestartButton.png")
require "player"
require "Wall"
require "levelController"
require "PushableBlock"
require "Floor"
require "BlockGoal"
require "ScreenScaler"
require "subload"
require "SoundEffects/Sounds"
mousePressedX = 0
mouseReleasedX = 0
mousePressedY = 0
mouseReleasedY = 0
mouseStrength = 150
printdelta = 0
restartButtonX = 0
restartButtonY = 0
basescaleresx = 960
basescaleresy = 540
lvlpath = nil
lvltype = "level"
lvlnum = 1
lvlfiletype = ".png"
lvldescription = "welcome to BoxBox"
mouseDeadzone = 48
xDeadZone = math.ceil(love.graphics.getWidth() / mouseDeadzone)
yDeadZone = math.ceil(love.graphics.getHeight() / mouseDeadzone)
movebuffer = 1 --well this is a problem, because of the way i have movement set up this is basically required to avoid accidental diagonal movement which could clip the player inside a wall
blockbuffer = 3 --an attempt is being made, because of some why the fucks the block could be pushed onto a block that hasn't been moved but if its moved into a block that has moved it breaks 
averagedelta = 0.005 --i'm a programmer i swear
menustate = 3 -- 0 - intro, 1 - menu, 2 - level select, 3 - game, 4 - victory, 11 - options, 12 - level editor, 13 - level editor preview
logo = love.graphics.newImage("ShitLogo.png")
timetilnextscene = 0
KeysPressed = {}
DebugMode = false
font = love.graphics.newImageFont("CustomFontSmall.png", " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789/:!@#$%^&*()-+[]{}", -2)


BoxResource = love.graphics.newImage("Box_parts.png")
BoxAsset = {
    BoxSpriteA = love.graphics.newQuad(0,0,BoxResource:getWidth()/5,BoxResource:getHeight(),BoxResource:getWidth(), BoxResource:getHeight()),
    BoxSpriteB = love.graphics.newQuad(BoxResource:getWidth()/5,0,BoxResource:getWidth()/5,BoxResource:getHeight(),BoxResource:getWidth(), BoxResource:getHeight()),
    BoxSpriteC = love.graphics.newQuad(BoxResource:getWidth()/5 * 2,0,BoxResource:getWidth()/5,BoxResource:getHeight(),BoxResource:getWidth(), BoxResource:getHeight()),
    BoxSpriteD = love.graphics.newQuad(BoxResource:getWidth()/5 * 3,0,BoxResource:getWidth()/5,BoxResource:getHeight(),BoxResource:getWidth(), BoxResource:getHeight()),
    BoxSpriteE = love.graphics.newQuad(BoxResource:getWidth()/5 * 4,0,BoxResource:getWidth()/5,BoxResource:getHeight(),BoxResource:getWidth(), BoxResource:getHeight())
}

--restartButton = {xpos = love.graphics.getWidth() - 96 * 2 - 1, ypos = 15}

local console = require "console"
--love.keyboard.setKeyRepeat(true) --might need looking into before keeping

-- -- -- local rectangle = {
-- -- --   x = 100, y = 100,
-- -- --   width = 100, height = 100,
-- -- --   r = 1, g = 1, b = 1
-- -- -- }
-- -- -- console.ENV.rectangle = rectangle

function love.load()
    InitSounds()
    font:setFilter("nearest","nearest",0)
    Fader()
    --Fader.transitionactive = true
    Menustatecheck()
    -- print(love.graphics.getWidth())
    -- print(love.graphics.getHeight())
    print(levelwidth * tilelengthx, "and", levelheight * tilelengthy) -- 480 264
    --maid64(levelwidth * tilelengthx, levelheight * tilelengthy)
    love.window.setTitle("BoxBox: a Puzzling Box Pushing Box Game ") --i swear i can make better names
    love.window.setIcon(boxdata) --you know would be nice if you could set this things
    --leveldata = love.image.newImageData("level2.png")
    --love.window.setMode(480, 270) -- the actual resolution of the game
    --love.window.setMode(960, 540, {vsync = true, resizable = true}) --currently being used for testing
    --love.window.setMode(tilelengthx * levelwidth, tilelengthy * levelheight) -- might be what i end up going for with a container that scales it up nicely to a modern resolution
    --maid64(levelwidth * tilelengthx, levelheight * tilelengthy)
    --maid64(levelwidth * tilelengthx, levelheight * tilelengthy)
    if lvlpath == nil then 
        print(lvltype..lvlnum..lvlfiletype)
        leveldata = love.image.newImageData(lvltype..lvlnum..lvlfiletype)
        level = love.graphics.newImage(leveldata)
        levelwidth = level:getWidth() --width in pixels of the level image
        levelheight = level:getHeight() --height in pixels of the level image
    else
        print(lvlpath)
        leveldata = love.image.newImageData(lvlpath)
        level = love.graphics.newImage(leveldata)
        levelwidth = level:getWidth() --width in pixels of the level image
        levelheight = level:getHeight() --height in pixels of the level image
    end
    levelgen()
end

function love.update(dt)
    -- if timetilnextscene > 0 then
    --     timetilnextscene = timetilnextscene - dt
    -- else
    --     timetilnextscene = 0
    --     sceneswap()
    -- end
    if Fader.transitionactive == false and menustate == 0 then
        SceneSwap()
    end
    if love.timer.getAverageDelta() <= 0.5 then
        averagedelta = love.timer.getAverageDelta()
    end
    if movebuffer > 0 then
        movebuffer = movebuffer - 1
    else movebuffer = 0
    end
    if blockbuffer > 0 then
        blockbuffer = blockbuffer - 1
    else blockbuffer = 0
    end
    if blockbuffer == 0 then
        resetblockdir()
    end
    restartButtonX = love.graphics.getWidth() - love.graphics.getWidth()/10
    restartButtonY = 0
    playerMovUpdate(dt) --updates player movement accordingly
    pushBlockMovUpdate(dt)
    occupationCheck()
    pushBlockCollision()
    printdelta = dt
    wallcollision()
    pushPlayerCollision()
end

function love.keypressed(key, scancode, isrepeat)
    KeysPressed[key] = true
    playermove(key)
    --print(key)
    if key == "1" then
        --os.execute('explorer /select,"C:\\path\\to\\file"') --meme button
        --this needs way more work then i initially thought
        --so basically to spawn a file explorer to load a level i need
        --wxLua for windows
        --cocoa for mac which i will probably not do since i don't have a mac
        --GTK for linux
        --so uh yeah fuck
        --maybe post release but for right now too much work
    end
    if key == "2" then
        leveldelete()
    end
    if key == "3" then
        -- for i,v in ipairs(blockspawn) do
        --     print("block", i, "block spawned at:", v.x, "and:", v.y)
        -- end
        for i,v in ipairs(blockendspawn) do
            print("endspawn", i,"is currently:", v.occupied)
        end
    end
    if key == "4" then
        print("activating Fader")
        StartFader()
    end
    if key == "r" then
        levelRestart()
    end

    --pushPlayerCollision()
    console.keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key)
    KeysPressed[key] = nil
end

function love.draw()
    love.graphics.setFont(font)
    --love.graphics.setDefaultFilter("nearest",'nearest',0)
    maid_draw()
    if menustate == 0 then
        love.graphics.setColor(love.math.colorFromBytes(255,255,255,255))
        love.graphics.draw(logo)
    elseif menustate == 3 then
        if draw_screen then
            --maid64(levelwidth * tilelengthx, levelheight * tilelengthy)
            
        end
        --love.graphics.printf("Level "..tostring(lvlnum).." "..lvldescription, love.graphics.getWidth()/2 - love.graphics.getWidth()/4,0,40, "center",0, (love.graphics.getWidth() / basescaleresx) * 5, (love.graphics.getHeight() / basescaleresy) * 5)
        love.graphics.print("Level "..tostring(lvlnum)..":"..lvldescription, 0, 0, 0, (love.graphics.getWidth() / basescaleresx) * 3, (love.graphics.getHeight() / basescaleresy) * 3)
        --love.graphics.print("description", love.graphics.getWidth()/2 , 16, 0, love.graphics.getWidth() / basescaleresx, love.graphics.getHeight() / basescaleresy)
        if DebugMode then
            love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
            love.graphics.print("texture memory stats:"..love.graphics.getStats().texturememory / 1024 / 1024, 10, 20)
            love.graphics.print("Current Delta:"..printdelta, 10, 30)
            love.graphics.print("Current Average Delta:"..averagedelta, 10, 40)
            love.graphics.print("current system:".. love.system.getOS( ), 10 , 50)
            love.graphics.print(tostring(mousePressedX - mouseReleasedX),10,100)
            love.graphics.print(tostring(mousePressedY - mouseReleasedY),10,110)
            love.graphics.print(tostring(math.abs(mousePressedX - mouseReleasedX)),10,120)
            love.graphics.print(tostring(math.abs(mousePressedY - mouseReleasedY)),10,130)
        end
        love.graphics.setColor(1,1,1)
        --love.graphics.draw(tempPauseGraphic, love.graphics.getWidth() ,love.graphics.getHeight())
        --love.graphics.draw(tempPauseGraphic, love.graphics.getWidth() - love.graphics.getWidth()/10 ,0,0, love.graphics.getWidth() / basescaleresx, love.graphics.getHeight() / basescaleresy)
        --love.graphics.draw(tempRestartGraphic, restartButtonX ,restartButtonY, 0, love.graphics.getWidth() / basescaleresx, love.graphics.getHeight() / basescaleresy)
        love.graphics.draw(RestartButtonGraphic, love.graphics.getWidth() - love.graphics.getWidth()/10 ,restartButtonY, 0, love.graphics.getWidth() / basescaleresx, love.graphics.getHeight() / basescaleresy)
        -- for i,player in ipairs(playerspawn) do
        --     love.graphics.print(tostring(player.moveDir), 10, 60)
        --     -- love.graphics.print(tostring(player.movedLeft), 10, 60)
        --     -- love.graphics.print(tostring(player.movedUp), 10, 70)
        --     -- love.graphics.print(tostring(player.movedDown), 10, 80)
        --     love.graphics.print(tostring(player.x), 10, 90)
        -- end
        
    end
    --maid64(levelwidth * tilelengthx, levelheight * tilelengthy)
    -- floorDraw()
    -- wallDraw()
    -- pushableBlockDraw()
    -- blockGoalDraw()
    -- playerDraw()
    Fader_draw()
    console.draw()
end

function love.textinput(text)
    console.textinput(text)
end

function maid64_draw()
    if menustate == 0 then  
    elseif menustate == 3 then
        --reminder that the character can still move in the background
        floorDraw()
        wallDraw()
        pushableBlockDraw()
        blockGoalDraw()
        playerDraw()
        love.graphics.setColor(1,1,1)
    end
end

function love.mousepressed( x, y, button, istouch, presses )
    mousePressedX = x
    mousePressedY = y
end

function love.mousereleased( x, y, button, istouch, presses )
    --pushPlayerCollision()
    mouseReleasedX = x
    mouseReleasedY = y
    -- print("mouseX",mousePressedX - mouseReleasedX)
    -- print("mouseY",mousePressedY - mouseReleasedY)
    -- this thing is kinda funky and complex and like it could really be cleaned up if needed but i'm hella proud i wrote this entire thing by myself
    for i,player in ipairs(playerspawn) do
        if mousePressedX - mouseReleasedX > 0 and mousePressedY - mouseReleasedY > 0 then
            print("top left")
            if math.abs(mousePressedX - mouseReleasedX) > xDeadZone and math.abs(mousePressedX - mouseReleasedX) > math.abs(mousePressedY - mouseReleasedY) then
                print("move left")
                moveLeft()
            elseif math.abs(mousePressedY - mouseReleasedY) > yDeadZone then
                print("move up")
                moveUp()
            end
        elseif mousePressedX - mouseReleasedX < 0 and mousePressedY - mouseReleasedY > 0 then
            print("top right")
            if math.abs(mousePressedX - mouseReleasedX) > xDeadZone and math.abs(mousePressedX - mouseReleasedX) > math.abs(mousePressedY - mouseReleasedY) then
                print("move right")
                moveRight()
            elseif math.abs(mousePressedY - mouseReleasedY) > yDeadZone then
                print ("move up")
                moveUp()
            end
        elseif mousePressedX - mouseReleasedX > 0 and mousePressedY - mouseReleasedY < 0 then
            print("bottom left")
            if math.abs(mousePressedX - mouseReleasedX) > xDeadZone and math.abs(mousePressedX - mouseReleasedX) > math.abs(mousePressedY - mouseReleasedY) then
                print("move left")
                moveLeft()
            elseif math.abs(mousePressedY - mouseReleasedY) > yDeadZone then
                print ("move down")
               moveDown()
            end
        elseif mousePressedX - mouseReleasedX < 0 and mousePressedY - mouseReleasedY < 0 then
            print("bottom right")
            if math.abs(mousePressedX - mouseReleasedX) > xDeadZone and math.abs(mousePressedX - mouseReleasedX) > math.abs(mousePressedY - mouseReleasedY) then
                print("move right")
                moveRight()
            elseif math.abs(mousePressedY - mouseReleasedY) > yDeadZone then
                print ("move down")
                moveDown()
            end
        end
        -- if mousePressedX - mouseReleasedX <= -mouseStrength and mousePressedY - mouseReleasedY >= -mouseStrength and mousePressedY - mouseReleasedY <= mouseStrength then
        --     player.x = player.x + 1 -- right
        --     player.movedRight = true
        --     player.movedLeft = false
        --     player.movedUp = false
        --     player.movedDown = false
        -- elseif mousePressedX - mouseReleasedX >= mouseStrength and mousePressedY - mouseReleasedY >= -mouseStrength and mousePressedY - mouseReleasedY <= mouseStrength then
        --     player.x = player.x - 1 -- left
        --     player.movedRight = false
        --     player.movedLeft = true
        --     player.movedUp = false
        --     player.movedDown = false
        -- elseif mousePressedY - mouseReleasedY >= mouseStrength then
        --     player.y = player.y - 1 --up
        --     player.movedRight = false
        --     player.movedLeft = false
        --     player.movedUp = true
        --     player.movedDown = false
        -- elseif mousePressedY - mouseReleasedY <= -mouseStrength then
        --     player.y = player.y + 1 --down
        --     player.movedRight = false
        --     player.movedLeft = false
        --     player.movedUp = false
        --     player.movedDown = true
        -- end
    end

    if mouseReleasedX >= restartButtonX and mouseReleasedY >= restartButtonY and mouseReleasedX <= restartButtonX + tempRestartGraphic:getWidth() and mouseReleasedY <= restartButtonY + tempRestartGraphic:getHeight() then
        --wierdly enough this works fine on windows but the offsets break completely when it comes to mobile
        --love2d mobile moment, guess it wont be a mobile game
        levelRestart()
    end
end
-- function love.touchpressed( id, x, y, dx, dy, pressure )
        --this function is terrible
        --its essentially mousepressed but only active on a phone
        --print(x)
-- end

-- for i,player in ipairs(playerspawn) do
--     player.x = player.x + 1
-- end

function Debug()
    if DebugMode == false then
        DebugMode = true
    else
        DebugMode = false
    end
end