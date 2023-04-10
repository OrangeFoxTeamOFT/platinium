debugstate = {}

function debugstate:enter()
    Gradient = love.graphics.gradient({direction = "horizontal",{0.5, 0.5, 0.5},{1, 1, 1}})
end

function debugstate:draw()
    love.graphics.drawInRect(Gradient, 0, 0, 120, 120)
end

function debugstate:update(elapsed)
    
end

return debugstate