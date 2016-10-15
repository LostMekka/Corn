Entity = Object:new {
	w = 32,
	h = 32,
	-- global constants
	GRAVITY = 0.2,
	MAX_SPEED_X = 4,
	MAX_SPEED_Y = 4,
	-- Entity specific constants
	ACCEL_FLOOR = 0.25,
	ACCEL_AIR = 0.175,
	MAX_WALK_SPEED = 2,
	JUMP_START_SPEED = 4,
	JUMP_CUTOFF_SPEED = 1,
	IGNORES_GRAVITY   = false,
}


function Entity:initResources()
	self.life = 100
	self.alive = true
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
	self.life = self.live - damageValue
	self.alive = self.life > 0
end


function Entity:init(x, y)
	self:initResources()
	self.x = x
	self.y = y
	self.vx = 0
	self.vy = 0
	self.isHero = false
	self.dir = 1
	self.movementState = "air"
	self.actionState = "none"
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


function Entity:update()
	local input = self:getInput()
	self:move(input)
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
		if self.onCollide then
			self:onCollide("x")
		end
		self.x = self.x + dx
		self.vx = 0
	end


	local oy = self.y

	if self.movementState == "air" or self.movementState == "floor" then

		-- self.GRAVITY
		self.vy = self.vy + (self.IGNORES_GRAVITY and 0 or self.GRAVITY)
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
	if not floor and self.movementState == "floor" then
		self.movementState = "air"
	elseif floor then
		self.movementState = "floor"
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

	-- animations
	--	if  self.movementState == "floor" then
	--		if input.moveX == 0 then
	--			self.tick = 0
	--			self.anim = self.anims.idle
	--		else
	--			self.tick = self.tick + 1
	--			self.anim = self.anims.run
	--		end
	--	else
	--		self.anim = self.anims.jump
	--	end

	self:updateBB()
end

function Entity:draw()
	if self.img then
		local s = self.img:getHeight()
		G.draw(self.img, self.quads[1], self.x, self.y, 0, self.dir, 1, s / 2, s / 2)
	end

	if not self.img or DEBUG then
		G.rectangle("line",
			self.x - self.w / 2,
			self.y - self.h / 2,
			self.w, self.h)
	end
end

function Entity:action_meleeAttack(box, damage)

end

function Entity:action_shoot()

end
