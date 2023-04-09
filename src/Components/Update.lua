Update = {}

function Update.update(elapsed)
    -- update marker to snap at grid --
    marker.x = math.floor(love.mouse.getX() / Map.Meta.Map.gridSize) * Map.Meta.Map.gridSize
    marker.y = math.floor(love.mouse.getY() / Map.Meta.Map.gridSize) * Map.Meta.Map.gridSize

    -- camera control --
    if canMove then
        if love.keyboard.isDown("a") then
            editorOffsetX = editorOffsetX - 1
        end
        if love.keyboard.isDown("d") then
            editorOffsetX = editorOffsetX + 1
        end
        if love.keyboard.isDown("w") then
            editorOffsetY = editorOffsetY - 1
        end
        if love.keyboard.isDown("s") then
            editorOffsetY = editorOffsetY + 1
        end
    end

    -- control place and remove blocks --
    if canPlace then
        if placingMode == "tiles" then
            if not isMouseHoverBlock(marker.x + editorOffsetX * Map.Meta.Map.gridSize, marker.y + editorOffsetY * Map.Meta.Map.gridSize) then
                if love.mouse.isDown(1) then
                    tilesystem.placeTile(marker.x + editorOffsetX * Map.Meta.Map.gridSize, marker.y + editorOffsetY * Map.Meta.Map.gridSize, currentTile)
                end
            end
            if isMouseHoverBlock(marker.x + editorOffsetX * Map.Meta.Map.gridSize, marker.y + editorOffsetY * Map.Meta.Map.gridSize) then
                if love.mouse.isDown(2) then
                    tilesystem.removeTile(marker.x + editorOffsetX * Map.Meta.Map.gridSize, marker.y + editorOffsetY * Map.Meta.Map.gridSize)
                end
            end
        end
        if placingMode == "objects" then
            if not isMouseHoverObject(marker.x + editorOffsetX * Map.Meta.Map.gridSize, marker.y + editorOffsetY * Map.Meta.Map.gridSize) then
                if love.mouse.isDown(1) then
                    objectsystem.placeObjectsZone(currentObjectID, marker.x + editorOffsetX * Map.Meta.Map.gridSize, marker.y + editorOffsetY * Map.Meta.Map.gridSize)
                end
            end
            if isMouseHoverObject(marker.x + editorOffsetX * Map.Meta.Map.gridSize, marker.y + editorOffsetY * Map.Meta.Map.gridSize) then
                if love.mouse.isDown(2) then
                    objectsystem.removeObjectZone(marker.x + editorOffsetX * Map.Meta.Map.gridSize, marker.y + editorOffsetY * Map.Meta.Map.gridSize)
                end
            end
        end
    end

    if currentTile < 1 then
        currentTile = 1
    end
    if currentTile > #Tiles then
        currentTile = #Tiles
    end

    if currentObjectID < 1 then
        currentObjectID = 1
    end
end

return Update