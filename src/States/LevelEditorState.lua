lvleditor = {}

function lvleditor:enter()
    Gui = require 'src.States.resources.EditorUIState'
    Gui.load()

    editorOffsetX = 0   -- x cam
    editorOffsetY = 0   -- y cam
    marker = {x=0, y=0} -- adds a marker to scene
    trash = {}
end

function lvleditor:draw()
    gui:draw()
    
end

function lvleditor:update(elapsed)
    gui:update(elapsed)
    marker.x = math.floor(love.mouse.getX() / 32) * 32
    marker.y = math.floor(love.mouse.getY() / 32) * 32
end

function lvleditor:keypressed(k)
    -- undo and redo
    if key == "z" then
        if #MapSettings.Blocks > 0 then
            table.insert(trash, 1, MapSettings.Blocks[#MapSettings.Blocks])
            table.remove(MapSettings.Blocks, #MapSettings.Blocks)
        end
    end
    if key == "y" then
        if #trash > 0 and #trash < 500  then
            table.insert(MapSettings.Blocks, #MapSettings.Blocks, trash[1])
            table.remove(trash, 1)
        end
    end
end

function lvleditor:mousepressed(x, y, button)
    gui:mousepress(x, y, button)
end

function lvleditor:mousereleased(x, y, button)
    gui:mouserelease(x, y, button)
end

return lvleditor