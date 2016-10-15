Enemy = Entity:new {
	seesHero = false,
	attackStrategy = "meelee",
	sightRange = 6 * TILE_SIZE,
	aiState = "wander",
	input = Entity.getDefaultInput(),
}
function Enemy:init(x, y)
	Entity.init(self, x, y)
	self.wanderState = {
		time = 0,
	}
end
function Enemy:update()
	if self.aiState == "wander" then
		if self.wanderState.time == 0 then
			self.input.moveX = love.math.random(3) - 2
			self.wanderState.time = love.math.random(60) + 10
		end
		self.wanderState.time = self.wanderState.time - 1
	end
	Entity.update(self)
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


Voter = Enemy:new()
function Voter:init(x, y)
	Enemy.init(self, x, y)
end
function Voter:update()
	Enemy.update(self)
end
