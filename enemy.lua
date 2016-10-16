Enemy = Entity:new {
	attackStrategy = "meelee",
	sightRange = 6 * TILE_SIZE,
	aiState = "wander",
	MAX_WALK_SPEED = 1,
	touchDamage = 10,
}
function Enemy:init(x, y)
	Entity.init(self, x, y)
	self.input = Entity.getDefaultInput()
	self.seesHero = false
	self.wanderState = {
		time = 0,
	}
	-- funny random jumping just to test stuff
	local onFinishedJumping, onStartJumping
	onFinishedJumping = function()
		self.input.jump = false
		if not self.dead then
			TimeInterval(love.math.random(300) + 60, onStartJumping)
		end
		return false
	end
	onStartJumping = function()
		if self.alive then
			self.input.jump = true
			TimeInterval(love.math.random(20) + 10, onFinishedJumping)
		end
		return false
	end
	onFinishedJumping()
--	TimeInterval(love.math.random(5) + 5, function()
--		self:action_shoot()
--		return self.alive
--	end)
end

function Enemy:update()
	-- perception
	self:updateSight()

	-- states
	if self.aiState == "wander" then self:updateWanderState() end

	-- execute movement
	Entity.update(self)

	-- deal touch damage
	if self.touchDamage then
		self:action_meleeAttack(self:updateBB(), self.touchDamage, function(target)
			target:knockback(self)
		end)
	end
end

function Enemy:updateSight()

end

function Enemy:updateWanderState()
	local cliff = self.movementState == "floor" and not self:canWalkForward()
	if self.wanderState.time == 0 or cliff then
		self.input.moveX = love.math.random(3) - 2
		if cliff and self.input.moveX == self.dir then
			self.input.moveX = self.input.moveX * -1
		end
		self.wanderState.time = love.math.random(60) + 10
	end
	self.wanderState.time = self.wanderState.time - 1
end

function Enemy:getInput()
	return self.input
end

function Enemy:setWalkDirection(d)
	self.input.moveX = d
end

function Enemy:setJump(b)
	self.input.jump = b
end


Voter = Enemy:new {
	h = 32,
	w = 18,
	name = "voter"
}
function Voter:init(x, y)
	Enemy.init(self, x, y)
end

function Voter:update()
	Enemy.update(self)
end
