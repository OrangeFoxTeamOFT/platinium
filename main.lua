function love.load()
    os = nil
    io = nil
    
    gamestate = require 'libraries.gamestate'
    switch = require 'libraries.switch'
    gui = require 'libraries.gspot'
    suit = require 'libraries.suit'
    lip = require 'libraries.lip'
    json = require 'libraries.json'
    nativefs = require 'libraries.nativefs'
    themes = require 'src.Components.Themes'
    installer = require 'src.Components.Installer'
    love.graphics.gradient = require 'libraries.gradient'
    love.graphics.drawInRect = require 'libraries.draw'

    installer.install()

    Config = {
        editorVersion = "0.0.1",
        language = "english",
        theme = "dark"
    }

    fileSave = love.filesystem.getInfo("prefs.json")
    if fileSave == nil then
        sf = love.filesystem.newFile("prefs.json", "w")
        sf:write(json.encode(Config))
        sf:close()
    end

    States = {
        LevelEditorState = require 'src.States.LevelEditorState',
        MapManagerState = require 'src.States.MapManagerState',
        DebugState = require 'src.States.DebugState'
    }

    gamestate.registerEvents()
    gamestate.switch(States.DebugState)
end

function love.update(elapsed)
    Config = json.decode(love.filesystem.read("prefs.json"))
    lang = lip.load("Languages/" .. Config.language .. ".ini")

    theme.load(Config.theme)
end

function save()
    fileSave = love.filesystem.getInfo("prefs.json")
    if fileSave ~= nil then
        sf = love.filesystem.newFile("prefs.json", "w")
        sf:write(json.encode(Config))
        sf:close()
    end
end
