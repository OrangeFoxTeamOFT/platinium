installer = {}

function installer.install()
    love.filesystem.createDirectory("Maps")
    love.filesystem.createDirectory("Themes")
    love.filesystem.createDirectory("Languages")
    love.filesystem.createDirectory("Exporters")

    exportScripts = love.filesystem.getDirectoryItems("src/Components/Export")
    for item = 1, #exportScripts, 1 do
        themeFile = love.filesystem.newFile("Exporters/" .. exportScripts[item], "w")
        themeFile:write(love.filesystem.read("src/Components/Export/" .. exportScripts[item]))
        themeFile:close()
    end

    image = love.filesystem.read("resources/images/GUI/background.png")
    ImgFile = love.filesystem.newFile("background.png", "w")
    ImgFile:write(image)
    ImgFile:close()

    -- install local themes on the player machine --
    themes = love.filesystem.getDirectoryItems("resources/data/themes")
    for item = 1, #themes, 1 do
        themeFile = love.filesystem.newFile("Themes/" .. themes[item], "w")
        themeFile:write(love.filesystem.read("resources/data/themes/" .. themes[item]))
        themeFile:close()
    end

    -- install translations on local machine --
    langfiles = love.filesystem.getDirectoryItems("resources/data/translations")
    for item = 1, #langfiles, 1 do
        langfile = love.filesystem.newFile("Languages/" .. langfiles[item], "w")
        langfile:write(love.filesystem.read("resources/data/translations/" .. langfiles[item]))
        langfile:close()
    end
end

return installer