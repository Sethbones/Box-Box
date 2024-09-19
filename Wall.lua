blockspawn = {}

--there's basically nothing here, cause like everything is hendled by each of the objects

function wallDraw()
    for i,col in ipairs(blockspawn) do
        BoxDraw(col.pos_x,col.pos_y, 0,0,0, 0,0,0, 15,15,15, 25,25,25, 35,35,35)
        --love.graphics.setColor(love.math.colorFromBytes(40, 40, 40))
		--love.graphics.draw(box, col.pos_x, col.pos_y)
	end
end