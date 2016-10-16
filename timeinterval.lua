local timers = {}
local function timerPredicate(timer)
	return timer.destroyed
end
function updateTimers()
	updateList(timers, timerPredicate)
end


TimeInterval = Object:new()

function TimeInterval:init(duration, callback, ...)
	self.currentTime = 0
	self.duration = duration
	self.callback = callback
	self.arguments = {...}
	self.destroyed = false
	table.insert(timers, self)
end

function TimeInterval:update()
	if self.destroyed then
		return
	end
	self.currentTime = self.currentTime + 1
	if self.currentTime >= self.duration then
		if self.callback(unpack(self.arguments)) then
			self.currentTime = 0
		else
			self:destroy()
		end
	end
end

function TimeInterval:destroy()
	self.destroyed = true
end