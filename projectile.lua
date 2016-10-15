Projectile = Entity:new {
	w = 8,
	h = 8,
	ACCEL_FLOOR       = 1,
	ACCEL_AIR         = 1,
	MAX_WALK_SPEED    = 4,
	JUMP_START_SPEED  = 0,
	JUMP_CUTOFF_SPEED = 0,
	GRAVITY_FACTOR    = 0.025,
}

function Projectile:init(entity, damage)
	self:super(entity.x + (entity.w / 2 - self.w / 2) * entity.dir, entity.y)
	self.vx = 4 * entity.dir
	self.damageValue = damage
end

function Projectile:onCollide(axis, direction, target)
	if axis == "x" and not target or not target.isHero then -- TODO check for correct target
		self.alive = false
		if target then
			target:damage(self.damageValue)
		end
	end
end

function Projectile:draw()
	G.rectangle("line",
		self.x - self.w / 2,
		self.y - self.h / 2,
		self.w, self.h)
end

