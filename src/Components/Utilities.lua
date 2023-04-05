utilities = {}

function utilities.rgbToColor(r, g, b, a)
    R,G,B,A = love.math.colorToBytes(r, g, b, a)
    return R,G,B,A
end

return utilities