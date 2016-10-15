local json = require("dkjson")

local G = love.graphics


TILE_SIZE = 16

Map = Object:new {
	img = G.newImage("media/tiles.png"),
}
Map.quads = makeQuads(Map.img:getWidth(), Map.img:getHeight(), 16)
function Map:init(filename)

	local raw = love.filesystem.read(filename)

	local data = json.decode(raw)
	self.w = data.width
	self.h = data.height


	self.objects = {}

	self.rooms = {}

	for i, layer in ipairs(data.layers) do

		if layer.type == "objectgroup" then
			-- room layer
			if layer.name == "rooms" then
				for j, obj in ipairs(layer.objects) do
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

				for j, obj in ipairs(layer.objects) do
					if obj.name == "player" then
						self.objects.player = {
							x = obj.x + obj.width / 2,
							y = obj.y + obj.height / 2 }
					end
				end
			end

		elseif layer.type == "tilelayer" then
			self.tile_data = layer.data
		end

	end


end
function Map:collision(box, axis, dy)

	local x1 = math.floor(box.x / 16)
	local x2 = math.floor((box.x + box.w) / 16)
	local y1 = math.floor(box.y / 16)
	local y2 = math.floor((box.y + box.h) / 16)


	local b = { w=16, h=16 }

	local d = 0
	for x = x1, x2 do
		for y = y1, y2 do

			local cell = self.tile_data[y * self.w + x + 1]
			if cell and cell > 0 then

				b.x = x * 16
				b.y = y * 16

				if cell == 1 and dy ~= "cliff" then

					if axis == "y" and dy then
						if box.y + box.h > b.y
						and box.y + box.h - dy - 0.01 <= b.y
						and box.x + box.w > b.x and box.x < b.x + b.w then

							local e = -(box.y + box.h - b.y)
							if math.abs(e) > math.abs(d) then d = e end

						end
					end


				else
					local e = collision(box, b, axis)
					if math.abs(e) > math.abs(d) then d = e end
				end
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

function Map:rayIntersection(ox, oy, dx, dy)
	for i, b in ipairs(self.boxes) do
		if not b.ow then

			local e = rayBoxIntersection(ox, oy, dx, dy, b)
			if e and (not d or e < d) then d = e end
		end
	end
	return d
end



function Map:draw(area)

	G.setColor(255, 255, 255)

	local x1 = math.floor(area.x / 16)
	local x2 = math.floor((area.x + area.w) / 16)
	local y1 = math.floor(area.y / 16)
	local y2 = math.floor((area.y + area.h) / 16)

	for x = x1, x2 do
		for y = y1, y2 do

			local cell = self.tile_data[y * self.w + x + 1]
			if cell and cell > 0 then
				G.draw(self.img, self.quads[cell], x * 16, y * 16)
			end
		end
	end

end


function Map:getRoomAt(x, y)
	for i, room in ipairs(self.rooms) do
		if room.x <= x and x <= room.x + room.w
		and room.y <= y and y <= room.y + room.h then
			return room
		end
	end
	return nil
end
