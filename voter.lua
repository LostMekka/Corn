Voter = Enemy:new {
	w = 16,
	h = 32,
	name = "voter",
	animation = {
		idle = {1,},
		move = {1, 2, time = 14},
	},
}
function Voter:init(x, y)
	Enemy.init(self, x, y)
end

function Voter:update()
	Enemy.update(self)
end
