function love.load()
    gamestate = require 'libraries.gamestate'
    switch = require 'libraries.switch'
    gui = require 'libraries.gspot'
    json = require 'libraries.json'
    nativefs = require 'libraries.nativefs'

    love.filesystem.createDirectory("Maps")

    States = {
        LevelEditorState = require 'src.States.LevelEditorState',
        MapManagerState = require 'src.States.MapManagerState'
    }

    gamestate.registerEvents()
    gamestate.switch(States.MapManagerState)

end

function love.draw()
    
end

function love.update(dt)
    
end
