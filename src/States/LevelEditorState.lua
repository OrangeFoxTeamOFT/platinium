lvleditor = {}

lvleditor.mapName = ""

function lvleditor:enter()
    utilities = require 'src.Components.Utilities'
    Gui = require 'src.States.interface.EditorUIState'

    editorOffsetX = 0   -- x cam
    editorOffsetY = 0   -- y cam
    currentTile = 1 -- current selected block
    currentObjectID = 1 -- Current object zone ID

    Tiles = {}      -- All tile paths
    marker = {x=0, y=0} -- adds a marker to scene
    trash = {}
    Map = {}
    icons = {
        edit = love.graphics.newImage("resources/images/GUI/edit_icon.png"),
        object = love.graphics.newImage("resources/images/GUI/object_icon.png")
    }

    showGrid = true
    canPlace = true
    canMove = true

    placingMode = "tiles"

    TilesPath = love.filesystem.getDirectoryItems("Maps/" .. lvleditor.mapName .. "/tiles")
    Map = json.decode(love.filesystem.read("Maps/" .. lvleditor.mapName .. "/map.json"))

    if #TilesPath ~= 0 then
        for tiles = 1, #TilesPath, 1 do
            table.insert(Tiles, love.graphics.newImage("Maps/" .. lvleditor.mapName .. "/Tiles/" .. TilesPath[tiles]))
        end
    else
        table.insert(Tiles, love.graphics.newImage("resources/images/defaultBlock.png"))
    end
end

function lvleditor:draw()
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

    suit.draw()
    love.graphics.draw(icons.edit, 500, 0)
    love.graphics.draw(icons.object, 532, 0)
end

function lvleditor:update(elapsed)
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
                    placeTile(marker.x + editorOffsetX * Map.Meta.Map.gridSize, marker.y + editorOffsetY * Map.Meta.Map.gridSize, currentTile)
                end
            end
            if isMouseHoverBlock(marker.x + editorOffsetX * Map.Meta.Map.gridSize, marker.y + editorOffsetY * Map.Meta.Map.gridSize) then
                if love.mouse.isDown(2) then
                    removeTile(marker.x + editorOffsetX * Map.Meta.Map.gridSize, marker.y + editorOffsetY * Map.Meta.Map.gridSize)
                end
            end
        end
        if placingMode == "objects" then
            if not isMouseHoverObject(marker.x + editorOffsetX * Map.Meta.Map.gridSize, marker.y + editorOffsetY * Map.Meta.Map.gridSize) then
                if love.mouse.isDown(1) then
                    placeObjectsZone(currentObjectID, marker.x + editorOffsetX * Map.Meta.Map.gridSize, marker.y + editorOffsetY * Map.Meta.Map.gridSize)
                end
            end
            if isMouseHoverObject(marker.x + editorOffsetX * Map.Meta.Map.gridSize, marker.y + editorOffsetY * Map.Meta.Map.gridSize) then
                if love.mouse.isDown(2) then
                    removeObjectZone(marker.x + editorOffsetX * Map.Meta.Map.gridSize, marker.y + editorOffsetY * Map.Meta.Map.gridSize)
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

    Gui.load()

    if suit.anyHovered() then
        canPlace = false
    else
        canPlace = true
    end
    if suit.anyActive() then
        canMove = false
    else
        canMove = true
    end
end

function lvleditor:keypressed(k)
    -- undo and redo
    if k == "z" then
        if #Map.Tiles > 0 then
            table.insert(trash, 1, Map.Tiles[#Map.Tiles])
            table.remove(Map.Tiles, #Map.Tiles)
        end
    end
    if k == "y" then
        if #trash > 0 then
            table.insert(Map.Tiles, #Map.Tiles, trash[1])
            table.remove(trash, 1)
        end
    end
end

function lvleditor:wheelmoved(x, y)
    if y > 0 then
        if placingMode == "tiles" then
            currentTile = currentTile + 1
        end
        if placingMode == "objects" then
            currentObjectID = currentObjectID + 1
        end
    end
    if y < 0 then
        if placingMode == "tiles" then
            currentTile = currentTile - 1
        end
        if placingMode == "objects" then
            currentObjectID = currentObjectID - 1
        end
    end
end

-----------------------------------------------------

function isMouseHoverBlock(x, y)
    for _, block in ipairs(Map.Tiles) do
        if block.x == x then
            if block.y == y then
                return true
            end
        end
    end
end
function placeTile(x, y, id)
    Tile = {}
    Tile.id = id
    Tile.x = x
    Tile.y = y
    Tile.w = Map.Meta.Map.gridSize
    Tile.h = Map.Meta.Map.gridSize
    table.insert(Map.Tiles, Tile)
end

function removeTile(x, y)
    for _, Tile in ipairs(Map.Tiles) do
        if Tile.x == x then
            if Tile.y == y then
                table.insert(trash, 1, Map.Tiles[_])
                table.remove(Map.Tiles, _)
            end
        end
    end
end

function isMouseHoverObject(x, y)
    for _, obj in ipairs(Map.Objects) do
        if obj.x == x then
            if obj.y == y then
                return true
            end
        end
    end
end

function placeObjectsZone(id, x, y)
    Object = {}
    Object.id = id
    Object.x = x
    Object.y = y
    Object.w = Map.Meta.Map.gridSize
    Object.h = Map.Meta.Map.gridSize
    table.insert(Map.Objects, Object)
end

function removeObjectZone(x, y)
    for _, obj in ipairs(Map.Objects) do
        if obj.x == x then
            if obj.y == y then
                table.insert(trash, 1, Map.Objects[_])
                table.remove(Map.Objects, _)
            end
        end
    end
end

return lvleditor