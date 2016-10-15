local G = love.graphics
local D = love.keyboard.isDown


Hero = Entity:new {
	w = 24,
	h = 24,
}

function Hero:init(x, y)
	self.x = x
	self.y = y
end

function Hero:update()
	
end

function Hero:draw()
	G.rectangle("line",
		self.x - self.w / 2,
		self.y - self.h / 2,
		self.w, self.h)
end
