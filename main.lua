G = love.graphics
D = love.keyboard.isDown


-- init technical stuff
W = 400
H = 240
G.setDefaultFilter("nearest", "nearest")
canvas = G.newCanvas(W, H)
love.window.setMode(W, H, {resizable = true})
love.mouse.setVisible(false)
paused = false


-- require stuff
require "helper"
require "entity"
require "enemy"
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
	if paused then
		return
	end

	-- move stuff around

	hero:update()
	for _, e in ipairs(map.objects.enemies) do
		e:update()
	end

--	camera.x = camera.x + (bool[D"right"] - bool[D"left"]) * 4
--	camera.y = camera.y + (bool[D"down"]  - bool[D"up"]) * 4
	camera.x = hero.x
	camera.y = hero.y
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
	for _, e in ipairs(map.objects.enemies) do
		e:draw()
	end

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
	elseif key == "p" then
		paused = not paused
	end
end
