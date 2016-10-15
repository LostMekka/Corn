require "helper"

local G = love.graphics


love.mouse.setVisible(false)
G.setDefaultFilter("nearest", "nearest")
G.setBackgroundColor(0, 0, 0, 0)


W = 640
H = 400
canvas = G.newCanvas(W, H)
love.window.setMode(W, H, {})


function love.update()

end

function love.draw()
	G.setCanvas(canvas)


	-- render your stuff here

	G.clear(10, 10, 10)
	G.circle("line", 320, 200, 200)







	-- draw canvas independent of resolution
	G.origin()
	G.scale(G.getWidth() / W, G.getHeight() / H)
	G.setCanvas()
	G.draw(canvas)
end

function love.keypressed(key)


end
