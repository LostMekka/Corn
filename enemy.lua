Enemy = Entity:new {
	attackStrategy = "meelee",
	sightRange = 10,
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
			TimeInterval(love.math.random(300) + 60, onStartJumping, self)
		end
		return false
	end
	onStartJumping = function()
		if self.alive then
			self.input.jump = true
			TimeInterval(love.math.random(20) + 10, onFinishedJumping, self)
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
	local dx = hero.x - self.x
	local dy = hero.y - self.y
	self.seesHero = hero.alive
		and (dx*dx + dy*dy) <= self.sightRange*self.sightRange*TILE_SIZE*TILE_SIZE
		and map:rayIntersection(self.x, self.y, hero.x, hero.y) == 1
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
