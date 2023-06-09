UIState = {}

btn_file_enable = false
btn_edit_enable = false
btn_help_enable = false
btn_export_enable = false

function UIState.load()
    file_btn = suit.Button(lang.editor.btn_file, 0, 0, 100, 30)
    edit_btn = suit.Button(lang.editor.btn_edit, 100, 0, 100, 30)
    help_btn = suit.Button(lang.editor.btn_help, 200, 0, 100, 30)

    placeTileBtn = suit.Button("", 500, 0, 32, 32)
    placeObjectBtn = suit.Button(" ", 532, 0, 32, 32)

    export_btn = suit.Button("Export", 300, 0, 100, 30)

    if placeTileBtn.hit then
        placingMode = "tiles"
    end
    if placeObjectBtn.hit then
        placingMode = "objects"
    end
    if export_btn.hit then
        if btn_export_enable then
            btn_export_enable = false
        else
            btn_export_enable = true
        end
    end

    if file_btn.hovered then
        canPlace = false
    else
        canPlace = true
    end
    if edit_btn.hovered then
        canPlace = false
    else
        canPlace = true
    end
    if help_btn.hovered then
        canPlace = false
    else
        canPlace = true
    end

    if file_btn.hit then
        if btn_file_enable then
            btn_file_enable = false
        else
            btn_file_enable = true
        end
    end
    if edit_btn.hit then
        if btn_edit_enable then
            btn_edit_enable = false
        else
            btn_edit_enable = true
        end
    end
    if help_btn.hit then
        if btn_help_enable then
            btn_help_enable = false
        else
            btn_help_enable = true
        end
    end

    if btn_file_enable then
        save_btn = suit.Button(lang.editor.popup_btn_file_save, 0, 30, 100, 30)
        exit_btn = suit.Button(lang.editor.popup_btn_file_exit, 0, 60, 100, 30)
        if save_btn.hit then
            love.filesystem.write("Maps/" .. lvleditor.mapName .. "/map.json", json.encode(Map))
        end
        if exit_btn.hit then
            gamestate.switch(States.MapManagerState)
        end
        
        if save_btn.hovered then
            canPlace = false
        else
            canPlace = true
        end
    end

    if btn_edit_enable then
        undo_btn = suit.Button(lang.editor.popup_btn_edit_undo, 100, 30, 100, 30)
        redo_btn = suit.Button(lang.editor.popup_btn_edit_redo, 100, 60, 100, 30)
        if showGrid then
            showgrid_btn = suit.Button(lang.editor.popup_btn_edit_showgridON, 100, 90, 100, 30)
        else
            showgrid_btn = suit.Button(lang.editor.popup_btn_edit_showgridOFF, 100, 90, 100, 30)
        end

        if undo_btn.hit then
            if #Map.Tiles > 0 then
                table.insert(trash, 1, Map.Tiles[#Map.Tiles])
                table.remove(Map.Tiles, #Map.Tiles)
            end
        end
        if redo_btn.hit then
            if #trash > 0 then
                table.insert(Map.Tiles, #Map.Tiles, trash[1])
                table.remove(trash, 1)
            end
        end
        if showgrid_btn.hit then
            if showGrid then
                showGrid = false
            else
                showGrid = true
            end
        end

        if undo_btn.hovered then
            canPlace = false
        else
            canPlace = true
        end
        if redo_btn.hovered then
            canPlace = false
        else
            canPlace = true
        end 
        if showgrid_btn.hovered then
            canPlace = false
        else
            canPlace = true
        end
    end
    if btn_export_enable then
        y = 30
        exporters = love.filesystem.getDirectoryItems("Exporters")
        for item = 1, #exporters, 1 do
            if suit.Button(string.gsub(string.gsub(exporters[item], ".plplugin", ""), "-", " "), {id=item}, 300, y, 100, 30).hit then
                print("[EVENT] : Map Exported")
                exporterCode, err = love.filesystem.load("Exporters/" .. exporters[item])
                pcall(exporterCode(), init())
            end
            y = y + 30
        end
    end
end

return UIState