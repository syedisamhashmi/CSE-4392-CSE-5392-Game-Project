extends "res://addons/gut/test.gd"

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
 
func test_assert_banana_blaster_pick():
    var blaster = BANANA_BLASTER.instance()
    blaster.id = "testBlasterId"
    player = PLAYER.instance()
    add_child(player)
    add_child(blaster)
    checkPickupWorking(blaster, player, "isBananaBlasterUnlocked")
    player.queue_free()
    blaster.queue_free()
    # Give some time for stuff to free up
    yield(get_tree().create_timer(.5), "timeout")
func test_assert_banana_throw_pick():
    var banana = BANANA_THROW.instance()
    banana.id = "testBananaThrowId"
    player = PLAYER.instance()
    add_child(player)
    add_child(banana)
    checkPickupWorking(banana, player, "isBananaThrowUnlocked")
    player.queue_free()
    banana.queue_free()
    # Give some time for stuff to free up
    yield(get_tree().create_timer(.5), "timeout")
func test_assert_BFG9000_pick():
    var bfg = BFG9000_ITEM.instance()
    bfg.id = "testBFG9000Id"
    player = PLAYER.instance()
    add_child(player)
    add_child(bfg)
    checkPickupWorking(bfg, player, "isBFG9000Unlocked")
    player.queue_free()
    bfg.queue_free()
    # Give some time for stuff to free up
    yield(get_tree().create_timer(.5), "timeout")
func test_assert_gas_mask_pick():
    var gasMask = GAS_MASK.instance()
    gasMask.id = "testGasMaskId"
    player = PLAYER.instance()
    add_child(player)
    add_child(gasMask)
    checkPickupWorking(gasMask, player, "gasMaskUnlocked")
    player.queue_free()
    gasMask.queue_free()
    # Give some time for stuff to free up
    yield(get_tree().create_timer(.5), "timeout")    
func test_assert_health_pick():
    var health = HEALTH.instance()
    health.id = "testHealthId"
    player = PLAYER.instance()
    var beforeHealth = player.save.playerHealth
    add_child(player)
    add_child(health)
    checkPickupWorking(health, player, null)
    var afterHealth = player.save.playerHealth
    assert_eq(afterHealth > beforeHealth, true, "Health should have increased")
    player.queue_free()
    health.queue_free()
    # Give some time for stuff to free up
    yield(get_tree().create_timer(.5), "timeout")    
func test_assert_high_jump_pick():
    var highJump = HIGH_JUMP.instance()
    highJump.id = "testHighJumpId"
    player = PLAYER.instance()
    var beforeJumpHeight = player.save.playerJumpHeight
    add_child(player)
    add_child(highJump)
    checkPickupWorking(highJump, player, null)
    var afterJumpHeight = player.save.playerJumpHeight
    assert_eq(afterJumpHeight > beforeJumpHeight, true, "Jump height should have increased")
    player.queue_free()
    highJump.queue_free()
    # Give some time for stuff to free up
    yield(get_tree().create_timer(.5), "timeout")
func test_assert_spike_armor_pick():
    var spikeArmor = SPIKE_ARMOR.instance()
    spikeArmor.id = "testSpikeArmorId"
    player = PLAYER.instance()
    add_child(player)
    add_child(spikeArmor)
    checkPickupWorking(spikeArmor, player, "spikeArmorUnlocked")
    player.queue_free()
    spikeArmor.queue_free()
    # Give some time for stuff to free up
    yield(get_tree().create_timer(.5), "timeout")
func checkPickupWorking(pickup, playerP, saveField):
    watch_signals(Signals)  
    pickup._on_pickup_body_entered(playerP)
    assert_signal_emitted_with_parameters(Signals, pickup.signalName , [pickup.id])
    if pickup.id != "testHealthId" and pickup.id != "testHighJumpId":
        assert_eq(playerP.save[saveField], true, str(pickup.id) + " should be unlocked")
    assert_eq(playerP.save.retrievedPickups.has(pickup.id), true, "Player save state should indicate picked up item: " + str(pickup.id))

