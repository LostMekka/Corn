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

function Projectile:init(entity, damage, name)
	self.name = name
	self:super(entity.x + (entity.w / 2 - self.w / 2) * entity.dir, entity.y)
	self.vx = 4 * entity.dir
	self.damageValue = damage
	self.damagesHero = not entity.isHero
end

function Projectile:update()
	Entity.update(self)
	local targets = map:getEntityList(self.damagesHero)
	local target, axis, offset = map:firstCollisionWithBox(self:updateBB(), targets)
	if axis == "x" then
		self:onCollide(axis, offset, target)
	end
	if self.vx > 0 then
		self.dir = 1
	else
		self.dir = -1
	end
end

function Projectile:onCollide(axis, direction, target)
	if axis == "x" then
		self.alive = false
		if target then
			target:damage(self.damageValue)
		end
	end
end

