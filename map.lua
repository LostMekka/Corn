local json = require("dkjson")

local G = love.graphics


TILE_SIZE = 16

Map = Object:new {
	img = G.newImage("media/tiles.png"),
}
Map.quads = makeQuads(Map.img:getWidth(), Map.img:getHeight(), TILE_SIZE)
function Map:init(filename)

	local raw = love.filesystem.read(filename)

	local data = json.decode(raw)
	self.w = data.width
	self.h = data.height


	self.objects = {}
	self.objects.enemies = {}
	self.objects.projectiles = {}

	self.rooms = {}

	for _, layer in ipairs(data.layers) do

		if layer.type == "objectgroup" then
			-- room layer
			if layer.name == "rooms" then
				for _, obj in ipairs(layer.objects) do
					local room = {
						x = obj.x,
						y = obj.y,
						w = obj.width,
						h = obj.height,
						name = obj.name,
					}
					table.insert(self.rooms, room)
				end

			elseif layer.name == "objects" then

				for _, obj in ipairs(layer.objects) do
					local x = obj.x + obj.width / 2
					local y = obj.y + obj.height / 2
					if obj.name == "player" then
						self.objects.player = Hero(x, y)
					end
					if obj.name == "voter" then
						table.insert(self.objects.enemies, Voter(x, y))
					end
					if obj.name == "officer" then
						table.insert(self.objects.enemies, Officer(x, y))
					end
					if obj.name == "bodyguard" then
						table.insert(self.objects.enemies, Bodyguard(x, y))
					end
				end
			end

		elseif layer.type == "tilelayer" then
			self.tile_data = layer.data
		end

	end

end
function Map:collision(box, axis)

	local x1 = math.floor(box.x / TILE_SIZE)
	local x2 = math.floor((box.x + box.w) / TILE_SIZE)
	local y1 = math.floor(box.y / TILE_SIZE)
	local y2 = math.floor((box.y + box.h) / TILE_SIZE)


	local b = { w = TILE_SIZE, h = TILE_SIZE }

	local d = 0

	for x = x1, x2 do
		for y = y1, y2 do

			local cell = self.tile_data[y * self.w + x + 1]
			if cell and cell > 0 and cell <= 128 then

				b.x = x * TILE_SIZE
				b.y = y * TILE_SIZE
--[[
--				if cell == 1 and dy ~= "cliff" then
--
--					if axis == "y" and dy then
--						if box.y + box.h > b.y
--						and box.y + box.h - dy - 0.01 <= b.y
--						and box.x + box.w > b.x and box.x < b.x + b.w then
--
--							local e = -(box.y + box.h - b.y)
--							if math.abs(e) > math.abs(d) then d = e end
--
--						end
--					end
--
--
--				else
--
]]
					local e = collision(box, b, axis)
					if math.abs(e) > math.abs(d) then d = e end

--				end
			end
		end
	end

--[[
	local d = 0
	for i, b in ipairs(self.boxes) do

		if b.ow and dy ~= "cliff" then
			if axis == "y" and dy then
				if box[2] + box[4] > b[2]
				and box[2] + box[4] - dy - 0.01 <= b[2]
				and box[1] + box[3] > b[1] and box[1] < b[1] + b[3] then

					local e = -(box[2] + box[4] - b[2])
					if math.abs(e) > math.abs(d) then d = e end

				end
			end
		else
			local e = collision(box, b, axis)
			if math.abs(e) > math.abs(d) then d = e end

		end
	end

--]]


	return d
end

function Map:firstCollisionWithBox(box, targetList)
	for _, target in ipairs(targetList) do
		local targetBox = target:updateBB()
		if collision(box, targetBox, "x") ~= 0 then
			return target, "x", offsetX
		elseif collision(box, targetBox, "y") ~= 0 then
			return target, "y", offsetY
		end
	end
end

function Map:rayIntersection(x1, y1, x2, y2)
	local minX = math.floor(math.min(x1, x2) / TILE_SIZE)
	local maxX = math.floor(math.max(x1, x2) / TILE_SIZE) + 1
	local minY = math.floor(math.min(y1, y2) / TILE_SIZE)
	local maxY = math.floor(math.max(y1, y2) / TILE_SIZE) + 1

	local box = { w = TILE_SIZE, h = TILE_SIZE }
	local d = 1

	for x = minX, maxX do
		for y = minY, maxY do
			local cell = self.tile_data[y * self.w + x + 1]
			if cell and cell > 0 and cell <= 128 then
				box.x = x * TILE_SIZE
				box.y = y * TILE_SIZE
				local ans = rayBoxIntersection(x1, y1, x2-x1, y2-y1, box)
				if ans == false then ans = 1 end
				d = math.min(d, ans)
			end
		end
	end

	return d
end



function Map:draw(area)

	G.setColor(255, 255, 255)

	local x1 = math.floor(area.x / TILE_SIZE)
	local x2 = math.floor((area.x + area.w) / TILE_SIZE)
	local y1 = math.floor(area.y / TILE_SIZE)
	local y2 = math.floor((area.y + area.h) / TILE_SIZE)

	for x = x1, x2 do
		for y = y1, y2 do

			local cell = self.tile_data[y * self.w + x + 1]
			if cell and cell > 0 then
				G.draw(self.img, self.quads[cell], x * TILE_SIZE, y * TILE_SIZE)
			end
		end
	end

end


function Map:getRoomAt(x, y)
	for _, room in ipairs(self.rooms) do
		if room.x <= x and x <= room.x + room.w
		and room.y <= y and y <= room.y + room.h then
			return room
		end
	end
	return nil
end


function Map:getEntityList(forHero)
	if forHero then
		return {self.objects.player}
	else
		return self.objects.enemies
	end
end
