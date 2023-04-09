tilesystem = {}

function tilesystem.placeTile(x, y, id)
    Tile = {}
    Tile.id = id
    Tile.x = x
    Tile.y = y
    Tile.w = Map.Meta.Map.gridSize
    Tile.h = Map.Meta.Map.gridSize
    table.insert(Map.Tiles, Tile)
end

function tilesystem.removeTile(x, y)
    for _, Tile in ipairs(Map.Tiles) do
        if Tile.x == x then
            if Tile.y == y then
                table.insert(trash, 1, Map.Tiles[_])
                table.remove(Map.Tiles, _)
            end
        end
    end
end

return tilesystem