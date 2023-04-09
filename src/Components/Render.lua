render = {}

function render.draw()
    love.graphics.setBackgroundColor(
        Map.Meta.Map.backgroundColor.r / 255, 
        Map.Meta.Map.backgroundColor.g / 255, 
        Map.Meta.Map.backgroundColor.b / 255
    )
    for _, tile in ipairs(Map.Tiles) do
        love.graphics.draw(Tiles[tile.id], tile.x - editorOffsetX * Map.Meta.Map.gridSize, tile.y - editorOffsetY * Map.Meta.Map.gridSize)
    end

    for _, Object in ipairs(Map.Objects) do
        love.graphics.rectangle("line", Object.x - editorOffsetX * Map.Meta.Map.gridSize, Object.y - editorOffsetY * Map.Meta.Map.gridSize, Object.w, Object.h)
        love.graphics.setColor(1,1,1,0.4)
        love.graphics.rectangle("fill", Object.x - editorOffsetX * Map.Meta.Map.gridSize, Object.y - editorOffsetY * Map.Meta.Map.gridSize, Object.w, Object.h)
        love.graphics.setColor(1,1,1,1)
        love.graphics.print(Object.id, Object.x + Object.w / 2 - 7 - editorOffsetX * Map.Meta.Map.gridSize, Object.y + Object.h / 2 - 7 - editorOffsetY * Map.Meta.Map.gridSize)
    end

    love.graphics.setColor(
        Map.Meta.Map.gridColor.r / 255, 
        Map.Meta.Map.gridColor.g / 255, 
        Map.Meta.Map.gridColor.b / 255, 
        Map.Meta.Map.gridColor.a / 255
    )
    if showGrid then
        for x = 0, love.graphics.getWidth(), Map.Meta.Map.gridSize do
            for y = 0, love.graphics.getHeight(), Map.Meta.Map.gridSize do
                love.graphics.rectangle("line", x, y, Map.Meta.Map.gridSize, Map.Meta.Map.gridSize)
            end
        end
    end
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle("line", marker.x, marker.y, Map.Meta.Map.gridSize, Map.Meta.Map.gridSize)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.draw(Tiles[currentTile], 20, 60)
    love.graphics.print("Current Object ID : [" .. currentObjectID .. "]", 10, 100)
    love.graphics.print("Current Mode : [" .. placingMode .. "]", 10, 115)
    love.graphics.rectangle("line", marker.x, marker.y, Map.Meta.Map.gridSize, Map.Meta.Map.gridSize)

end

return render