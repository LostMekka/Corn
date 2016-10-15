local G = love.graphics
local D = love.keyboard.isDown



-- init technical stuff
W = 400
H = 240
G.setDefaultFilter("nearest", "nearest")
canvas = G.newCanvas(W, H)
love.window.setMode(W, H, {resizable = true})
love.mouse.setVisible(false)



-- require stuff
require "helper"
require "entity"
require "hero"
require "map"




Camera = Object:new()
function Camera:init(x, y)
	self.x = x
	self.y = y
end



-- instantiate stuff
map = Map("media/map-01.json")
hero = map.objects.player
camera = Camera(map.objects.player.x, map.objects.player.y)




function love.update()
	-- move stuff around

	hero:update()

--	camera.x = camera.x + (bool[D"right"] - bool[D"left"]) * 4
--	camera.y = camera.y + (bool[D"down"]  - bool[D"up"]) * 4
	camera.x = hero.x
	camera.y = hero.y

	-- update entities
	local time = love.timer.getAverageDelta()
end


function love.draw()
	G.setCanvas(canvas)
	G.clear(0, 0, 0)


	-- move camera
	G.translate(-camera.x + W / 2, -camera.y + H / 2)

	-- render your stuff here


	map:draw({
		x = camera.x - W / 2,
		y = camera.y - H / 2,
		w = W,
		h = H,
	})

	hero:draw()


	-- draw canvas independent of resolution
	local w = G.getWidth()
	local h = G.getHeight()
	G.origin()
	if w / h < W / H then
		G.translate(0, (h - w / W * H) * 0.5)
		G.scale(w / W, w / W)
	else
		G.translate((w - h / H * W) * 0.5, 0)
		G.scale(h / H, h / H)
	end

	G.setCanvas()
	G.draw(canvas)
end


function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end
