theme = {}

function theme.load(filename)
    themeData = json.decode(love.filesystem.read("Themes/" .. filename .. ".json"))
    suit.theme.color.normal.bg[1] = themeData.normal.bg[1] / 255
    suit.theme.color.normal.bg[2] = themeData.normal.bg[2] / 255
    suit.theme.color.normal.bg[3] = themeData.normal.bg[3] / 255

    suit.theme.color.normal.fg[1] = themeData.normal.fg[1] / 255
    suit.theme.color.normal.fg[2] = themeData.normal.fg[2] / 255
    suit.theme.color.normal.fg[3] = themeData.normal.fg[3] / 255

    suit.theme.color.hovered.bg[1] = themeData.hovered.bg[1] / 255
    suit.theme.color.hovered.bg[2] = themeData.hovered.bg[2] / 255
    suit.theme.color.hovered.bg[3] = themeData.hovered.bg[3] / 255

    suit.theme.color.hovered.fg[1] = themeData.hovered.fg[1] / 255
    suit.theme.color.hovered.fg[2] = themeData.hovered.fg[2] / 255
    suit.theme.color.hovered.fg[3] = themeData.hovered.fg[3] / 255

    suit.theme.color.active.bg[1] = themeData.active.bg[1] / 255
    suit.theme.color.active.bg[2] = themeData.active.bg[2] / 255
    suit.theme.color.active.bg[3] = themeData.active.bg[3] / 255

    suit.theme.color.active.fg[1] = themeData.active.fg[1] / 255
    suit.theme.color.active.fg[2] = themeData.active.fg[2] / 255
    suit.theme.color.active.fg[3] = themeData.active.fg[3] / 255
end

return theme