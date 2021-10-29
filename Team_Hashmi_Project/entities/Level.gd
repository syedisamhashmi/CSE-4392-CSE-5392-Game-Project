extends Node2D

export var IS_BUILDING = true

var TYPE_PICKUP_BANANA_THROW: String = "banana-throw-pickup"

var TYPE_ENEMY_BIG_ONION    : String = "big-onion"
var TYPE_ENEMY_PINEAPPLE    : String = "pineapple"
var TYPE_ENEMY_RADDISH      : String = "raddish"


var BANANA_THROW_PICKUP = preload("res://entities/pickup_items/banana_item.tscn")
var ENEMY_BIG_ONION     = preload("res://entities/enemies/big_onion/big_onion.tscn")
var ENEMY_PINEAPPLE     = preload("res://entities/enemies/pineapple/pineapple.tscn")
var ENEMY_RADDISH       = preload("res://entities/enemies/raddish/raddish.tscn")

func _enter_tree() -> void:
    # warning-ignore:return_value_discarded
    Signals.connect("player_health_changed", self, "playerHealthChanged")
    # warning-ignore:return_value_discarded
    Signals.connect("player_weapon_changed", self, "playerWeaponChanged")
    # warning-ignore:return_value_discarded
    Signals.connect("player_ammo_changed", self, "playerAmmoChanged")

func _ready() -> void:
    readMapData()


func readMapData():
    if IS_BUILDING:
        return
    var levelData: LevelData = Utils.loadDataFromFile(
        "res://levels/level" + str(PlayerData.savedGame.levelNum) + ".tres", 
        LevelData, 
        true, # As instance object
        false # Unencrypted
    )
    var backgroundLayer = $ParallaxBackground/ParallaxLayer
    backgroundLayer.motion_scale.x = levelData.backgroundMotionScaleX
    backgroundLayer.motion_scale.y = levelData.backgroundMotionScaleY
    var background = $ParallaxBackground/ParallaxLayer/background
    var bgStream = load(levelData.backgroundPath)
    var bgImgToUse = bgStream.get_data()
    var bgTextToUse = ImageTexture.new()
    bgImgToUse.lock()
    bgTextToUse.create_from_image(bgImgToUse, 0)
    bgTextToUse.set_size_override(Vector2(levelData.backgroundSizeX, levelData.backgroundSizeY))
    background.texture = bgTextToUse
    background.set_position(Vector2(levelData.backgroundPosX, levelData.backgroundPosY))
    
    var layer2 = $ParallaxBackground/ParallaxLayer2
    layer2.motion_scale.x = levelData.layer2MotionScaleX
    layer2.motion_scale.y = levelData.layer2MotionScaleY
    for obj in levelData.layer2:
        var stream = load(obj.imagePath)
        var imgToUse = stream.get_data()
        var textureToUse = ImageTexture.new()
        imgToUse.lock()
        textureToUse.create_from_image(imgToUse, 0)
        textureToUse.set_size_override(Vector2(obj.sizeX, obj.sizeY))
        var newText = TextureRect.new()
        newText.texture = textureToUse
        newText.set_scale(Vector2(obj.scaleX, obj.scaleY))
        newText.set_position(Vector2(obj.positionX, obj.positionY))
        layer2.add_child(newText)
        
    var layer3 = $ParallaxBackground/ParallaxLayer3
    layer3.motion_scale.x = levelData.layer3MotionScaleX
    layer3.motion_scale.y = levelData.layer3MotionScaleY
    for obj in levelData.layer3:
        var stream = load(obj.imagePath)
        var imgToUse = stream.get_data()
        var textureToUse = ImageTexture.new()
        imgToUse.lock()
        textureToUse.create_from_image(imgToUse, 0)
        textureToUse.set_size_override(Vector2(obj.sizeX, obj.sizeY))
        var newText = TextureRect.new()
        newText.texture = textureToUse
        newText.set_scale(Vector2(obj.scaleX, obj.scaleY))
        newText.set_position(Vector2(obj.positionX, obj.positionY))
        layer3.add_child(newText)
    
    var tm = $World 
    # If we have level data.
    if levelData != null and levelData.tiles.size() != 0:
        # Empty out tile map so we can load level date into it
        tm.clear()
        # Loop over all the tiles in our save data
        for tile in levelData.tiles:
            # Set the appropriate cell from level data
            tm.set_cell(
                # X coord in tilemap
                tile.posX,
                # Y coord in tilemap
                tile.posY,
                # Which TileSet to use
                tile.index,
                # Some transform options
                false, false, false,
                # Which Tile in the tileset to use
                Vector2(tile.tileCoordX, tile.tileCoordY)
            )
    #Set player start from saved level information
    $Banana.position = Vector2(levelData.playerStartX, levelData.playerStartY)
    # If the position in the save file isn't default, use that.
    if (
        PlayerData.savedGame.playerPosX != -9999 and
        PlayerData.savedGame.playerPosY != -9999
    ):
        $Banana.position.x = PlayerData.savedGame.playerPosX
        $Banana.position.y = PlayerData.savedGame.playerPosY
    
    # Add pickups. Excluding pickups player has already retrieved.
    if levelData != null and levelData.pickups.size() != 0:
        # Clear current editor pickups to use level data
        for child in $Pickups.get_children():
            child.queue_free()
            
        for pickup in levelData.pickups:
            # If player picked it up already
            if PlayerData.savedGame.retrievedPickups.has(pickup.id):
                # Go to next pickup
                continue
            # I would use a match case, but it has proved annoying
            # So if if if it is.
            # If a banana throw pickup.
            if pickup.type == TYPE_PICKUP_BANANA_THROW:
                # Create a new banana throw pickup instance
                var newPickup = BANANA_THROW_PICKUP.instance()
                newPickup.id = pickup.id #Set the id saved from the editor
                # Set the position
                newPickup.position = Vector2(pickup.posX, pickup.posY)
                # And off it goes, new pickup in the level.
                $Pickups.add_child(newPickup)
     
    if (
        levelData.enemies != null and
        !levelData.enemies.empty()
    ):
        # Clear current editor enemies to use level data
        for child in $Enemies.get_children():
            $Enemies.remove_child(child)
            
        for enemyData in levelData.enemies:
            var newEnemy = null
            if enemyData.type == TYPE_ENEMY_BIG_ONION:
                newEnemy = ENEMY_BIG_ONION.instance()
            if enemyData.type == TYPE_ENEMY_PINEAPPLE:
                newEnemy = ENEMY_PINEAPPLE.instance()
            if enemyData.type == TYPE_ENEMY_RADDISH:
                newEnemy = ENEMY_RADDISH.instance()
                
            newEnemy.health = enemyData.type
            newEnemy.id = enemyData.id
            newEnemy.position.x = enemyData.posX
            newEnemy.position.y = enemyData.posY
            $Enemies.add_child(newEnemy)
                
        
