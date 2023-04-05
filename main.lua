function love.load()
    gamestate = require 'libraries.gamestate'
    switch = require 'libraries.switch'
    gui = require 'libraries.gspot'
    suit = require 'libraries.suit'
    lip = require 'libraries.lip'
    json = require 'libraries.json'
    nativefs = require 'libraries.nativefs'
    themes = require 'src.Components.Themes'
    installer = require 'src.Components.Installer'

    installer.install()

    Config = {
        editorVersion = "0.0.1",
        language = "en",
        theme = "dark"
    }

    fileSave = love.filesystem.getInfo("prefs.json")
    if fileSave == nil then
        sf = love.filesystem.newFile("prefs.json", "w")
        sf:write(json.encode(Config))
        sf:close()
    end

    Config = json.decode(love.filesystem.read("prefs.json"))
    lang = lip.load("Languages/" .. Config.language .. ".ini")

    theme.load(Config.theme)

    States = {
        LevelEditorState = require 'src.States.LevelEditorState',
        MapManagerState = require 'src.States.MapManagerState'
    }

    gamestate.registerEvents()
    gamestate.switch(States.MapManagerState)
end

function save()
    fileSave = love.filesystem.getInfo("prefs.json")
    if fileSave ~= nil then
        sf = love.filesystem.newFile("prefs.json", "w")
        sf:write(json.encode(Config))
        sf:close()
    end
end
