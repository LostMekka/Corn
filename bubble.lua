Bubble = Object:new {
    w       = 100,
    baseXY  = { x = 0, y = 0 },
    offsetX = 0,
    offsetY = 0,
    alive   = true,
    text    = "Bubble",

    doAnimateSwing = true,
    animationState = {
        tick = 0,
        offsetX = 0,
        offsetY = 0,
    },
}

function Bubble:init()
end

function Bubble:update()
    if not self.alive then return end
    if self.doAnimateSwing then self:animateSwing() end
end

function Bubble:animateSwing()
    local s = self.animationState
    s.tick = s.tick + 1
    --s.offsetX = 1 * math.cos(s.tick * 0.1)
    s.offsetY = 2 * math.sin(s.tick * 0.08)
end

function Bubble:draw()
    if not self.alive then return end
    local s = self.animationState
    G.printf(
        self.text,
        self.baseXY.x + self.offsetX + s.offsetX - self.w/2,
        self.baseXY.y + self.offsetY + s.offsetY,
        self.w,
        "center")
end



function makeBubbleHero(hero)
    bubble = Bubble:new {
        offsetX = 0,
        offsetY = -2*hero.h,
        baseXY  = hero,
        text    = "you",
    }
    
    table.insert(bubbles, bubble)
end
