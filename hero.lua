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
end


function Hero:getInput()
	return {
		ix = bool[D"right"] - bool[D"left"],
		jump = D"up" or D"x"
	}
end

