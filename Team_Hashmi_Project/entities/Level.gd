extends Node2D

export var IS_BUILDING = true

var PICKUP_BANANA_THROW   = preload("res://entities/pickup_items/banana_item.tscn")
var BFG9000_PICKUP        = preload("res://entities/pickup_items/BFG9000_item.tscn")
var BANANA_BLASTER_PICKUP = preload("res://entities/pickup_items/banana_blaster_item.tscn")
var PICKUP_GAS_MASK       = preload("res://entities/pickup_items/gas-mask.tscn")
var PICKUP_HEALTH         = preload("res://entities/pickup_items/health.tscn")
var PICKUP_HIGH_JUMP      = preload("res://entities/pickup_items/high-jump.tscn")
var PICKUP_SPIKE_ARMOR    = preload("res://entities/pickup_items/spike-armor.tscn")
# Enemies
var ENEMY_BIG_ONION       = preload("res://entities/enemies/big_onion/big_onion.tscn")
var ENEMY_PINEAPPLE       = preload("res://entities/enemies/pineapple/pineapple.tscn")
var ENEMY_RADDISH         = preload("res://entities/enemies/raddish/raddish.tscn")
var ENEMY_CARROT          = preload("res://entities/enemies/carrot/carrot.tscn")
var ENEMY_BROCCOLI        = preload("res://entities/enemies/broccoli/broccoli.tscn")
var ENEMY_BABY_ONION      = preload("res://entities/enemies/baby_onion/baby_onion.tscn")
var ENEMY_POTATO          = preload("res://entities/enemies/potato/potato.tscn")
var ENEMY_SPIKE           = preload("res://entities/enemies/spikes/spikes.tscn")
# Triggers
var DIALOG_TRIGGER        = preload("res://entities/triggers/dialog-trigger/dialog-trigger.tscn")
var CHECKPOINT_TRIGGER    = preload("res://entities/triggers/checkpoint-trigger/checkpoint-trigger.tscn")
var NEXT_LEVEL_TRIGGER    = preload("res://entities/triggers/next-level-trigger/next-level-trigger.tscn")
var MUSIC_TRIGGER         = preload("res://entities/triggers/music-trigger/music-trigger.tscn")
# Spawners
var SPAWNER_POISON        = preload("res://entities/spawners/poison-spawner.tscn")
var SPAWNER_SPIKES        = preload("res://entities/spawners/spike-spawner.tscn")

