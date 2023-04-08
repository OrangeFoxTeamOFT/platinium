mapmanager = {}

function mapmanager:enter()
    ui = require 'src.States.interface.MapManagerStateUI'
    bg = love.graphics.newImage("background.png")
    logo = love.graphics.newImage("resources/images/Assets/platiniumLogo.png")
end

function mapmanager:draw()
    love.graphics.draw(bg, 0, 0)
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.draw(logo, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, 0.8, 0.8, logo:getWidth() / 2, logo:getHeight() / 2)
    love.graphics.setColor(1, 1, 1, 1)
    suit.draw()
end

function mapmanager:update(elapsed)
    ui.load()
end

function mapmanager:keypressed(k)
    suit.keypressed(k)
end

function mapmanager:textedited(t, s, l)
    suit.textedited(t, s, l)
end

function mapmanager:textinput(k)
    suit.textinput(k)
end

return mapmanager