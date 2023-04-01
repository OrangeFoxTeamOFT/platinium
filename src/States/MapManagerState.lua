mapmanager = {}

function mapmanager:enter()
    ui = require 'src.States.resources.MapManagerStateUI'
    ui.load()
end

function mapmanager:draw()
    gui:draw()
end

function mapmanager:update(elapsed)
    gui:update(elapsed)
end

function mapmanager:keypressed(k)
    gui:keypress(k)
end

function mapmanager:textinput(k)
    gui:textinput(k)
end

function mapmanager:mousepressed(x, y, button)
    gui:mousepress(x, y, button)
end

function mapmanager:mousereleased(x, y, button)
    gui:mouserelease(x, y, button)
end

function mapmanager:wheelmoved(x, y)
    gui:mousewheel(x, y)
end

return mapmanager