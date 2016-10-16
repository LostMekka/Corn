Officer = Enemy:new {
	h = 32,
	w = 18,
	name = "officer"
}
function Officer:init(x, y)
	Enemy.init(self, x, y)

	local initShotTimer, shootCallback
	shootCallback = function()
		self:shoot()
		initShotTimer()
		return false
	end
	initShotTimer = function()
		TimeInterval(love.math.random(30) + 60, shootCallback, self)
	end
	initShotTimer()
end

function Officer:shoot()
	self:action_shoot(10, "bullet")
end

function Officer:update()
	Enemy.update(self)
end