func _enter_tree() -> void:
    # warning-ignore:return_value_discarded
    Signals.connect("player_health_changed", self, "playerHealthChanged")
    # warning-ignore:return_value_discarded
    Signals.connect("player_weapon_changed", self, "playerWeaponChanged")
    # warning-ignore:return_value_discarded
    Signals.connect("player_ammo_changed", self, "playerAmmoChanged")
    # warning-ignore:return_value_discarded
    Signals.connect("displayDialog", self, "displayDialog")
    # warning-ignore:return_value_discarded
    Signals.connect("next_level_trigger_complete", self, "_on_LoadGame_button_up")
    # warning-ignore:return_value_discarded
    Signals.connect("player_death", self, "player_death")
    # warning-ignore:return_value_discarded
    Signals.connect("enemy_pickup_spawn", self, "addpickup")
    # warning-ignore:return_value_discarded
    Signals.connect("update_enemy", self, "update_enemy")
    # warning-ignore:return_value_discarded
    Signals.connect("music_trigger", self, "music_trigger")

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
    var bgStream
    if ( levelData != null and 
         levelData.backgroundPath != null and
         levelData.backgroundPath != ""
    ):
        bgStream = load(levelData.backgroundPath)
    if (bgStream != null):
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
        layer2.call_deferred("add_child", newText)
        
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
        layer3.call_deferred("add_child", newText)
    if levelData.levelMusic != null and levelData.levelMusic != "":
        var levelMusic = load(levelData.levelMusic)
        if $Banana.save.currSong != "":
            $Banana/LevelMusic.stream = load($Banana.save.currSong)
        else:
            $Banana/LevelMusic.stream = levelMusic
        $Banana/LevelMusic.play(0)
        $Banana/LevelMusic.playing = true    
    # If we have level data.
    if levelData != null and levelData.tiles.size() != 0:
        # Empty out tile map so we can load level date into it
        $World .clear()
        # Loop over all the tiles in our save data
        for tile in levelData.tiles:
            # Set the appropriate cell from level data
            $World .set_cell(
                # X coord in tilemap
                tile.posX,
                # Y coord in tilemap
                tile.posY,
                # Which TileSet to use
                tile.index,
                # Some transform options
                tile.flipX, tile.flipY, tile.transpose,
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
            addpickup(pickup, false)
     
    if (
        levelData.enemies != null and
        !levelData.enemies.empty()
    ):
        # Clear current editor enemies to use level data
        for child in $Enemies.get_children():
            child.queue_free()
            
        for enemyData in levelData.enemies:
            var newEnemy = null
            if   enemyData.type == EntityTypeEnums.ENEMY_TYPE.SPIKE:
                newEnemy = ENEMY_SPIKE.instance()
                newEnemy.type = EntityTypeEnums.ENEMY_TYPE.SPIKE
                newEnemy.deployed = enemyData.deployed
            elif enemyData.type == EntityTypeEnums.ENEMY_TYPE.BIG_ONION:
                newEnemy = ENEMY_BIG_ONION.instance()
                newEnemy.type = EntityTypeEnums.ENEMY_TYPE.BIG_ONION
            elif enemyData.type == EntityTypeEnums.ENEMY_TYPE.PINEAPPLE:
                newEnemy = ENEMY_PINEAPPLE.instance()
                newEnemy.type = EntityTypeEnums.ENEMY_TYPE.PINEAPPLE
            elif enemyData.type == EntityTypeEnums.ENEMY_TYPE.RADDISH:
                newEnemy = ENEMY_RADDISH.instance()
                newEnemy.type = EntityTypeEnums.ENEMY_TYPE.RADDISH
            elif enemyData.type == EntityTypeEnums.ENEMY_TYPE.BROCCOLI:
                newEnemy = ENEMY_BROCCOLI.instance()
                newEnemy.type = EntityTypeEnums.ENEMY_TYPE.BROCCOLI
            elif enemyData.type == EntityTypeEnums.ENEMY_TYPE.POTATO:
                newEnemy = ENEMY_POTATO.instance()
                newEnemy.type = EntityTypeEnums.ENEMY_TYPE.BROCCOLI
            elif enemyData.type == EntityTypeEnums.ENEMY_TYPE.BABY_ONION:
                newEnemy = ENEMY_BABY_ONION.instance()
                newEnemy.type = EntityTypeEnums.ENEMY_TYPE.BABY_ONION
            elif enemyData.type == EntityTypeEnums.ENEMY_TYPE.CARROT:
                newEnemy = ENEMY_CARROT.instance()
                newEnemy.type = EntityTypeEnums.ENEMY_TYPE.CARROT
            else:
                continue
            newEnemy.health = enemyData.health
            newEnemy.id = enemyData.id
            newEnemy.position.x = enemyData.posX
            newEnemy.position.y = enemyData.posY
            newEnemy.scale.x = enemyData.scaleX
            newEnemy.scale.y = enemyData.scaleY
            newEnemy.rotation_degrees = enemyData.rotDeg
            newEnemy.itemDroptype = enemyData.itemDroptype
            newEnemy.alreadyDroppedItem = enemyData.alreadyDroppedItem
            newEnemy.dropsOnDifficulties = enemyData.dropsOnDifficulties
            if (enemyData.onDeathPlaySong != null and enemyData.onDeathPlaySong != ""):
                newEnemy.onDeathPlaySong = load(enemyData.onDeathPlaySong)
            newEnemy.songTriggered = enemyData.songTriggered
            if enemyData.id in $Banana.save.enemiesData:
                var saveEnemy = $Banana.save.enemiesData[enemyData.id]
                if "deployed" in saveEnemy:
                    newEnemy["deployed"] = saveEnemy["deployed"] 
                newEnemy.itemDroptype = saveEnemy.itemDroptype
                newEnemy.alreadyDroppedItem = saveEnemy.alreadyDroppedItem
                newEnemy.dropsOnDifficulties = saveEnemy.dropsOnDifficulties
                newEnemy.health = saveEnemy.health
                newEnemy.position.x = saveEnemy.posX
                newEnemy.position.y = saveEnemy.posY
                newEnemy.scale.x = saveEnemy.scaleX
                newEnemy.scale.y = saveEnemy.scaleY
                newEnemy.dropsOnDifficulties = saveEnemy.dropsOnDifficulties
                newEnemy.itemDroptype = saveEnemy.itemDroptype
                newEnemy.songTriggered = enemyData.songTriggered
            $Enemies.call_deferred("add_child", newEnemy)
                
    if levelData != null and levelData.triggers != null:
        for child in $Triggers.get_children():
            child.queue_free()
        for trigger in levelData.triggers:
            if PlayerData.savedGame.completedTriggers.has(trigger.triggerId):
                continue
            var newTrigger
            if trigger.type == EntityTypeEnums.TRIGGER_TYPE.DIALOG:
                newTrigger            = DIALOG_TRIGGER.instance()
                newTrigger.type       = EntityTypeEnums.TRIGGER_TYPE.DIALOG
                newTrigger.dialogText = trigger.text
            elif trigger.type == EntityTypeEnums.TRIGGER_TYPE.CHECKPOINT:
                newTrigger        = CHECKPOINT_TRIGGER.instance()
                newTrigger.type   = EntityTypeEnums.TRIGGER_TYPE.CHECKPOINT
            elif trigger.type == EntityTypeEnums.TRIGGER_TYPE.NEXT_LEVEL:
                newTrigger           = NEXT_LEVEL_TRIGGER.instance()
                newTrigger.type      = EntityTypeEnums.TRIGGER_TYPE.NEXT_LEVEL
                newTrigger.goToLevel = trigger.levelId
            elif trigger.type == EntityTypeEnums.TRIGGER_TYPE.MUSIC:
                newTrigger           = MUSIC_TRIGGER.instance()
                newTrigger.type      = EntityTypeEnums.TRIGGER_TYPE.MUSIC
                if trigger.song != null and trigger.song != "":
                    newTrigger.song      = load(trigger.song)
            else:
                continue
            newTrigger.id         = trigger.triggerId
            newTrigger.position.x = trigger.posX
            newTrigger.position.y = trigger.posY
            newTrigger.scale.x    = trigger.scaleX
            newTrigger.scale.y    = trigger.scaleY
            $Triggers.call_deferred("add_child", newTrigger)

    if levelData != null and levelData.spawners != null:
        for spawner in levelData.spawners:
            var toAdd
            if spawner.type == EntityTypeEnums.SPAWNER_TYPE.POISON:
                 toAdd = SPAWNER_POISON.instance()
            elif spawner.type == EntityTypeEnums.SPAWNER_TYPE.SPIKE:
                toAdd = SPAWNER_SPIKES.instance()
            if toAdd == null:
                continue
            toAdd.id = spawner.id
            toAdd.type = spawner.type
            toAdd.randomTimeDelay = spawner.randomTimeDelay
            toAdd.spawnDelayMs = spawner.spawnDelayMs
            toAdd.position.x = spawner.posX
            toAdd.position.y = spawner.posY
            $Spawners.call_deferred("add_child", toAdd)
    levelData.queue_free()
func writeMapData():
    var backgroundLayer = $ParallaxBackground/ParallaxLayer
    LevelData.backgroundMotionScaleX = backgroundLayer.motion_scale.x
    LevelData.backgroundMotionScaleY = backgroundLayer.motion_scale.y
    var background = $ParallaxBackground/ParallaxLayer/background
    if background.texture != null:
        LevelData.backgroundPath = background.texture.get_path()
    LevelData.backgroundPosX  = background.get_position().x
    LevelData.backgroundPosY  = background.get_position().y
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
        newLayerTwoImg.sizeX     = img.get_size().x
        newLayerTwoImg.sizeY     = img.get_size().y
        newLayerTwoImg.scaleX    = img.get_scale().x
        newLayerTwoImg.scaleY    = img.get_scale().y
        layer2.append(newLayerTwoImg)
    LevelData.layer2 = layer2
    if $Banana/LevelMusic != null and $Banana/LevelMusic.get_stream() != null:
        LevelData.levelMusic = $Banana/LevelMusic.get_stream().get_path()
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

    var tileInfo = []    
    for position in $World.get_used_cells():
        var tile = getNewTile()
        print(position)
        tile.posX = position.x
        tile.posY = position.y
        tile.index = $World.get_cell(position.x,position.y)
        tile.tileCoordX = $World.get_cell_autotile_coord(position.x, position.y).x
        tile.tileCoordY = $World.get_cell_autotile_coord(position.x, position.y).y
        tile.flipX = $World.is_cell_x_flipped(position.x, position.y)
        tile.flipY = $World.is_cell_y_flipped(position.x, position.y)
        tile.transpose = $World.is_cell_transposed(position.x, position.y)
        tileInfo.append(tile)
    LevelData.tiles = tileInfo
    
    LevelData.playerStartX = $Banana.position.x
    LevelData.playerStartY = $Banana.position.y
    
    var pickups = $Pickups.get_children()
    var pickupsToUse = []
    for pickup in pickups:
        var toAdd = getNewPickup()
        toAdd.posX = pickup.position.x
        toAdd.posY = pickup.position.y
        toAdd.type = pickup.type
        toAdd.id   = pickup.id
        pickupsToUse.append(toAdd)
    LevelData.pickups = pickupsToUse
    
    var enemies = $Enemies.get_children()
    var enemiesToUse = []
    for enemy in enemies:
        var toAdd = getNewEnemy()
        toAdd.posX   = enemy.position.x
        toAdd.posY   = enemy.position.y
        toAdd.type   = enemy.type
        toAdd.id     = enemy.id
        toAdd.itemDroptype = enemy.itemDroptype
        toAdd.dropsOnDifficulties = enemy.dropsOnDifficulties
        toAdd.alreadyDroppedItem = enemy.alreadyDroppedItem
        if enemy.onDeathPlaySong != null:
            toAdd.onDeathPlaySong = enemy.onDeathPlaySong.get_path()
        toAdd.songTriggered = enemy.songTriggered
        toAdd.health = enemy.baseHealth
        toAdd.scaleX = enemy.scale.x
        toAdd.scaleY = enemy.scale.y
        toAdd.rotDeg = enemy.rotation_degrees
        if enemy.get("deployed") != null:
            toAdd.deployed = enemy.deployed
        enemiesToUse.append(toAdd)
    LevelData.enemies = enemiesToUse
    
    var triggers = $Triggers.get_children()
    var triggersToUse = []
    for trigger in triggers:
        var toAdd = getNewTrigger()
        toAdd.triggerId = trigger.id
        toAdd.type      = trigger.type
        if "goToLevel" in trigger:
            toAdd.levelId = trigger.goToLevel
        if "song" in trigger:
            toAdd.song = trigger.song.get_path()
        if "dialogText" in trigger:
            toAdd.text    = trigger.dialogText
        toAdd.scaleX    = trigger.scale.x
        toAdd.scaleY    = trigger.scale.y
        toAdd.posX      = trigger.position.x
        toAdd.posY      = trigger.position.y
        triggersToUse.append(toAdd)
    LevelData.triggers = triggersToUse
    
    var spawners = $Spawners.get_children()
    var spawnersToUse = []
    for spawner in spawners:
        var toAdd = {
            "id": spawner.id,
            "type": spawner.type,
            "randomTimeDelay": spawner.randomTimeDelay,
            "spawnDelayMs": spawner.spawnDelayMs,
            "posX": spawner.position.x,
            "posY": spawner.position.y,
        }
        spawnersToUse.append(toAdd)
    LevelData.spawners = spawnersToUse
    
    Utils.saveDataToFile(
        "user://level" + str(PlayerData.savedGame.levelNum) + ".tres",
        LevelData, 
        true, 
        false
    )
func getNewTrigger():
    return {
        "triggerId": "",
        "text": "",
        "levelId": -1,
        "type": -1,
        "scaleX": 0,
        "scaleY": 0,
        "posX": 0,
        "posY": 0
    }
func getNewEnemy():
    return {
        posX = null,
        posY = null,
        type = -1,
        health = 0,
        scaleX = 1,
        scaleY = 1,
        id   = 0,
        rotDeg = 0,
        itemDroptype = null,
        alreadyDroppedItem = true,
        dropsOnDifficulties = []
    } 
func getNewPickup():
    return {
        posX = null,
        posY = null,
        type = -1,
        id   = 0
    }
func getNewTile():
    return {
        posX = null,
        posY = null,
        index = null,
        flipX = false,
        flipY = false,
        transpose = false
    } 

func addpickup(pickup, fromSignal):
    var newPickup
    if pickup.type == EntityTypeEnums.PICKUP_TYPE.BANANA_THROW:
        # Create a new banana throw pickup instance
        newPickup = PICKUP_BANANA_THROW.instance()
        newPickup.type = EntityTypeEnums.PICKUP_TYPE.BANANA_THROW
    elif pickup.type == EntityTypeEnums.PICKUP_TYPE.BFG9000:
        newPickup = BFG9000_PICKUP.instance()
        newPickup.type = EntityTypeEnums.PICKUP_TYPE.BFG9000
    elif pickup.type == EntityTypeEnums.PICKUP_TYPE.BANANA_BLASTER:
        newPickup = BANANA_BLASTER_PICKUP.instance()
        newPickup.type = EntityTypeEnums.PICKUP_TYPE.BANANA_BLASTER
    elif pickup.type == EntityTypeEnums.PICKUP_TYPE.GAS_MASK:
        # Create a new gas mask pickup instance
        newPickup = PICKUP_GAS_MASK.instance()
        newPickup.type = EntityTypeEnums.PICKUP_TYPE.GAS_MASK
    elif pickup.type == EntityTypeEnums.PICKUP_TYPE.HEALTH:
        # Create a new health pickup instance
        newPickup = PICKUP_HEALTH.instance()
        newPickup.type = EntityTypeEnums.PICKUP_TYPE.HEALTH
    elif pickup.type == EntityTypeEnums.PICKUP_TYPE.HIGH_JUMP:
        # Create a new high jump pickup instance
        newPickup = PICKUP_HIGH_JUMP.instance()
        newPickup.type = EntityTypeEnums.PICKUP_TYPE.HIGH_JUMP
    elif pickup.type == EntityTypeEnums.PICKUP_TYPE.SPIKE_ARMOR:
        # Create a new high jump pickup instance
        newPickup = PICKUP_SPIKE_ARMOR.instance()
        newPickup.type = EntityTypeEnums.PICKUP_TYPE.SPIKE_ARMOR
    else:
        return
    # Set the id saved from the editor
    newPickup.id = pickup.id 
    # Set the position
    newPickup.position = Vector2(pickup.posX, pickup.posY)
    if fromSignal:
        if pickup.enemyId in $Banana.save.enemiesData:
            $Banana.save.enemiesData[pickup.enemyId].alreadyDroppedItem = true
    # And off it goes, new pickup in the level.
    $Pickups.call_deferred("add_child", newPickup)

func update_enemy(enemyDetails):
    $Banana.save.enemiesData[enemyDetails.id] = enemyDetails

var isOverride = false
func displayDialog(dialogText, _id, _isOverride = false):
    $HUD/Dialog.set_text(dialogText)
    $HUD/Dialog.popup_centered()
    if _isOverride:
        self.isOverride = true
    if !_isOverride:
        Globals.inGame = false

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
    if Input.is_action_just_pressed("write_map_data"):
        writeMapData()
    if Input.is_action_just_released("ui_cancel") and !dead:
        showPauseMenu()
    
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
var dead = false
func player_death():
    Globals.save_stats()
    dead = true
    showPauseMenu(true)
func showPauseMenu(isDead = false):
    if !$HUD/Dialog.visible and !$HUD/PauseMenu/ExitConfirmationDialog.visible:
        Globals.inGame = !Globals.inGame
        if isDead:
            $HUD/PauseMenu/SaveGame.visible = false
            $HUD/PauseMenu/SaveGame.disabled = true
            $HUD/PauseMenu/Resume.disabled = true
            $HUD/PauseMenu/Resume.visible = false
            $HUD/PauseMenu/GamePausedLabel.text = "You Died!"
        else:
            $HUD/PauseMenu/SaveGame.visible = true
            $HUD/PauseMenu/SaveGame.disabled = false
            $HUD/PauseMenu/Resume.disabled = false
            $HUD/PauseMenu/Resume.visible = true
            $HUD/PauseMenu/GamePausedLabel.text = "Game Paused"
        $HUD/PauseMenu.visible = !$HUD/PauseMenu.visible

func _on_Dialog_confirmed() -> void:
    if self.isOverride:
        self.isOverride = false
        $HUD/PauseMenu/SaveGame.disabled = false
        $HUD/PauseMenu/LoadGame.disabled = false
        $HUD/PauseMenu/ExitToMainMenu.disabled = false
        return
    Globals.inGame = true

func _on_SaveGame_button_up() -> void:
    PlayerData.savedGame = $Banana.save
    PlayerData.playerStats = $Banana.stats
    Globals.save_game()
    $HUD/PauseMenu/SaveGame.disabled = true
    $HUD/PauseMenu/LoadGame.disabled = true
    $HUD/PauseMenu/ExitToMainMenu.disabled = true
    displayDialog("Game saved successfully!", null, true)

func _on_LoadGame_button_up(fromTrigger = false) -> void:
    dead = false
    $HUD/PauseMenu/Resume.disabled = false
    $HUD/PauseMenu/Resume.visible = true
    Globals.load_game()
    $Banana.setLoadedData()
    readMapData()
    if !fromTrigger:
        $HUD/PauseMenu/SaveGame.disabled = true
        $HUD/PauseMenu/LoadGame.disabled = true
        $HUD/PauseMenu/ExitToMainMenu.disabled = true
        displayDialog("Game loaded successfully!", null, true)

var rng = RandomNumberGenerator.new()
func _on_ExitToMainMenu_button_up() -> void:
    $HUD/PauseMenu/SaveGame.disabled = true
    $HUD/PauseMenu/LoadGame.disabled = true
    $HUD/PauseMenu/ExitToMainMenu.disabled = true
    $HUD/PauseMenu/ExitConfirmationDialog.get_cancel().set_text("Take me back to the carnage!")
    $HUD/PauseMenu/ExitConfirmationDialog.get_ok().set_text("Yeah, I'm a wimp!")
    $HUD/PauseMenu/ExitConfirmationDialog.set_text(Strings.ExitMessages[rng.randi_range(0, Strings.ExitMessages.size() - 1)])
    $HUD/PauseMenu/ExitConfirmationDialog.set_visible(true)

func _on_ExitConfirmationDialog_confirmed() -> void:
    Utils.goto_scene("res://entities/MainMenu.tscn")

func _on_ExitConfirmationDialog_hide() -> void:
    $HUD/PauseMenu/SaveGame.disabled = false
    $HUD/PauseMenu/LoadGame.disabled = false
    $HUD/PauseMenu/ExitToMainMenu.disabled = false

func _on_Dialog_hide() -> void:
    $HUD/PauseMenu/SaveGame.disabled = false
    $HUD/PauseMenu/LoadGame.disabled = false
    $HUD/PauseMenu/ExitToMainMenu.disabled = false

func _on_Dialog_popup_hide() -> void:
    if !$HUD/PauseMenu.visible:
        Globals.inGame = true

func _on_Resume_button_up() -> void:
    if !dead:
        showPauseMenu()

func music_trigger(triggerId, song):
    if triggerId in $Banana.save.completedTriggers:
        return
    $Banana.save.completedTriggers.append(triggerId)
    $Banana.save.currSong = song.get_path()
    $Banana/LevelMusic.stream = song
    $Banana/LevelMusic.playing = true

func _on_LevelMusic_finished() -> void:
    $Banana/LevelMusic.play(0)
    $Banana/LevelMusic.playing = true
