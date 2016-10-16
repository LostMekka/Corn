--DEBUG = true

-- lines that are rendered if DEBUG is set
debugLines = {}


G = love.graphics
D = love.keyboard.isDown
A = love.audio

-- init technical stuff
W = 400
H = 240
G.setDefaultFilter("nearest", "nearest")
canvas = G.newCanvas(W, H)
love.window.setMode(W * 2, H * 2, {resizable = true})
love.mouse.setVisible(false)


-- require stuff
require "helper"
require "timeinterval"
require "map"
require "entity"
require "enemy"
require "voter"
require "bodyguard"
require "officer"
require "hero"
require "projectile"
require "particle"
require "menu"



gameState = Object:new {
	-- state may be "start", "over", "pause", "playing", ...
	state = "start"
}
function Menu:isMenu()
	return self.state ~= "playing"
end
function Menu:togglePause()
	if self.state == "pause" then
		self.state = "playing"
	elseif self.state == "playing" then
		self.state = "pause"
	end
end






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
	local room = {
		x = 0,
		y = 0,
		w = map.w * TILE_SIZE,
		h = map.h * TILE_SIZE,
	}

	if self.tx < room.x + 200 then
		self.tx = room.x + 200
	elseif self.tx > room.x + room.w - 200 then
		self.tx = room.x + room.w - 200
	end

	if self.ty < room.y + 120 then
		self.ty = room.y + 120
	elseif self.ty > room.y + room.h - 120 then
		self.ty = room.y + room.h - 120
	end


	self.x = math.max(self.x - 8, math.min(self.x + 8, self.tx))
	self.y = math.max(self.y - 8, math.min(self.y + 8, self.ty))

end



-- instantiate stuff
map = Map("media/map-01.json")
hero = map.objects.player
enemies = map.objects.enemies
projectiles = map.objects.projectiles
particles = {}
camera = Camera(map.objects.player.x, map.objects.player.y)
menu = Menu()


song = A.newSource("media/music_001.mp3")
A.play(song)


function love.update()
	if not menu:isPlaying() then
		updateList(particles)
		return
	end

	-- move stuff around
	hero:update()
	camera:update()

	updateList(enemies)
	updateList(projectiles)
	updateList(particles)

    if #enemies == 0 and not menu.aboutToWin then
        menu.aboutToWin = true
		-- FIXME
        TimeInterval(120, function()
            menu.state = "win"
    	end)
    end

	updateTimers()
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
	for _, e in ipairs(enemies) do e:draw() end
	for _, p in ipairs(projectiles) do p:draw() end
	for _, p in ipairs(particles) do p:draw() end

	for _, line in ipairs(debugLines) do
		G.line(line[1], line[2], line[3], line[4])
	end
	debugLines = {}

	G.origin()

	love.graphics.printf('LP: ' .. math.max(hero.life or 0, 0), 0, 0, 400, "right")

	if DEBUG then
		love.graphics.print('FPS: ' .. love.timer.getFPS(), 0, 0)
		love.graphics.print('Enemies: ' .. #enemies, 0, 15)
		love.graphics.print('Projectiles: ' .. #projectiles, 0, 30)
	end

	menu:draw()

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
	if menu:keypressed(key) then
		if key == "escape" then
			love.event.quit()
		elseif key == "p" then
			menu:togglePause()
		elseif key == "f11" then
			DEBUG = not DEBUG
		elseif key == "backspace" then
		    for _, e in ipairs(enemies) do e:kill() end
		end
	end
end
