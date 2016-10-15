TimeInterval = Object.new()

function TimeInterval:init(duration)
	self.currentTime = 0
	self.duration = duration
end

function TimeInterval:isAtStart()
	return self.currentTime == 0
end

function TimeInterval:update()
	self.currentTime = (self.currentTime >= duration) and 0 or (self.currentTime + 1)
	return self.currentTime == 0
end