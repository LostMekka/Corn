Bubble = Object:new {
    w       = 100,
    baseXY  = { x = 0, y = 0 },
    offsetX = 0,
    offsetY = 0,
    alive   = true,
    text    = "Bubble",
}

function Bubble:init()
end

function Bubble:update()
    if not self.alive then return end
end

function Bubble:draw()
    if not self.alive then return end
    G.printf(
        self.text,
        self.baseXY.x + self.offsetX - self.w/2,
        self.baseXY.y + self.offsetY,
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
