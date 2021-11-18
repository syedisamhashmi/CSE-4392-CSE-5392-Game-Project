extends "res://addons/gut/test.gd"

var LEVEL = preload("res://entities/Main.tscn")

var levels = [0, 1]

func before_each():
    Globals.TESTS = false
    gut.p("ran setup", 2)

func after_each():
    Globals.TESTS = true
    gut.p("ran teardown", 2)

func before_all():
    Globals.inGame = true
    assert_eq(Globals.TESTS, false, "TESTS SHOULD BE FALSE")
    # Turn on testing so save files are not read from disk and
    # generated fresh every time
    Globals.TESTS = true 
    PlayerData.saveSlot = 999
    gut.p("ran run setup", 2)

func after_all():
    Globals.inGame = false
    Globals.TESTS = false
    PlayerData.saveSlot = 0
    gut.p("ran run teardown", 2)

func test_assert_levels_okay():
    for level in levels:
        assert_level_okay(level)

func assert_level_okay(levelId):
    var levelStr = "Level" + str(levelId) + " data "
    var levelData = Utils.loadDataFromFile("res://levels/level" + str(levelId) + ".tres", null, true, false)
    var levelFields = [
        "backgroundMotionScaleX",
        "playerStartY",
#        "backgroundPath", #This is nullable
        "playerStartX",
        "backgroundMotionScaleY",
        "backgroundPosX",
        "backgroundPosY",
        "backgroundSizeX",
        "backgroundSizeY",
        "layer2MotionScaleX",
        "layer2MotionScaleY",
        "layer2",
        "layer3MotionScaleX",
        "layer3MotionScaleY",
        "layer3",
        "tiles",
        "pickups",
        "enemies",
        "triggers",
        "spawners"
    ]
    assert_true(levelData != null, levelStr + "should NOT be null.")
    for field in levelFields:  
        assert_true(field in levelData, levelStr + field + " should NOT be null.")
    
    var ids = []
    for enemy in levelData.enemies:
        if !("id" in enemy):
            fail_test("Enemy Id should NOT be null.")
        if enemy.id in ids:
            fail_test("Enemy " + enemy.id + " duplicated in level")
        ids.append(enemy.id)
        
        if !("health" in enemy):
            fail_test(enemy.id + " health should NOT be null.")
        if !("posX" in enemy ):
            fail_test(enemy.id + " posX should NOT be null.")
        if !("posY" in enemy):
            fail_test(enemy.id + " posY should NOT be null.")
        if !("scaleX" in enemy):
            fail_test(enemy.id + " scaleX should NOT be null.")
        if !("scaleY" in enemy):
            fail_test(enemy.id + " scaleY should NOT be null.")
        if !("type" in enemy):
            fail_test(enemy.id + " type should NOT be null.")
        if !("alreadyDroppedItem" in enemy):
            fail_test(enemy.id + " alreadyDroppedItem should NOT be null.")
        if !("dropsOnDifficulties" in enemy):
            fail_test(enemy.id + " dropsOnDifficulties should NOT be null.")
        if !(enemy.dropsOnDifficulties.size() == 4):
            fail_test(enemy.id + " dropsOnDifficulties should contain 4 items.")
        if !("health" in enemy):
            fail_test(enemy.id + " health should not be null")
        if !("itemDroptype" in enemy):
            fail_test(enemy.id + " itemDroptype should not be null")
        if !("rotDeg" in enemy):
            fail_test(enemy.id + " rotDeg should not be null")
        if !("type" in enemy):
            fail_test(enemy.id + " type should not be null")
        if !("onDeathPlaySong" in enemy):
            fail_test(enemy.id + " onDeathPlaySong should exist in data")
        if enemy.type == EntityTypeEnums.ENEMY_TYPE.NONE:
            fail_test("Enemy Type not set for " + enemy.id)
        if "deployed" in enemy:
            if enemy.type != EntityTypeEnums.ENEMY_TYPE.SPIKE:
                fail_test("Enemy type for " + enemy.id + " set incorrectly")
    assert_true(true, "Enemies for level " + str(levelId) + " ok.")
        
    for layer in levelData.layer2:
        if !("imagePath" in layer):
            fail_test("Layer2 missing imagePath")
        if !("positionX" in layer):
            fail_test("Layer2 missing positionX")
        if !("positionY" in layer):
            fail_test("Layer2 missing positionY")
        if !("scaleX" in layer):
            fail_test("Layer2 missing scaleX")
        if !("scaleY" in layer):
            fail_test("Layer2 missing scaleY")
        if !("sizeX" in layer):
            fail_test("Layer2 missing sizeX")
        if !("sizeY" in layer):
            fail_test("Layer2 missing sizeY")
    assert_true(true, "Layer2 for level " + str(levelId) + " ok.")

    for layer in levelData.layer3:
        if !("imagePath" in layer):
            fail_test("Layer3 missing imagePath")
        if !("positionX" in layer):
            fail_test("Layer3 missing positionX")
        if !("positionY" in layer):
            fail_test("Layer3 missing positionY")
        if !("scaleX" in layer):
            fail_test("Layer3 missing scaleX")
        if !("scaleY" in layer):
            fail_test("Layer3 missing scaleY")
        if !("sizeX" in layer):
            fail_test("Layer3 missing sizeX")
        if !("sizeY" in layer):
            fail_test("Layer3 missing sizeY")
    assert_true(true, "Layer3 for level " + str(levelId) + " ok.")

    var pids = []
    for pickup in levelData.pickups:
        if !("id" in pickup):
            fail_test("Pickup missing id")
        if pids.has(pickup.id):
            fail_test("Pickup " + pickup.id + " duplicated in level")
        pids.append(pickup.id)
        if !("posX" in pickup):
            fail_test(pickup.id + " missing posX")
        if !("posY" in pickup):
            fail_test(pickup.id + " missing posY")
        if !("type" in pickup):
            fail_test(pickup.id + " missing type")
        if pickup.type == EntityTypeEnums.PICKUP_TYPE.NONE:
            fail_test(pickup.id + " has none type")
    assert_true(true, "Pickups for level " + str(levelId) + " ok.")

    var sids = []
    for spawner in levelData.spawners:
        if !("id" in spawner):
            fail_test("Spawner missing id")
        if sids.has(spawner.id):
            fail_test("Spawner " + spawner.id + " duplicated in level")
        sids.append(spawner.id)
        if !("posX" in spawner):
            fail_test(spawner.id + " missing posX")
        if !("posY" in spawner):
            fail_test(spawner.id + " missing posY")
        if !("spawnDelayMs" in spawner):
            fail_test(spawner.id + " missing spawnDelayMs")
        if !("randomTimeDelay" in spawner):
            fail_test(spawner.id + " missing randomTimeDelay")
        if !("type" in spawner):
            fail_test(spawner.id + " missing type")
        if spawner.type == EntityTypeEnums.SPAWNER_TYPE.NONE:
            fail_test(spawner.id + " has none type")        
    assert_true(true, "Spawners for level " + str(levelId) + " ok.")
    
    for tile in levelData.tiles:
        if !("flipX" in tile):
            fail_test("Tile missing flipX")
        if !("flipY" in tile):
            fail_test("Tile missing flipY")
        if !("index" in tile):
            fail_test("Tile missing index")
        if !("posX" in tile):
            fail_test("Tile missing posX")
        if !("posY" in tile):
            fail_test("Tile missing posY")
        if !("tileCoordX" in tile):
            fail_test("Tile missing tileCoordX")
        if !("tileCoordY" in tile):
            fail_test("Tile missing tileCoordY")
        if !("transpose" in tile):
            fail_test("Tile missing transpose")
    assert_true(true, "Tiles for level " + str(levelId) + " ok.")
    
    var tids = []
    for trigger in levelData.triggers:
        if !("triggerId" in trigger):
            fail_test("trigger missing Id")
        if tids.has(trigger.triggerId):
            fail_test("Trigger " + trigger.triggerId + " duplicated in level")
        tids.append(trigger.triggerId)
        if !("levelId" in trigger):
            fail_test(trigger.triggerId + " missing levelId")
        if !("posX" in trigger):
            fail_test(trigger.triggerId + " missing posX")
        if !("posY" in trigger):
            fail_test(trigger.triggerId + " missing posY")
        if !("scaleX" in trigger):
            fail_test(trigger.triggerId + " missing scaleX")
        if !("scaleY" in trigger):
            fail_test(trigger.triggerId + " missing scaleY")
        if !("text" in trigger):
            fail_test(trigger.triggerId + " missing text")
        if !("type" in trigger):
            fail_test(trigger.triggerId + " missing type")
    assert_true(true, "Triggers for level " + str(levelId) + " ok.")
    
    levelData.free()


func test_assert_new_game_player_pos():
    for levelId in levels:
        gut.file_delete('user://player_save_999.tres')
        gut.file_delete('user://player_stats_999.tres')
        var level = LEVEL.instance()
        add_child(level)
        PlayerData.savedGame.levelNum = levelId
        level._ready()
        # Let everything load
        yield(get_tree().create_timer(.5), "timeout")
        var levelData = Utils.loadDataFromFile("res://levels/level" + str(levelId) + ".tres", null, true, false)
        var banana = level.get_node("Banana")
        var playerPos = banana.position
        assert_almost_eq(int(playerPos.x), int(levelData.playerStartX), 1, "Player should start at x " + str(levelData.playerStartX))
        assert_almost_eq(int(playerPos.y), int(levelData.playerStartY), 1, "Player should start at y " + str(levelData.playerStartY))
        var index = level.get_index()
        get_child(index).queue_free()
        level.queue_free()
        levelData.queue_free()
        # Let everything free
        yield(get_tree().create_timer(.7), "timeout")
        print_stray_nodes()
