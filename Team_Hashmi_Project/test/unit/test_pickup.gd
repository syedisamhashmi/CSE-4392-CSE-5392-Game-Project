extends "res://addons/gut/test.gd"

var BANANA_BLASTER = preload("res://entities/pickup_items/banana_blaster_item.tscn")
var BANANA_THROW   = preload("res://entities/pickup_items/banana_item.tscn")
var BFG9000_ITEM   = preload("res://entities/pickup_items/BFG9000_item.tscn")
var GAS_MASK       = preload("res://entities/pickup_items/gas-mask.tscn")
var HEALTH         = preload("res://entities/pickup_items/health.tscn")
var HIGH_JUMP      = preload("res://entities/pickup_items/high-jump.tscn")
var SPIKE_ARMOR    = preload("res://entities/pickup_items/spike-armor.tscn")

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

    blaster.queue_free()
    banana.queue_free()
    bfg.queue_free()
    gasMask.queue_free()
    health.queue_free()
    highJump.queue_free()
    spikeArmor.queue_free()
    # Give some time for stuff to free up
    yield(get_tree().create_timer(1), "timeout")
