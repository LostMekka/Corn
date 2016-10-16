Officer = Enemy:new {
	h = 32,
	w = 18,
	name = "officer"
}
function Officer:init(x, y)
	Enemy.init(self, x, y)
end

function Officer:update()
	Enemy.update(self)
end
