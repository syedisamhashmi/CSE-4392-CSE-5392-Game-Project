extends TileMap

var breakableTiles = [
    # This is found using the index, coordX, and coordY that is printed 
    "100" 
]

func on_tile_hit(proj, collision_position):
    if proj.velocity.x > 0:
        collision_position.x += 16
    if proj.velocity.x < 0:
        collision_position.x -= 16
    var local_position = to_local(collision_position)
    var tilePosition: Vector2 = world_to_map(local_position)
    print (tilePosition)   
    var index      = get_cell(int(tilePosition.x),int(tilePosition.y))
    var tileCoordX = get_cell_autotile_coord(int(tilePosition.x), int(tilePosition.y)).x
    var tileCoordY = get_cell_autotile_coord(int(tilePosition.x), int(tilePosition.y)).y
    print("Tile has index,X,Y: ", index, tileCoordX, tileCoordY)
    if index != -1 and tileCoordX != -1 and tileCoordY != -1:
        var toFind = String(index) + String(tileCoordX) + String(tileCoordY)
        var found = breakableTiles.find(toFind)
        if found > -1:
            set_cell(
                    # X coord in tilemap
                    int(tilePosition.x),
                    # Y coord in tilemap
                    int(tilePosition.y),
                    # Which TileSet to use
                    -1,
                    # Some transform options
                    false, false, false,
                    # Which Tile in the tileset to use
                    Vector2(-1, -1)
                )
