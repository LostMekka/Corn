local G = love.graphics
local D = love.keyboard.isDown



-- init technical stuff
W = 400
H = 240
G.setDefaultFilter("nearest", "nearest")
canvas = G.newCanvas(W, H)
love.window.setMode(W, H, {fullscreen = true})
love.mouse.setVisible(false)



-- require stuff
require "helper"
require "map"
require "hero"




Camera = Object:new()
function Camera:init(x, y)
	self.x = x
	self.y = y
end



-- instantiate stuff
map = Map("media/map-01.json")
hero = Hero(map.objects.player.x, map.objects.player.y)
camera = Camera(map.objects.player.x, map.objects.player.y)




function love.update()
	-- move stuff around
	camera.x = camera.x + (bool[D"right"] - bool[D"left"]) * 4
	camera.y = camera.y + (bool[D"down"]  - bool[D"up"]) * 4

	hero.update()

	-- update entities
	local time = love.timer.getAverageDelta()
end


function love.draw()
	G.setCanvas(canvas)
	G.clear(0, 0, 0)


	-- move camera
	G.translate(-camera.x + W / 2, -camera.y + H / 2)

	-- render your stuff here


	hero:draw()


	map:draw({
		x = camera.x - W / 2,
		y = camera.y - H / 2,
		w = W,
		h = H,
	})



	-- draw canvas independent of resolution
	G.origin()
	G.scale(G.getWidth() / W, G.getHeight() / H)
	G.setCanvas()
	G.draw(canvas)
end

