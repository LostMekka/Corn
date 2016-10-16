Bodyguard = Enemy:new {
	h = 32,
	w = 16,
	name = "bodyguard",
	animation = {
		idle = {1,},
		move = {2, 3,},
	}
}

function Bodyguard:init(x, y)
	Enemy.init(self, x, y)
end

function Bodyguard:update()
	Enemy.update(self)
end
