floorspawn = {}

function floorDraw() --draws the floor to the screen
    for i,floor in ipairs(floorspawn) do
        BoxDraw(floor.x,floor.y, 129,129,129, 155,155,155, 194,194,194, 233,233,233, 255,255,255)
        --love.graphics.setColor(1,1,1)
        --love.graphics.draw(box, floor.x, floor.y )
    end
end