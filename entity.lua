Entity = Object:new {
	w = 32,
	h = 32,
	-- global constants
	GRAVITY           = 0.2,
	MAX_SPEED_X       = 4,
	MAX_SPEED_Y       = 4,
	-- Entity specific constants
	ACCEL_FLOOR       = 0.25,
	ACCEL_AIR         = 0.175,
	MAX_WALK_SPEED    = 2,
	JUMP_START_SPEED  = 4,
	JUMP_CUTOFF_SPEED = 1,
}

function Entity:init(x, y)
	self.x = x
	self.y = y
	self.vx = 0
	self.vy = 0
	self.dir = 1
	self.state = "air"
	self.box = {}
	self:updateBB()
end

function Entity:update()
	local input = self:getInput()
	self:move(input)
end


function Entity:getInput()
	return {
		ix = 0,
		jump = false
	}
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

	if self.state == "floor" then
		self.vx = math.max(
			self.vx - self.ACCEL_FLOOR,
			math.min(self.vx + self.ACCEL_FLOOR, input.ix * self.MAX_WALK_SPEED)
		)

	elseif self.state == "air" then
		local m = math.max(self.MAX_WALK_SPEED, math.abs(self.vx))
		self.vx = math.max(-m, math.min(m, self.vx + input.ix * self.ACCEL_AIR))
	end
	if input.ix ~= 0 then
		dir = ix
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

	if self.state == "air" or self.state == "floor" then

		-- self.GRAVITY
		self.vy = self.vy + self.GRAVITY
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
	if not floor and self.state == "floor" then
		self.state = "air"
	elseif floor then
		self.state = "floor"
	end


	if self.state == "floor" then

		-- jump
		if input.jump and not self.jump and iy ~= 1 then
			self.state = "air"
			self.vy = -self.JUMP_START_SPEED
			self.jump_control = true
		end

	elseif self.state == "air" then

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
	--	if self.state == "floor" then
	--		if ix == 0 then
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

end
