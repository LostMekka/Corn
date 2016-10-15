require "helper"

Entity = Object.new{
    bounds = {x = 0, y = 0, w = 32, h = 32}
}
function Entity:init(x,y)
    self.x = x
    self.y = y
end

function Entity:draw()
end

function Entity:update(time)

end