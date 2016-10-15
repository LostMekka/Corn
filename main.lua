--DEBUG = true


G = love.graphics
D = love.keyboard.isDown

-- init technical stuff
W = 400
H = 240
G.setDefaultFilter("nearest", "nearest")
canvas = G.newCanvas(W, H)
love.window.setMode(W * 2, H * 2, {resizable = true})
love.mouse.setVisible(false)
paused = false


-- require stuff
require "helper"
require "map"
require "entity"
require "enemy"
require "hero"


Camera = Object:new()
function Camera:init(x, y)
	self.x = x
	self.y = y
	self:update()
end
function Camera:update()

	self.tx = self.x
	self.ty = self.y

	if self.tx < hero.x - 70 then
		self.tx = hero.x - 70
	elseif self.tx > hero.x + 70 then
		self.tx = hero.x + 70
	end
	if self.ty < hero.y - 40 then
		self.ty = hero.y - 40
	elseif self.ty > hero.y + 40 then
		self.ty = hero.y + 40
	end

	self.x = math.max(self.x - 8, math.min(self.x + 8, self.tx))
	self.y = math.max(self.y - 8, math.min(self.y + 8, self.ty))

	-- room logic
--	local room = map:getRoomAt(hero.x, hero.y)
--	if not room then
--		return
--	end
--
--	if self.tx < room.x + 200 then
--		self.tx = room.x + 200
--	elseif self.tx > room.x + room.w - 200 then
--		self.tx = room.x + room.w - 200
--	end
--
--	if self.ty < room.y + 120 then
--		self.ty = room.y + 120
--	elseif self.ty > room.y + room.h - 120 then
--		self.ty = room.y + room.h - 120
--	end
--
--
--	self.x = math.max(self.x - 8, math.min(self.x + 8, self.tx))
--	self.y = math.max(self.y - 8, math.min(self.y + 8, self.ty))

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

	updateList(map.objects.enemies)

	camera:update()
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
