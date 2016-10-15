Boss = Enemy:new()

function Boss:init(x, y, maxHealth, healthRegenRate, attackDamage)
	self.super(x,y)
	self.maxHealth = maxHealth
	self.health = maxHealth
	self.healthRegenrate = healthRegenRate
	self.attackDamage = attackDamage
	self.inFight = false
end

function Boss:update()
	if not self.inFight then
		self.health = Math.min(MAX_HEALTH, self.health + HEALTH_REGEN_RATE)
	end
end

