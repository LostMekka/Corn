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


function collision(a, b, axis)
	if a.x >= b.x + b.w
	or a.y >= b.y + b.h
	or a.x + a.w <= b.x
	or a.y + a.h <= b.y then
		return 0
	end

	local dx = b.x + b.w - a.x
	local dx2 = b.x - a.x - a.w

	local dy = b.y + b.h - a.y
	local dy2 = b.y - a.y - a.h

	if axis == "x" then
		return math.abs(dx) < math.abs(dx2) and dx or dx2
	else
		return math.abs(dy) < math.abs(dy2) and dy or dy2
	end
end

local function defaultFilterPredicate(item)
	return not item.alive
end
function updateList(x, removalPredicate)
	removalPredicate = removalPredicate or defaultFilterPredicate
	local i = 1
	for j, b in ipairs(x) do
		x[j] = nil
		b:update()
		if not removalPredicate(b) then
			x[i] = b
			i = i + 1
		end
	end
end


function rayBoxIntersection(ox, oy, dx, dy, box)

	if dx > 0 and ox <= box[1] then
		local f = (box[1] - ox) / dx
		local y = oy + dy * f
		if box[2] <= y and y <= box[2] + box[4] then
			return f
		end
	elseif dx < 0 and ox >= box[1] + box[3] then
		local f = (box[1] + box[3] - ox) / dx
		local y = oy + dy * f
		if box[2] <= y and y <= box[2] + box[4] then
			return f
		end
	end

	if dy > 0 and oy <= box[2] then
		local f = (box[2] - oy) / dy
		local x = ox + dx * f
		if box[1] <= x and x <= box[1] + box[3] then
			return f
		end
	elseif dy < 0 and oy >= box[2] + box[4] then
		local f = (box[2] + box[4] - oy) / dy
		local x = ox + dx * f
		if box[1] <= x and x <= box[1] + box[3] then
			return f
		end
	end

	return false
end

