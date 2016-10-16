Menu = Object:new {
	-- state may be "start", "over", "pause", "playing", "win"
	state = "start",
}
function Menu:init()
	self.state = "start"
	self.aboutToWin = false
	self.selectedIndex = 0
end

function Menu:isPlaying()
	return self.state == "playing"
end
function Menu:togglePause()
	if self.state == "pause" then
		self.state = "playing"
	elseif self.state == "playing" then
		self.state = "pause"
	end
end
function Menu:gameOver()
	self.state = "over"
end


Menu.menuEntries = {
	{
		text = "Start",
		show = function()
			return menu.state == "start"
		end,
		action = function()
			menu.state = "playing"
		end,
	},
	{
		text = "Continue",
		show = function()
			return menu.state == "pause"
		end,
		action = function()
			menu.state = "playing"
		end,
	},
	{
		text = "Restart",
		show = function()
			return menu.state == "pause" or menu.state == "over"
		end,
		action = function()
			initGame()
		end,
	},
--	{
--		text = "Credits",
--		show = function()
--			return true
--		end,
--		action = function()
--			-- show credits
--		end,
--	},
	{
		text = "Quit",
		show = function() return true end,
		action = function()
			love.event.quit()
		end,
	}
}

function Menu:changeSelectedIndex(dir)
	local rangeEnd
	if dir > 0 then
		rangeEnd = #self.menuEntries
	else
		rangeEnd = 1
	end
	for i = self.selectedIndex + dir, rangeEnd, dir do
		local entry = self.menuEntries[i]
		if entry and entry.show() then
			self.selectedIndex = i
			return
		end
	end

	-- we didn't find a matching entry, start again on the opposite end
	if dir > 0 then
		self.selectedIndex = 0
	else
		self.selectedIndex = #self.menuEntries + 1
	end
	self:changeSelectedIndex(dir)
end

local function printCenteredText(text, top)
	G.printf(text, 0, top, 400, "center")
end

local w, h = 150, 200
function Menu:draw()
	if self.state == "playing" then
		return
	end

	if self.selectedIndex == 0 then
		self:changeSelectedIndex(1)
	end

	local color -- = {G.getColor() }
	-- background
--	G.setColor(0, 0, 0, 229)
--	G.rectangle("fill", (W - w ) / 2, (H - h) / 2, w, h, 10, 10)
--	G.setColor(unpack(color))

	local headline, subHeadline = "", ""
	if self.state == "start" then
		headline = "Corn"
		subHeadline = ""
	elseif self.state == "over" then
		headline = "GAME OVER"
		subHeadline = "The world is doomed"
	elseif self.state == "pause" then
		headline = "PAUSE"
		subHeadline = "Press P to continue"
	elseif self.state == "win" then
        headline = "YOU WIN!"
	    subHeadline = "Donald Trump is defeated.\nThe world is now a better place."
	else
		return
	end

	local top = 50

	G.setNewFont(30)
	printCenteredText(headline, top)
	G.setNewFont()
	printCenteredText(subHeadline, top + 40)

	top = top + 75
	for entryIndex, entry in ipairs(self.menuEntries) do
		if entry.show() then
			if entryIndex == self.selectedIndex then
				color = {G.getColor()}
				G.setColor(25, 25, 25, 178)
				G.rectangle("fill", (W - w + 30 ) / 2, top - 5, w - 30, 20)
				G.setColor(unpack(color))
			end

			printCenteredText(entry.text, top)
			top = top + 20

		end
	end
end

function Menu:keypressed(key)
	if self.state == "playing" then
		return true
	end

	if key == "down" then
		self:changeSelectedIndex(1)
	elseif key == "up" then
		self:changeSelectedIndex(-1)
	elseif key == "return" then
		self.menuEntries[self.selectedIndex].action()
		self.selectedIndex = 0
	elseif key == "p" or key == "escape" then
		return true
	end
end
