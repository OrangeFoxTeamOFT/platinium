mapui = {}

mapName_input = {text = "map1"}
gridSize_input = {text = "32"}
mapName_input_load = {text = "map1"}
gridColor_r = {text = "255"}
gridColor_g = {text = "255"}
gridColor_b = {text = "255"}
gridColor_a = {text = "100"}
bgColor_r = {text = "0"}
bgColor_g = {text = "0"}
bgColor_b = {text = "0"}

MapData = {
    Meta = {
        mapname = mapName_input.text,
        editorVersion = "0.0.1",
        Map = {
            backgroundColor = {
                r = tonumber(bgColor_r.text),
                g = tonumber(bgColor_g.text),
                b = tonumber(bgColor_b.text)
            },
            gridSize = tonumber(gridSize_input.text),
            gridColor = {
                r = tonumber(gridColor_r.text),
                g = tonumber(gridColor_g.text),
                b = tonumber(gridColor_b.text),
                a = tonumber(gridColor_a.text)
            }
        },
    },
    Tiles = {},
    Objects = {},
}

showCreateMapItems = false
showLoadMapItems = false
showLanguageItems = false
showThemesItems = false

function mapui.load()
    createButton = suit.Button(lang.mapmanager.btn_create, 20, 20, 120, 30)
    loadButton = suit.Button(lang.mapmanager.btn_load, 150, 20, 120, 30)
    languageButton = suit.Button(lang.mapmanager.btn_language, love.graphics.getWidth() - 240, 0, 120, 30)
    themesButton = suit.Button(lang.mapmanager.btn_themes, love.graphics.getWidth() - 120, 0, 120, 30)
    if createButton.hit then
        showCreateMapItems = true
        showLoadMapItems = false
    end
    if loadButton.hit then
        showLoadMapItems = true
        showCreateMapItems = false
    end
    if languageButton.hit then
        if showLanguageItems then
            showLanguageItems = false
        else
            showLanguageItems = true
        end
    end
    if themesButton.hit then
        if showThemesItems then
            showThemesItems = false
        else
            showThemesItems = true
        end
    end

    if showCreateMapItems then
        suit.Label(lang.mapmanager.lbl_mapname, 20, 100)
        suit.Input(mapName_input, 20, 130, 120, 30)
        suit.Label(lang.mapmanager.lbl_gridsize, 160, 100)
        suit.Input(gridSize_input, 160, 130, 40, 30)
        suit.Label(lang.mapmanager.lbl_gridcolor, 20, 180)
        suit.Input(gridColor_r, 20, 200, 30, 30)
        suit.Input(gridColor_g, 50, 200, 30, 30)
        suit.Input(gridColor_b, 80, 200, 30, 30)
        suit.Input(gridColor_a, 110, 200, 30, 30)
        suit.Label(lang.mapmanager.lbl_bgcolor, 20, 240)
        suit.Input(bgColor_r, 20, 270, 30, 30)
        suit.Input(bgColor_g, 50, 270, 30, 30)
        suit.Input(bgColor_b, 80, 270, 30, 30)
        popup_cancelButton = suit.Button(lang.mapmanager.popup_btn_cancel, 20, 330, 70, 30)
        popup_createButton = suit.Button(lang.mapmanager.popup_btn_create, 100, 330, 70, 30)
        if popup_cancelButton.hit then
            showCreateMapItems = false
        end
        if popup_createButton.hit then
            if mapName_input.text ~= "" then
                if gridSize_input.text ~= "" then
                    if type(tonumber(gridSize_input.text)) == "number" then
                        love.filesystem.createDirectory("Maps/" .. mapName_input.text)
                        love.filesystem.createDirectory("Maps/" .. mapName_input.text .. "/tiles")
                        mapfile = love.filesystem.newFile("Maps/" .. mapName_input.text .. "/map.json", "w")
                        mapfile:write(json.encode(MapData))
                        mapfile:close()
                        States.LevelEditorState.mapName = mapName_input.text
                        gamestate.switch(States.LevelEditorState)
                    end
                end
            end
        end
    end
    if showLoadMapItems then
        suit.Label(lang.mapmanager.lbl_mapload, 20, 100)
        suit.Input(mapName_input_load, 20, 130, 120, 30)
        popup_cancelButton = suit.Button(lang.mapmanager.popup_btn_cancel, 20, 180, 70, 30)
        popup_loadButton = suit.Button(lang.mapmanager.popup_btn_load, 100, 180, 70, 30)
        if popup_cancelButton.hit then
            showLoadMapItems = false
        end
        if popup_loadButton.hit then
            if mapName_input_load.text ~= "" then
                folderExist = love.filesystem.getInfo("Maps/" .. mapName_input_load.text)
                if folderExist ~= nil then
                    States.LevelEditorState.mapName = mapName_input_load.text
                    gamestate.switch(States.LevelEditorState)
                else
                    suit.Label("[ERROR] : Failed to load | Invalid map", 20, 210)
                end
            end
        end
    end
    if showLanguageItems then
        Languages = love.filesystem.getDirectoryItems("Languages")
        y = 30
        for items = 1, #Languages, 1 do
            if suit.Button(string.gsub(Languages[items], ".ini", ""), love.graphics.getWidth() - 240, y, 120, 30).hit then
                Config.language = string.gsub(Languages[items], ".ini", "")
                save()
            end
            y = y + 30
        end
    end
    if showThemesItems then
        Themes = love.filesystem.getDirectoryItems("Themes")
        y = 30
        for items = 1, #Themes, 1 do
            if suit.Button(string.gsub(Themes[items], ".json", ""), love.graphics.getWidth() - 120, y, 120, 30).hit then
                Config.theme = string.gsub(Themes[items], ".json", "")
                save()
            end
            y = y + 30
        end
    end
end

return mapui