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
