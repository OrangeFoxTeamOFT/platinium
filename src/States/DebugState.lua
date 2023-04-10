debugstate = {}

function debugstate:enter()
    gradient = love.graphics.gradient({direction = "horizontal",{0, 0, 0.5},{1, 1, 1}})
end

function debugstate:draw()
    love.graphics.drawInRect(gradient, 0, 0, 120, 120)
end

function debugstate:update(elapsed)
    
end

return debugstate