Lawyer = Enemy:new {
	h = 32,
	w = 18,
	name = "lawyer"
}

function Lawyer:init()
	self.progress = 0
end

function Lawyer:damage(damageValue)
	Enemy.damage(self, damageValue)
	self.progress = math.max(self.progress - 1, 0)
end

function Lawyer:draw()
	Enemy.draw(self)
	G.rectangle(
		"line",
		self.x - self.w / 2,
		self.y - self.h / 4 * 3,
		self.w * self.progress / 10,
		1
	)
end