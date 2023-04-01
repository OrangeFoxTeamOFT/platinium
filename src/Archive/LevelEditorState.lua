leveleditor = {}

function leveleditor:enter()
    UI = require 'src.states.resources.LevelEditorUIState'
    atlasparser = require 'src.components.AtlasParser'
    conductor = require 'src.components.Conductor'
    utilities = require 'src.Utilities'

    quicksand = love.graphics.newFont("resources/fonts/quicksand-light.ttf", 15)
    love.graphics.setFont(quicksand)

    editorOffsetX = 0   -- x cam
    editorOffsetY = 0   -- y cam
    marker = {x=0, y=0} -- adds a marker to scene

    tileImage, tileQuads = atlasparser.getQuads("atlas_prototyping")
    endingBlock = love.graphics.newImage("resources/images/endingBlock.png")
    currentBlock = 1
    placingEnding = false
    canPlace = true
    canMove = true
    EndPoint = {x=640, y=480}

    -- load all UI
    UI.load()

    trash = {}  -- used to redo and undo
    MapSettings = {
        Blocks = {},
        endX = 0
    }

    -- updates the presence
    presence.state = "editing a level"
    presence.details = "in editor mode"
    discordRPC.updatePresence(presence)
end

function leveleditor:draw()
    love.graphics.setColor(1,1,1)
    -- render blocks
    for k, Block in ipairs(MapSettings.Blocks) do
        love.graphics.draw(tileImage, tileQuads[Block.id], Block.x - (editorOffsetX * 32), Block.y - (editorOffsetY * 32))
    end

    -- end point marker --
    love.graphics.rectangle("line", (MapSettings.endX + 16) - editorOffsetX * 32, 0, 1, love.graphics.getHeight())
    love.graphics.draw(endingBlock, MapSettings.endX - editorOffsetX * 32, math.floor((love.graphics.getHeight() / 2) / 32) * 32)

    -- grid --
    for x = 0, love.graphics.getWidth(), 32 do
        for y = 0, love.graphics.getHeight(), 32 do
            love.graphics.setColor(utilities.rgbToColor(255, 255, 255, 40))
            love.graphics.rectangle("line", x, y, 32, 32)
            love.graphics.setColor(utilities.rgbToColor(255, 255, 255, 255))
        end
    end

    -- mode --
    if not placingEnding then
        love.graphics.print("[Mode] : Editing Blocks", 10, 150)
    else
        love.graphics.print("[Mode] : Editing Ending point", 10, 190)
    end
    love.graphics.print("[OffsetX] : " .. editorOffsetX, 10, 240)
    love.graphics.print("[OffsetY] : " .. editorOffsetY, 10, 280)
    love.graphics.print("[End position]" .. tostring(MapSettings.endX), 10, 170)

    -- render the tiles -- 
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(tileImage, tileQuads[currentBlock], 10, 90, 0, 1.5, 1.5)

    -- cursor --
    love.graphics.setColor(utilities.rgbToColor(255, 255, 0, 255))
    love.graphics.rectangle("line", marker.x, marker.y, 32, 32)
    love.graphics.setColor(utilities.rgbToColor(255, 255, 255, 255))

    gui:draw()
end

function leveleditor:update(elapsed)
    marker.x = math.floor(love.mouse.getX() / 32) * 32
    marker.y = math.floor(love.mouse.getY() / 32) * 32

    if canPlace then
        if not isMouseHoverBlock(marker.x + editorOffsetX * 32, marker.y + editorOffsetY * 32) then
            if not placingEnding then
                if love.mouse.isDown(1) then
                    placeBlock(marker.x + editorOffsetX * 32, marker.y + editorOffsetY * 32, currentBlock)
                end
            else
                if love.mouse.isDown(1) then
                    placeEnd(marker.x + editorOffsetX * 32, marker.y + editorOffsetY * 32, currentBlock)
                end
            end
        end
        if isMouseHoverBlock(marker.x + editorOffsetX * 32, marker.y + editorOffsetY * 32) then
            if love.mouse.isDown(2) then
                removeBlock(marker.x + editorOffsetX * 32, marker.y + editorOffsetY * 32)
            end
        end
    end

    if currentBlock < 1 then
        currentBlock = 1
    end
    if currentBlock > #tileQuads then
        currentBlock = #tileQuads
    end

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

    gui:update(elapsed)
end

function leveleditor:keypressed (key, code)
	if gui.focus then
		gui:keypress(key)
        canMove = false
    else
        canMove = true
    end
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
    if key == "tab" then
        if placingEnding then
            placingEnding =  false
        else
            placingEnding = true
        end
    end
    if key == "escape" then
        gamestate.switch(states.MenuState)
    end
end

function leveleditor:textinput(key)
	if gui.focus then
		gui:textinput(key)
	end
end

function leveleditor:mousepressed(x, y, button)
	gui:mousepress(x, y, button)
end

function leveleditor:mousereleased(x, y, button)
	gui:mouserelease(x, y, button)
end

function leveleditor:wheelmoved(x, y)
    if y > 0 then
        currentBlock = currentBlock + 1
    end
    if y < 0 then
        currentBlock = currentBlock - 1
    end
end
--------------------------------------------------

function placeBlock(x, y, id)
    Block = {}
    Block.x = x
    Block.y = y
    Block.w = 32
    Block.h = 32
    Block.id = id
    table.insert(MapSettings.Blocks, Block)
    print("[EVENT] : Block placed")
end

function removeBlock(x, y)
    for _, block in ipairs(MapSettings.Blocks) do
        if block.x == x then
            if block.y == y then
                print("[EVENT] : Block removed")
                table.insert(trash, 1, MapSettings.Blocks[_])
                table.remove(MapSettings.Blocks, _)
            end
        end
    end
end

function placeEnd(x, y)
    EndPoint.x = x
    MapSettings.endX = x
    EndPoint.y = y
end

function isMouseHoverBlock(x, y)
    for _, block in ipairs(MapSettings.Blocks) do
        if block.x == x then
            if block.y == y then
                print("[EVENT] : Is hover")
                return true
            end
        end
    end
end

return leveleditor