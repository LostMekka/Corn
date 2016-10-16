Bodyguard = Enemy:new {
	h = 32,
	w = 16,
	name = "bodyguard"
}

function Bodyguard:init(x, y)
	Enemy.init(self, x, y)
end

function Bodyguard:update()
	Enemy.update(self)
end
