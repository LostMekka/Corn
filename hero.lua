Hero = Entity:new {
	isHero = true,
	name = "hero",
	w = 20,
	h = 24,
	ACCEL_FLOOR       = 0.25,
	ACCEL_AIR         = 0.175,
	MAX_WALK_SPEED    = 2,
	JUMP_START_SPEED  = 4,
	JUMP_CUTOFF_SPEED = 1,
}


function Hero:init(x, y)
	self:super(x, y)
end

function Hero:update()
	Entity.update(self)
	if not self.alive then
		gameState.over = true
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
