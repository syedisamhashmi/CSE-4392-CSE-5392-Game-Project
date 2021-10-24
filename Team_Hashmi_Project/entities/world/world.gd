extends TileMap

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("ui_cancel"):
        writeMapData()

func writeMapData():
    var tm = $"."
    var tileInfo = []    
    for position in tm.get_used_cells():
        var tile = getNewTile()
        print(position)
        tile.posX = position.x
        tile.posY = position.y
        tile.index = tm.get_cell(position.x,position.y)
        tile.tileCoordX = tm.get_cell_autotile_coord(position.x, position.y).x
        tile.tileCoordY = tm.get_cell_autotile_coord(position.x, position.y).y
        tileInfo.append(tile)
    LevelData.tiles = tileInfo
    Utils.saveDataToFile(
        "user://level" + str(PlayerData.savedGame.levelNum) + ".dat",
        LevelData, 
        true, 
        false
    )

func getNewTile():
    return {
        posX = null,
        posY = null,
        index = null
    } 
