Hero = Entity:new {
	isHero = true,
	name = "hero",
	w = 20,
	h = 24,
	ACCEL_FLOOR       = 0.25,
	ACCEL_AIR         = 0.175,
	MAX_WALK_SPEED    = 2,
	JUMP_START_SPEED  = 4.6,
	JUMP_CUTOFF_SPEED = 1,
	animation = {
		idle = {1,},
		move = {1, 2,},
		thrust1 = {2,},
		thrust2 = {3,},
	}
}


function Hero:init(x, y)
	self:super(x, y)
	self.invincibilityTicksLeft = 0
end

function Hero:damage(d)
	if self.invincibilityTicksLeft <= 0 then
		Entity.damage(self, d)
		self.invincibilityTicksLeft = 60
	end
end

function Hero:update()
	if self.invincibilityTicksLeft > 0 then
		self.invincibilityTicksLeft = self.invincibilityTicksLeft - 1
	end

	Entity.update(self)
	if not self.alive then
		menu:gameOver()
	end
end

function Hero:getInput()
	return {
		moveX = bool[D"right"] - bool[D"left"],
		jump = D"up" or D"x"
	}
end


function Hero:handleAttacks()

	if self.movementState == "floor" then
		self.isAirUnicornThrustUsedUp = false
	end

	if D"c" and not self.actionState then
		if self.isAirUnicornThrustUsedUp == false then
			self.actionState = UnicornThrust(self)
		end

		if self.movementState == "air" then
			self.isAirUnicornThrustUsedUp = true
		end
	end

end

function Hero:draw()
	if self.invincibilityTicksLeft % 6 < 3 then
		Entity.draw(self)
	end
end



Camera = Object:new()
function Camera:init(x, y)
	self.x = x
	self.y = y
	self:update()
end
function Camera:update()

	self.tx = self.x
	self.ty = self.y

	if self.tx < hero.x - 70 then
		self.tx = hero.x - 70
	elseif self.tx > hero.x + 70 then
		self.tx = hero.x + 70
	end
	if self.ty < hero.y - 40 then
		self.ty = hero.y - 40
	elseif self.ty > hero.y + 40 then
		self.ty = hero.y + 40
	end

	self.x = math.max(self.x - 8, math.min(self.x + 8, self.tx))
	self.y = math.max(self.y - 8, math.min(self.y + 8, self.ty))

	-- room logic
	local room = {
		x = 0,
		y = 0,
		w = map.w * TILE_SIZE,
		h = map.h * TILE_SIZE,
	}

	if self.tx < room.x + 200 then
		self.tx = room.x + 200
	elseif self.tx > room.x + room.w - 200 then
		self.tx = room.x + room.w - 200
	end

	if self.ty < room.y + 120 then
		self.ty = room.y + 120
	elseif self.ty > room.y + room.h - 120 then
		self.ty = room.y + room.h - 120
	end


	self.x = math.max(self.x - 8, math.min(self.x + 8, self.tx))
	self.y = math.max(self.y - 8, math.min(self.y + 8, self.ty))

end
