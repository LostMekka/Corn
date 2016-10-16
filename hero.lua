Hero = Entity:new {
	name = "hero",
	w = 24,
	h = 24,
	ACCEL_FLOOR       = 0.25,
	ACCEL_AIR         = 0.175,
	MAX_WALK_SPEED    = 2,
	JUMP_START_SPEED  = 4,
	JUMP_CUTOFF_SPEED = 1,
}


function Hero:init(x, y)
	self:super(x, y)
	self.isHero = true
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

