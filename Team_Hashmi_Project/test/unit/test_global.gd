extends "res://addons/gut/test.gd"

var LEVEL          = preload("res://entities/Main.tscn")

func before_each():
    gut.p("ran setup", 2)

func after_each():
    Globals.inGame = false

    gut.p("ran teardown", 2)

func before_all():
    assert_eq(Globals.TESTS, false, "TESTS SHOULD BE FALSE")
    # Turn on testing so save files are not read from disk and
    # generated fresh every time
    Globals.TESTS = true 
    PlayerData.saveSlot = 999
    gut.p("ran run setup", 2)

func after_all():
    Globals.TESTS = false
    PlayerData.saveSlot = 0
    gut.p("ran run teardown", 2)
    
func test_assert_not_in_game():
    assert_false(Globals.inGame, "Game should not be running by default")
    
func test_assert_triggers_display_off():
    assert_false(Globals.SHOW_TRIGGERS, "Triggers should not be displayed in prod")

func test_assert_level_empty_nodes():
    Globals.inGame = true
    var level = LEVEL.instance()
    assert_true(level != null, "Level should NOT be null.")
    assert_eq(level.IS_BUILDING, false, "Level should NOT be building")
    self.add_child(level)
    var triggers = level.get_node("Triggers")
    assert_true(triggers != null, "Triggers container should exist")
    var enemies = level.get_node("Enemies")
    assert_true(enemies != null, "Enemies container should exist")
    var pickups = level.get_node("Pickups")
    assert_true(pickups != null, "Pickups container should exist")
    var spawners = level.get_node("Spawners")
    assert_true(spawners != null, "Spawners container should exist")
    assert_true(level.get_node("World") != null, "World (tilemap) should exist")
    var tiles = level.get_node("World").get_used_cells()
    assert_eq(pickups.get_children().size(), 0, "Should be NO pickups in prod branch")
    assert_eq(triggers.get_children().size(), 0, "Should be NO triggers in prod branch")
    assert_eq(enemies.get_children().size(), 0, "Should be NO enemies in prod branch")
    assert_eq(spawners.get_children().size(), 0, "Should be NO spawners in prod branch")
    assert_eq(tiles.size(), 0, "Should be NO tiles in level in prod branch")
    var music = level.get_node("Banana/LevelMusic")
    assert_true(music != null, "Music should NOT be null")
    assert_true(music.stream == null, "Music should not be set")
    level.queue_free()
    yield(get_tree().create_timer(1), "timeout")
