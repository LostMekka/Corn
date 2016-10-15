local G = love.graphics

Object = {}
function Object:new(o)
	o = o or {}
	setmetatable(o, self)
	local m = getmetatable(self)
	self.__index = self
	self.__call = m.__call
	self.super = m.__index and m.__index.init
	return o
end
setmetatable(Object, { __call = function(self, ...)
	local o = self:new()
	if o.init then o:init(...) end
	return o
end })


bool = { [true] = 1, [false] = 0 }



function makeQuads(w, h, s)
	local quads = {}
	for y = 0, h - s, s do
		for x = 0, w - s, s do
			table.insert(quads, love.graphics.newQuad(x, y, s, s, w, h))
		end
	end
	return quads
end
