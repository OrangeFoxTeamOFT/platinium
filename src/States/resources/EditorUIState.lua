UIState = {}

function UIState.load()
    local xb = 250
    --local mapName = gui:input("Map name", {x=80, y=10, w=96, h=24}, nil, "level")
    local clearButton = gui:button("Clear", {x=180, y=10, w=96, h=24})
    local saveButton = gui:button("save", {x=10, y=50, w=96, h=24})
    local loadButton = gui:button("load", {x=111, y=50, w=96, h=24})
    local trashButton = gui:button("", {x=231, y=50, w=32, h=32})
    local undoButton = gui:button("Undo", {x=266, y=50, w=32, h=32})
    local redoButton = gui:button("Redo", {x=301, y=50, w=32, h=32})
    
    function clearButton.enter(this)
        canPlace = false
        canMove = false
    end
    function clearButton.leave(this)
        canPlace = true
        canMove = true
    end
    function saveButton.enter(this)
        canPlace = false
        canMove = false
    end
    function saveButton.leave(this)
        canPlace = true
        canMove = true
    end
    function loadButton.enter(this)
        canPlace = false
        canMove = false
    end
    function loadButton.leave(this)
        canPlace = true
        canMove = true
    end

    function trashButton.enter(this)
        canPlace = false
        canMove = false
    end

    function trashButton.leave(this)
        canPlace = true
        canMove = true
    end

    function undoButton.enter(this)
        canPlace = false
        canMove = false
    end

    function undoButton.leave(this)
        canPlace = true
        canMove = true
    end

    function redoButton.enter(this)
        canPlace = false
        canMove = false
    end

    function redoButton.leave(this)
        canPlace = true
        canMove = true
    end

    function trashButton.click(this, x, y, button)
        trash = {}
        print("[EVENT] : Trash cleared")
    end

    function redoButton.click(this, x, y, button)
        if #trash > 0 and #trash < 500  then
            table.insert(MapSettings.Blocks, #MapSettings.Blocks, trash[1])
            table.remove(trash, 1)
        end
    end

    function undoButton.click(this, x, y, button)
        if #MapSettings.Blocks > 0 then
            table.insert(trash, 1, MapSettings.Blocks[#MapSettings.Blocks])
            table.remove(MapSettings.Blocks, #MapSettings.Blocks)
        end
    end

    function saveButton.click(this, x, y, button)
        if mapName.value ~= nil then
            local mapdata = json.encode(MapSettings)
            local mapFile = love.filesystem.newFile(mapName.value .. ".lvl", "w")
            print("[EVENT] : File saved")
            mapFile:write(mapdata)
            mapFile:close()
        end
    end
    function clearButton.click(this, x, y, button)
        MapSettings.Blocks = {}
        MapSettings.endX = 640
    end
    function loadButton.click(this, x, y, button)
        if mapName.value ~= nil then
            print(mapName.value)
            print("[EVENT] : File loaded")
            mapdata = love.filesystem.read("resources/data/maps/" .. mapName.value .. "/map.lvl")
            MapSettings = json.decode(mapdata)
        end
    end

    
    --[[
    tileButton = {}
    for i = 1, #tileQuads, 1 do
        xb = xb + 36
        tileButton = gui:button("", {xb, y=12, w=32, h=32})
        tileButton:setimage("resources/images/icons/atlas_sheet/tileicon" .. i .. ".png")
        function tileButton.click(this, x, y)
            currentBlock = i
        end
        function tileButton.enter(this)
            canPlace = false
        end
        function tileButton.leave(this)
            canPlace = true
        end
        table.insert(tileButton, tileButton)
    end
    ]]
end

return UIState