func writeMapData():
    var backgroundLayer = $ParallaxBackground/ParallaxLayer
    LevelData.backgroundMotionScaleX = backgroundLayer.motion_scale.x
    LevelData.backgroundMotionScaleY = backgroundLayer.motion_scale.y
    var background = $ParallaxBackground/ParallaxLayer/background
    LevelData.backgroundPath = background.texture.get_path()
    LevelData.backgroundPosX = background.get_position().x
    LevelData.backgroundPosY = background.get_position().y
    LevelData.backgroundSizeX = background.get_size().x
    LevelData.backgroundSizeY = background.get_size().y
    
    var layer2 = []
    var layerTwo = $ParallaxBackground/ParallaxLayer2
    LevelData.layer2MotionScaleX = layerTwo.motion_scale.x
    LevelData.layer2MotionScaleY = layerTwo.motion_scale.y
    for image in layerTwo.get_children():
        var img = image as TextureRect
        var newLayerTwoImg = {
            "positionX": 0,
            "positionY": 0,
            "imagePath": "",
            "sizeX": 0,
            "sizeY": 0,
            "scaleX": 0,
            "scaleY": 0,
        }
        newLayerTwoImg.imagePath = img.texture.get_path()
        newLayerTwoImg.positionX = img.get_position().x
        newLayerTwoImg.positionY = img.get_position().y
        newLayerTwoImg.sizeX = img.get_size().x
        newLayerTwoImg.sizeY = img.get_size().y
        newLayerTwoImg.scaleX = img.get_scale().x
        newLayerTwoImg.scaleY = img.get_scale().y
        layer2.append(newLayerTwoImg)
    LevelData.layer2 = layer2
    
    var layer3 = []
    var layerThree = $ParallaxBackground/ParallaxLayer3
    LevelData.layer3MotionScaleX = layerThree.motion_scale.x
    LevelData.layer3MotionScaleY = layerThree.motion_scale.y
    for image in layerThree.get_children():
        var img = image as TextureRect
        var newLayerThreeImg = {
            "positionX": 0,
            "positionY": 0,
            "imagePath": 0,
            "sizeX": 0,
            "sizeY": 0
        }
        newLayerThreeImg.imagePath = img.texture.get_path()
        newLayerThreeImg.positionX = img.get_position().x
        newLayerThreeImg.positionY = img.get_position().y
        newLayerThreeImg.sizeX = img.get_size().x
        newLayerThreeImg.sizeY = img.get_size().y
        newLayerThreeImg.scaleX = img.get_scale().x
        newLayerThreeImg.scaleY = img.get_scale().y
        layer3.append(newLayerThreeImg)
    LevelData.layer3 = layer3

    var tm = $World
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
    
    LevelData.playerStartX = $Banana.position.x
    LevelData.playerStartY = $Banana.position.y
    
    var pickups = $Pickups.get_children()
    for pickup in pickups:
        var toAdd = getNewPickup()
        toAdd.posX = pickup.position.x
        toAdd.posY = pickup.position.y
        toAdd.type = pickup.type
        toAdd.id   = pickup.id
        LevelData.pickups.append(toAdd)
    
    var enemies = $Enemies.get_children()
    for enemy in enemies:
        var toAdd = getNewEnemy()
        toAdd.posX   = enemy.position.x
        toAdd.posY   = enemy.position.y
        toAdd.type   = enemy.type
        toAdd.id     = enemy.id
        toAdd.health = enemy.baseHealth
        LevelData.enemies.append(toAdd)
    
    Utils.saveDataToFile(
        "user://level" + str(PlayerData.savedGame.levelNum) + ".tres",
        LevelData, 
        true, 
        false
    )

