objectsystem = {}

function objectsystem.placeObjectsZone(id, x, y)
    Object = {}
    Object.id = id
    Object.x = x
    Object.y = y
    Object.w = Map.Meta.Map.gridSize
    Object.h = Map.Meta.Map.gridSize
    table.insert(Map.Objects, Object)
end

function objectsystem.removeObjectZone(x, y)
    for _, obj in ipairs(Map.Objects) do
        if obj.x == x then
            if obj.y == y then
                table.insert(trash, 1, Map.Objects[_])
                table.remove(Map.Objects, _)
            end
        end
    end
end

return objectsystem