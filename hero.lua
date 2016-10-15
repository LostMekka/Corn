local G = love.graphics
local D = love.keyboard.isDown


Hero = Entity:new {
	w = 24,
	h = 24,
}

function Hero:init(x, y)
	self.x = x
	self.y = y
	self.vx = 0
	self.vy = 0
	self.dir = 1
	self.state = "air"
	self.box = {}
	self:updateBB()
end


function Hero:updateBB()
	self.box.x = self.x - self.w / 2
	self.box.y = self.y - self.h / 2
	self.box.w = self.w
	self.box.h = self.h
	return self.box
end



function Hero:update()
	local ix = bool[D"right"] - bool[D"left"]
	local iy = bool[D"down"] - bool[D"up"]
	local jump = D"x"

	local dir = self.dir

	if self.state == "floor" then
		self.vx = math.max(self.vx - 0.25, math.min(self.vx + 0.25, ix * 1))

	elseif self.state == "air" then
		local m = math.max(1, math.abs(self.vx))
		self.vx = math.max(-m, math.min(m, self.vx + ix * 0.175))
	end
	if ix ~= 0 then
		dir = ix
	end


	local vx = math.min(3, math.max(-3, self.vx))
	self.x = self.x + vx


	-- vertical collision
	local dx = map:collision(self:updateBB(), "x")
	if dx ~= 0 then
		self.x = self.x + dx
		self.vx = 0
	end



	local oy = self.y

	if self.state == "air" or self.state == "floor" then

		-- gravity
		self.vy = self.vy + 0.2

		local vy = math.min(3, math.max(-3, self.vy))
		self.y = self.y + vy

	end


	-- horizontal collision
	floor = false
	local dy = map:collision(self:updateBB(), "y", self.y - oy)
	if dy ~= 0 then
		self.y = self.y + dy
		self.vy = 0
		if dy < 0 then
			floor = true
		end
	end
	if not floor and self.state == "floor" then
		self.state = "air"
	elseif floor then
		self.state = "floor"
	end




	if self.state == "floor" then
		self.rope_state = "off"

		-- jump
		if jump and not self.jump and iy ~= 1 then
			self.state = "air"
			self.vy = -4
			self.jump_control = true
		end

		-- drop
		if jump and not self.jump and iy == 1 then
			local dy = map:collision(self:updateBB(), "y")
			if dy == 0 then
				self.state = "air"
				self.y = self.y + 0.5
			end
		end

	elseif self.state == "air" then

		-- control jump height
		if self.jump_control then
			if not jump and self.vy < -1 then
				self.vy = -1
				self.jump_control = false
			elseif self.vy > -1 then
				self.jump_control = false
			end
		end

	end



	self.jump = jump
	self.dir = dir

	-- animations
--	if self.state == "floor" then
--		if ix == 0 then
--			self.tick = 0
--			self.anim = self.anims.idle
--		else
--			self.tick = self.tick + 1
--			self.anim = self.anims.run
--		end
--	else
--		self.anim = self.anims.jump
--	end

	self:updateBB()

end

function Hero:draw()
	G.rectangle("line",
		self.x - self.w / 2,
		self.y - self.h / 2,
		self.w, self.h)
end
