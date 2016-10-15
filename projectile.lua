Projectile = Entity:new {
	w = 8,
	h = 8,
	ACCEL_FLOOR       = 1,
	ACCEL_AIR         = 1,
	MAX_WALK_SPEED    = 4,
	JUMP_START_SPEED  = 0,
	JUMP_CUTOFF_SPEED = 0,
	IGNORES_GRAVITY   = true,
}

function Projectile:init(entity)
	self:super(entity.x + (entity.w / 2 - self.w / 2) * entity.dir, entity.y)
	self.vx = 4 * entity.dir
end

function Projectile:onCollide(axis, direction, target)
--	if target.name == "hero" then
		self.dead = true
--	end
end

function Projectile:draw()
	G.rectangle("line",
		self.x - self.w / 2,
		self.y - self.h / 2,
		self.w, self.h)
end

