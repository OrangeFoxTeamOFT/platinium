mapui = {}

function mapui.load()
    ui = {
        createButton = gui:button("confirm", {
            x=love.graphics.getWidth() / 2, y=love.graphics.getHeight() / 2,
            w=128, h=24
        }),
        mapNameInput = gui:input("map name", {
            x=love.graphics.getWidth() / 2, y=love.graphics.getHeight() / 2 - 64,w=128, h=24
        }),
    }

    function ui.createButton.click(this, x, y, button)
        if ui.mapNameInput.value ~= "" then
            love.filesystem.createDirectory("Maps/" .. ui.mapNameInput.value)
            love.filesystem.createDirectory("Maps/" .. ui.mapNameInput.value .. "/Tiles")
            gamestate.switch(States.LevelEditorState)
        end
    end

end

return mapui