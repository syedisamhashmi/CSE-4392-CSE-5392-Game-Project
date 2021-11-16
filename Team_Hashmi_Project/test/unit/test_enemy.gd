extends "res://addons/gut/test.gd"

var ENEMY_BIG_ONION       = preload("res://entities/enemies/big_onion/big_onion.tscn")
var ENEMY_PINEAPPLE       = preload("res://entities/enemies/pineapple/pineapple.tscn")
var ENEMY_RADDISH         = preload("res://entities/enemies/raddish/raddish.tscn")
var ENEMY_SPIKE           = preload("res://entities/enemies/spikes/spikes.tscn")

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

func test_assert_enemies_proper_types():
    var onion     = ENEMY_BIG_ONION.instance()
    var pineapple = ENEMY_PINEAPPLE.instance()
    var raddish   = ENEMY_RADDISH.instance()
    var spikes    = ENEMY_SPIKE.instance()
    assert_eq(onion.type, EntityTypeEnums.ENEMY_TYPE.BIG_ONION, "Onion type should be set properly")
    assert_eq(pineapple.type, EntityTypeEnums.ENEMY_TYPE.PINEAPPLE, "Pineapple type should be set properly")
    assert_eq(raddish.type, EntityTypeEnums.ENEMY_TYPE.RADDISH, "Raddish type should be set properly")
    assert_eq(spikes.type, EntityTypeEnums.ENEMY_TYPE.SPIKE, "Spike type should be set properly")
    onion.queue_free()
    pineapple.queue_free()
    raddish.queue_free()
    spikes.queue_free()
    yield(get_tree().create_timer(1), "timeout")


func test_assert_onion_take_damage():
    var onion = ENEMY_BIG_ONION.instance()
    add_child(onion)
    assert_enemy_take_damage(onion, "Onion")
    yield(get_tree().create_timer(.7), "timeout")
    onion.queue_free()
    
func test_assert_pineapple_take_damage():
    var pineapple = ENEMY_PINEAPPLE.instance()
    add_child(pineapple)
    assert_enemy_take_damage(pineapple, "Pineapple")
    yield(get_tree().create_timer(.7), "timeout")
    pineapple.queue_free()
    
func test_assert_raddish_take_damage():
    var raddish = ENEMY_RADDISH.instance()
    add_child(raddish)
    assert_enemy_take_damage(raddish, "Raddish")
    yield(get_tree().create_timer(.7), "timeout")
    raddish.queue_free()
    
func test_assert_spike_take_damage():
    var spike = ENEMY_SPIKE.instance()
    add_child(spike)
    var beforeHealth = spike.health
    spike.damage(10, 1)
    var afterHealth = spike.health
    assert_eq(beforeHealth, afterHealth, "Spikes should NOT have taken damage")
    yield(get_tree().create_timer(.7), "timeout")
    spike.queue_free()

func assert_enemy_take_damage(enemy, printName):
    var beforeHealth = enemy.health
    enemy.damage(10, 1)
    var afterHealth = enemy.health
    assert_true(afterHealth < beforeHealth, printName +" should have taken damage")
    
