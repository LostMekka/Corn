Voter = Enemy:new {
	w = 16,
	h = 32,
	name = "voter"
}
function Voter:init(x, y)
	Enemy.init(self, x, y)
end

function Voter:update()
	Enemy.update(self)
end
