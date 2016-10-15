require "helper"

Entity = Object:new {
    bounds = {x = 0, y = 0, w = 32, h = 32}
}
function Entity:init(x,y)
	Entity.init(self, x, y)
end

function Entity:draw()

end

function Entity:update()

end
