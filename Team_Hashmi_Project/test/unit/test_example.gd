extends "res://addons/gut/test.gd"

var LEVEL          = preload("res://entities/Main.tscn")
var PLAYER         = preload("res://entities/player/player.tscn")
var BANANA_BLASTER = preload("res://entities/pickup_items/banana_blaster_item.tscn")
var BANANA_THROW   = preload("res://entities/pickup_items/banana_item.tscn")
var BFG9000_ITEM   = preload("res://entities/pickup_items/BFG9000_item.tscn")
var GAS_MASK       = preload("res://entities/pickup_items/gas-mask.tscn")
var HEALTH         = preload("res://entities/pickup_items/health.tscn")
var HIGH_JUMP      = preload("res://entities/pickup_items/high-jump.tscn")
var SPIKE_ARMOR    = preload("res://entities/pickup_items/spike-armor.tscn")

var player
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
    assert_eq(Globals.inGame, false, "Game should not be running by default")
    
func test_assert_triggers_display_off():
    assert_eq(Globals.SHOW_TRIGGERS, false, "Triggers should not be displayed in prod")

func test_assert_player_defaults():
    assert_eq(PlayerDefaults.DEFAULT_PLAYER_HEALTH, 100, "Player default health not 100")
    assert_eq(PlayerDefaults.IS_MELEE_UNLOCKED, true, "Player should have melee unlocked")
    assert_eq(PlayerDefaults.IS_BANANA_THROW_UNLOCKED, false, "Player should not have banana throw unlocked")
    assert_eq(PlayerDefaults.IS_BFG9000_UNLOCKED, false, "Player should not have BFG9000 unlocked")
    assert_eq(PlayerDefaults.IS_BANANA_BLASTER_UNLOCKED, false, "Player should not have banana blaster unlocked")
    assert_eq(PlayerDefaults.IS_BANANA_BLASTER_UNLOCKED, false, "Player should not have banana blaster unlocked")

func test_assert_player_takes_damage():
    Globals.inGame = true
    player = PLAYER.instance()
    self.add_child(player)
    var playerHealthBefore = player.save.playerHealth
    player.damage(10, 1)
    var calcd = playerHealthBefore - player.save.playerHealth
    assert_eq(
        calcd == 10, 
        true,
        "Player should have taken EXACTLY 10 damage, took " + str(calcd))
    yield(get_tree().create_timer(1), "timeout")
    player.queue_free()
    
func test_assert_player_same_damage_difficulty_wise():
    Globals.inGame = true
    player = PLAYER.instance()
    self.add_child(player)
    player.save.difficulty = 2
    var playerHealthBefore = player.save.playerHealth
    player.damage(10, 1)
    var calcd = playerHealthBefore - player.save.playerHealth
    assert_eq(
        calcd == 10,
        true, 
        "Player should NOT have taken MORE THAN 10 damage. Regardless of difficulty. Took " + str(calcd))
    yield(get_tree().create_timer(1), "timeout")
    player.queue_free()

func test_assert_player_full_damage_becomes_dead():
    Globals.inGame = true
    player = PLAYER.instance()
    self.add_child(player)
    watch_signals(Signals)
    player.damage(99, 1)
    assert_eq(
        player.save.playerHealth == 1,
        true, 
        "Player should have one health")
    assert_eq(
        player.stats.playerDeathCount == 0,
        true, 
        "Player stats death count should NOT increase")
    yield(get_tree().create_timer(1), "timeout")
    player.damage(1, 1)
    assert_eq(
        player.save.playerHealth == 0,
        true, 
        "Player should have no health")
    assert_eq(
        player.stats.playerDeathCount == 1,
        true, 
        "Player stats death count should increase")
    assert_signal_emitted_with_parameters(Signals, "player_death", [])
    yield(get_tree().create_timer(1), "timeout")
    player.queue_free()

func test_assert_player_over_damage_becomes_dead():
    Globals.inGame = true
    player = PLAYER.instance()
    self.add_child(player)
    watch_signals(Signals)
    player.damage(1000, 1)
    assert_eq(
        player.save.playerHealth == 0,
        true, 
        "Player should have ZERO health")
    assert_eq(
        player.stats.playerDeathCount == 1,
        true, 
        "Player stats death count should increase")
    assert_signal_emitted_with_parameters(Signals, "player_death", [])
    yield(get_tree().create_timer(1), "timeout")
    player.queue_free()
    yield(get_tree().create_timer(1), "timeout")

func test_assert_pickup_types():
    Globals.inGame = true
    var blaster = BANANA_BLASTER.instance()
    var banana = BANANA_THROW.instance()
    var bfg = BFG9000_ITEM.instance()
    var gasMask = GAS_MASK.instance()
    var health = HEALTH.instance()
    var highJump = HIGH_JUMP.instance()
    var spikeArmor = SPIKE_ARMOR.instance()
    
    assert_eq(blaster.type, EntityTypeEnums.PICKUP_TYPE.BANANA_BLASTER, "Blaster type not set properly")
    assert_eq(banana.type, EntityTypeEnums.PICKUP_TYPE.BANANA_THROW, "Banana Throw type not set properly")
    assert_eq(bfg.type, EntityTypeEnums.PICKUP_TYPE.BFG9000, "BFG9000 type not set properly")
    assert_eq(gasMask.type, EntityTypeEnums.PICKUP_TYPE.GAS_MASK, "Gas Mask type not set properly")
    assert_eq(health.type, EntityTypeEnums.PICKUP_TYPE.HEALTH, "Health type not set properly")
    assert_eq(highJump.type, EntityTypeEnums.PICKUP_TYPE.HIGH_JUMP, "HighJump type not set properly")
    assert_eq(spikeArmor.type, EntityTypeEnums.PICKUP_TYPE.SPIKE_ARMOR, "SpikeArmor type not set properly")
    #    self.add_child(blaster)
    #    self.add_child(banana)
    #    self.add_child(bfg)
    #    self.add_child(gasMask)
    #    self.add_child(health)
    #    self.add_child(highJump)
    #    self.add_child(spikeArmor)
    blaster.queue_free()
    banana.queue_free()
    bfg.queue_free()
    gasMask.queue_free()
    health.queue_free()
    highJump.queue_free()
    spikeArmor.queue_free()
    # Give some time for stuff to free up
    yield(get_tree().create_timer(1), "timeout")

func test_assert_level_empty_nodes():
    Globals.inGame = true
    var level = LEVEL.instance()
    self.add_child(level)
    var triggers = level.get_node("Triggers")
    var enemies = level.get_node("Enemies")
    var pickups = level.get_node("Pickups")
#    var spawners(triggers.get_children().size(), 0, "Should be NO triggers in prod branch")
    assert_eq(pickups.get_children().size(), 0, "Should be NO pickups in prod branch")
    assert_eq(triggers.get_children().size(), 0, "Should be NO triggers in prod branch")
    assert_eq(enemies.get_children().size(), 0, "Should be NO enemies in prod branch")
#    assert_eq(spawners.get_children().size(), 0, "Should be NO spawners in prod branch")
    level.queue_free()
    yield(get_tree().create_timer(1), "timeout")
    
