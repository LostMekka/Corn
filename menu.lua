Menu = Entity:new()

local menuEntries = {
	{
		text = "Start",
		show = function()
			return gameState.start
		end,
		action = function()
			gameState.start = false
		end,
	},
	{
		text = "Continue",
		show = function()
			return gameState.paused
		end,
		action = function()
			gameState.paused = false
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
local selectedIndex = 0

local function changeSelectedIndex(dir)
	local rangeEnd
	if dir > 0 then
		rangeEnd = #menuEntries
	else
		rangeEnd = 1
	end
	for i = selectedIndex  + dir, rangeEnd, dir do
		local entry = menuEntries[i]
		if entry and entry.show() then
			selectedIndex = i
			return
		end
	end

	-- we didn't find a matching entry, start again on the opposite end
	if dir > 0 then
		selectedIndex = 0
	else
		selectedIndex = #menuEntries + 1
	end
	changeSelectedIndex(dir)
end

local function printCenteredText(text, top)
	G.printf(text, 0, top, 400, "center")
end

local w, h = 300, 200
function Menu:draw()
	if not gameState:isMenu() then
		return
	end

	if selectedIndex == 0 then
		changeSelectedIndex(1)
	end

	local color = {G.getColor()}
	G.setColor(0, 0, 0, 229)
	G.rectangle("fill", (W - w ) / 2, (H - h) / 2, w, h, 10, 10)
	G.setColor(unpack(color))

	local headline, subHeadline = "", ""
	if gameState.start then
		headline = "START"
		subHeadline = ""
	elseif gameState.over then
		headline = "GAME OVER"
		subHeadline = "The world is doomed"
	elseif gameState.paused	then
		headline = "PAUSE"
		subHeadline = "Press P to continue"
	elseif gameState.win then
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
	for entryIndex, entry in ipairs(menuEntries) do
		if entry.show() then
			if entryIndex == selectedIndex then
				color = {G.getColor()}
				G.setColor(25, 25, 25, 255)
				G.rectangle("fill", (W - w + 30 ) / 2, top - 5, w - 30, 20)
				G.setColor(unpack(color))
			end

			printCenteredText(entry.text, top)
			top = top + 20

		end
	end
end

function Menu:init()
	self.selected = 1
end

function Menu:keypressed(key)
	if not gameState:isMenu() then
		return true
	end

	if key == "down" then
		changeSelectedIndex(1)
	elseif key == "up" then
		changeSelectedIndex(-1)
	elseif key == "return" then
		menuEntries[selectedIndex].action()
		selectedIndex = 0
	elseif key == "p" or key == "escape" then
		return true
	end
end
