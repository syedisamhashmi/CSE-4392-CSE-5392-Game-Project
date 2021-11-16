extends "res://addons/gut/test.gd"

#var PLAYER         = preload("res://entities/player/player.tscn")

#var levels = [1]

#var player

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

func test_assert_level1_okay():
    var levelStr = "Level" + str(1) + " data "
    var levelData = Utils.loadDataFromFile("res://levels/level" + str(1) + ".tres", null, true, false)
    print("test")
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
            fail_test(enemy.id + " duplicated in level")
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
        if enemy.type == EntityTypeEnums.ENEMY_TYPE.NONE:
            fail_test("Enemy Type not set for " + enemy.id)
    assert_true(true, "Enemies for level " + str(1) + " ok.")
        
    levelData.free()