func getNewEnemy():
    return {
        posX = null,
        posY = null,
        type = "",
        health = 0,
        id   = 0
    } 
func getNewPickup():
    return {
        posX = null,
        posY = null,
        type = "",
        id   = 0
    }
func getNewTile():
    return {
        posX = null,
        posY = null,
        index = null
    } 

func playerHealthChanged(health) -> void:
    $HUD/HUD_BG/HPValue.set_text(str(health))
    
func playerWeaponChanged(weaponId) -> void:
    $HUD/HUD_BG/CurrentWeaponValue.set_text(str(weaponId))

func playerAmmoChanged(ammo) -> void:
    $HUD/HUD_BG/AmmoValue.set_text(str(ammo))

#region ForFunsies
# Code made ugly ON PURPOSE to keep EVERYONE OUT.
# Not my best attempt to hide stuff. 
# But try to figure it out. AFTER TRYING IN GAME :)
var t = [87,89,65,67,73,86,70,77,85,66,82,78,69,81,68,74,72,75,84,80,83,71,88,90,76,79]
var xt = [2,9,3,14,12,6,21,16,4,15,17,24,7,11,25,19,13,10,20,18,8,5,0,22,1,23]
# If you are considering it.
var kc = PoolByteArray([])
# Don't debug for the answer.
func _input(event: InputEvent) -> void:
    if Input.is_action_just_released("ui_cancel"):
        writeMapData()
    
    # You will be a horrible person.
    if !event is InputEventKey: return
    # I will never forgive you.
    var eventKey = event as InputEventKey
    # Seriously?
    if(eventKey.pressed or eventKey.scancode < 65 or eventKey.scancode > 90): return
    # Does my begging mean nothing to you?
    kc.append(t[xt[eventKey.scancode - 65]])
    # Quit looking at the code. Go play the game.
    var c = null
    # You don't HAVE to understand every piece of code.
    if kc.size() > 100: kc = PoolByteArray([])
    if Utils.n(rxt(Globals.x)) in Utils.n(kc):c = Globals.x
    # If you got this far, you obviously don't care.
    if Utils.n(rxt(Globals.y)) in Utils.n(kc):c = Globals.y
    # Stop. Reading. This. Code.
    if c != null: Signals.emit_signal("pc", c)
    # Fine. You're a bad person. 
    if c != null: kc = PoolByteArray([])
    #Get a life.
func rxt(a: PoolByteArray) -> PoolByteArray:
    # If you are reading this, you HAVE to give me an A, Dr. Dalio.
    var j = PoolByteArray([])
    for i in a: j.append(t[xt[i]])
    # If you are still reading this. It has to be in ALL classes
    return j
#endregion
