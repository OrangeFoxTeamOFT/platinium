initilializer = {}

function initilializer.init()
    TilesPath = love.filesystem.getDirectoryItems("Maps/" .. lvleditor.mapName .. "/tiles")

    if #TilesPath ~= 0 then
        for tiles = 1, #TilesPath, 1 do
            table.insert(Tiles, love.graphics.newImage("Maps/" .. lvleditor.mapName .. "/Tiles/" .. TilesPath[tiles]))
        end
    else
        table.insert(Tiles, love.graphics.newImage("resources/images/defaultBlock.png"))
    end
end


return initilializer