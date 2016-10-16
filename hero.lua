Hero = Entity:new {
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

local function getMelee1Details(hero)
	local w, h = 8, 8

	-- TODO: BALANCING replace with   + w / 2   once attacks are handled by timer
	local startX = hero.x + (hero.w / 2  ) * hero.dir
	local startY = hero.y
	local box = {
		x = startX - w / 2,
		y = startY - h / 2,
		w = w,
		h = h,
	}

	return 20, box
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


--	local damage, box
--
--	if D"c" then
--		damage, box = getMelee1Details(self)
--	elseif D"v" then
--
--	elseif not (damage and box) then
--		return
--	else
--		return
--	end
--
--	self:action_meleeAttack(box, damage)
end
