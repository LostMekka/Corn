Particle = Entity:new {
	w = 2,
	h = 2,
	ttl = 10,
}
function Particle:init(x, y)
	Entity.init(self, x, y)
	table.insert(particles, self)
end
function Particle:update(x, y)
	self.ttl = self.ttl - 1
	if self.ttl <= 0 then
		self.alive = false
	end

	self.x = self.x + self.vx
	self.y = self.y + self.vy
end


Blood = Particle:new {
	name = "blood"
}
function makeBlood(entity)
	for _ = 1, 30 do
		local p = Blood(
			entity.x + (math.random() - 0.5) * entity.w,
			entity.y + (math.random() - 0.5) * entity.h)
		p.ttl = math.random(1, 40)
		p.vx = (math.random() - 0.5) * 5
		p.vy = (math.random() - 0.75) * 5
	end
end

function Blood:update(x, y)
	self.ttl = self.ttl - 1
	if self.ttl <= 0 then
		self.alive = false
	end

	self.x = self.x + self.vx

	local dx = map:collision(self:updateBB(), "x")
	if dx ~= 0 then
		self.x = self.x + dx
		self.vx = self.vx * -1
	end

	self.vy = self.vy + self.GRAVITY
	local vy = math.min(self.MAX_SPEED_Y, math.max(-self.MAX_SPEED_Y, self.vy))
	self.y = self.y + vy

	-- horizontal collision
	local dy = map:collision(self:updateBB(), "y")
	if dy ~= 0 then
		self.y = self.y + dy
		self.vy = self.vy * -1
	end

	self:updateBB()
end
function Blood:draw()
	local ang = math.atan2(-self.vx, self.vy)
	local s = self.img:getHeight()
	local f = math.min(1, self.ttl * 0.1)
	G.draw(self.img, self.quads[self.frame], self.x, self.y, ang,
			self.dir * f, f, s / 2, s / 2)
end
