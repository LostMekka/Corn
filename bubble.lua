Bubble = Object:new {
    x = 0,
    y = 0,
    w = 100,
    alive = true,
    text = "Bubble",
}

function Bubble:init()
end

function Bubble:update()
    if not self.alive then return end
end

function Bubble:draw()
    if not self.alive then return end
    G.printf(self.text, self.x - self.w/2, self.y, self.w, "center")
end



function makeBubbleHero(hero)
    bubble = Bubble:new {
        x = hero.x,
        y = hero.y - hero.h*2,
        text = "you",
    }
    
    table.insert(bubbles, bubble)
end
