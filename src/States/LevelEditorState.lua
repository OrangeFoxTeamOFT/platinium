lvleditor = {}

lvleditor.mapName = ""

function lvleditor:enter()
    utilities = require 'src.Components.Utilities'
    Gui = require 'src.States.interface.EditorUIState'
    tilesystem = require 'src.Components.Tiles'
    objectsystem = require 'src.Components.Objects'
    render = require 'src.Components.Render'
    initilializer = require 'src.Components.Init'
    Update = require 'src.Components.Update'

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

    Map = json.decode(love.filesystem.read("Maps/" .. lvleditor.mapName .. "/map.json"))

    initilializer.init()
end

function lvleditor:draw()
    render.draw()
    suit.draw()
    love.graphics.draw(icons.edit, 500, 0)
    love.graphics.draw(icons.object, 532, 0)
end

function lvleditor:update(elapsed)
    Update.update(elapsed)
    Gui.load()
    if suit.anyHovered() then
        canPlace = false
    else
        canPlace = true
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

function isMouseHoverObject(x, y)
    for _, obj in ipairs(Map.Objects) do
        if obj.x == x then
            if obj.y == y then
                return true
            end
        end
    end
end

return lvleditor