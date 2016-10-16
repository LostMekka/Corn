Entity = Object:new {
	w = 32,
	h = 32,
	-- global constants
	GRAVITY     = 0.2,
	MAX_SPEED_X = 4,
	MAX_SPEED_Y = 4,
	-- Entity specific constants
	ACCEL_FLOOR       = 0.25,
	ACCEL_AIR         = 0.175,
	MAX_WALK_SPEED    = 2,
	JUMP_START_SPEED  = 4,
	JUMP_CUTOFF_SPEED = 1,
	GRAVITY_FACTOR    = 1,
	IGNORES_GRAVITY   = false,
}


function Entity:initResources()
	-- load image and quads
	if not self.img and self.name then
		self.img = G.newImage("media/" .. self.name .. ".png")
		self.quads = makeQuads(
			self.img:getWidth(),
			self.img:getHeight(),
			self.img:getHeight())
	end
end

function Entity:damage(damageValue)
	self.life = self.life - damageValue
	self.alive = self.life > 0
end


function Entity:init(x, y)
	self:initResources()

	self.x = x
	self.y = y
	self.vx = 0
	self.vy = 0
	self.dir = 1
	self.frame = 1
	self.isHero = false
	self.movementState = "air"
	self.actionState = nil
	self.life = 100
	self.alive = true
	self.box = {}
	self:updateBB()
end


function Entity:canWalkForward(distance)
	distance = distance or TILE_SIZE
	local box = {
		x = self.box.x + self.dir * distance,
		y = self.box.y + 2,
		w = self.box.w,
		h = self.box.h,
	}
	return map:collision(box, "y") ~= 0
end


function Entity:handleAttacks(input)
end


function Entity:update()
	local input = self:getInput()

	self:handleAttacks(input)

	if self.actionState then
		self.actionState:update(self, input)
	else
		self:move(input)
	end
end


function Entity.getDefaultInput()
	return {
		moveX = 0,
		jump = false,
	}
end

function Entity:getInput()
	return Entity.getDefaultInput()
end

function Entity:updateBB()
	self.box.x = self.x - self.w / 2
	self.box.y = self.y - self.h / 2
	self.box.w = self.w
	self.box.h = self.h
	return self.box
end

function Entity:move(input)

	local dir = self.dir

	if self.movementState == "floor" then
		self.vx = math.max(
			self.vx - self.ACCEL_FLOOR,
			math.min(self.vx + self.ACCEL_FLOOR, input.moveX * self.MAX_WALK_SPEED)
		)

	elseif self.movementState == "air" then
		local m = math.max(self.MAX_WALK_SPEED, math.abs(self.vx))
		self.vx = math.max(-m, math.min(m, self.vx + input.moveX * self.ACCEL_AIR))
	end
	if input.moveX ~= 0 then
		dir = input.moveX
	end


	local vx = math.min(self.MAX_SPEED_X, math.max(-self.MAX_SPEED_X, self.vx))
	self.x = self.x + vx


	-- vertical collision
	local dx = map:collision(self:updateBB(), "x")
	if dx ~= 0 then
		self.x = self.x + dx
		self.vx = 0
	end


	local oy = self.y

	if self.movementState == "air" or self.movementState == "floor" then

		-- self.GRAVITY
		self.vy = self.vy + (self.IGNORES_GRAVITY and 0 or self.GRAVITY * self.GRAVITY_FACTOR)
		local vy = math.min(self.MAX_SPEED_Y, math.max(-self.MAX_SPEED_Y, self.vy))
		self.y = self.y + vy
	end


	-- horizontal collision
	local floor = false
	local dy = map:collision(self:updateBB(), "y", self.y - oy)
	if dy ~= 0 then
		self.y = self.y + dy
		self.vy = 0
		if dy < 0 then
			floor = true
		end
	end

	self:updateBB()


	if not floor and self.movementState == "floor" then
		self.movementState = "air"
	elseif floor then
		self.movementState = "floor"
	end

	if (dx ~= 0 or dy ~= 0) and self.onCollide then
		self:onCollide("x")
	end


	if self.movementState == "floor" then

		-- jump
		if input.jump and not self.jump and iy ~= 1 then
			self.movementState = "air"
			self.vy = -self.JUMP_START_SPEED
			self.jump_control = true
		end

	elseif self.movementState == "air" then

		-- control jump height
		if self.jump_control then
			if not input.jump and self.vy < -self.JUMP_CUTOFF_SPEED then
				self.vy = -self.JUMP_CUTOFF_SPEED
				self.jump_control = false
			elseif self.vy > -1 then
				self.jump_control = false
			end
		end
	end


	self.jump = input.jump
	self.dir = dir

	-- animation
	self.frame = 1
end

function Entity:draw()
	if self.img then
		local s = self.img:getHeight()
		G.draw(self.img, self.quads[self.frame], self.x, self.y, 0, self.dir, 1, s / 2, s / 2)
	end

	if not self.img or DEBUG then
		G.rectangle("line",
			self.x - self.w / 2,
			self.y - self.h / 2,
			self.w, self.h)
	end
end

function Entity:knockback(otherEntity, force)
	force = force or 1
	local dir = 1
	if self.x < otherEntity.x then
		dir = -dir
	end
	self.vx = force * dir * 3
	self.vy = force * -2
end

function Entity:action_meleeAttack(box, damage, hitCallback)
	local targets = map:getEntityList(not self.isHero)
	local target = map:firstCollisionWithBox(box, targets)
	if target then
		target:damage(damage)
		if hitCallback then
			hitCallback(target)
		end
	end
end

function Entity:action_shoot()
	table.insert(projectiles, Projectile(self, 10))
end


-- ACTION STATE STUFF --

ActionState = Object:new()
UnicornThrust = ActionState:new()
function UnicornThrust:init(entity)
	self.tick = 0

	entity.vx = entity.dir * 2
	entity.vy = 0

end
function UnicornThrust:update(entity, input)
	self.tick = self.tick + 1
	-- terminate
	if self.tick > 20 then
		entity.actionState = nil
	end


	if self.tick <= 10 then
		entity.x = entity.x + entity.dir * 3

		local dx = map:collision(entity:updateBB(), "x")
		if dx ~= 0 then
			entity.x = entity.x + dx
		end
	else
		entity:move(entity.getDefaultInput())
	end


	-- animation
	entity.frame = 1
	if self.tick <= 10 then
		entity.frame = 2
	end
end
