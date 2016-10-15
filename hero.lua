require "helper"

Hero = Object.new{
	bounds = {x = 0, y = 0, w = 32, h = 32}
}
function Hero:init(x, y)
	self.x = x
	self.y = y
end
function update(time)
	
end