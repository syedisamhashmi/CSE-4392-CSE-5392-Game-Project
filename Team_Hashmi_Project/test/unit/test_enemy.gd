extends "res://addons/gut/test.gd"

var ENEMY_BIG_ONION       = preload("res://entities/enemies/big_onion/big_onion.tscn")
var ENEMY_PINEAPPLE       = preload("res://entities/enemies/pineapple/pineapple.tscn")
var ENEMY_RADDISH         = preload("res://entities/enemies/raddish/raddish.tscn")
var ENEMY_BROCCOLI        = preload("res://entities/enemies/broccoli/broccoli.tscn")
var ENEMY_BABY_ONION      = preload("res://entities/enemies/baby_onion/baby_onion.tscn")
var ENEMY_POTATO          = preload("res://entities/enemies/potato/potato.tscn")
var ENEMY_CARROT          = preload("res://entities/enemies/carrot/carrot.tscn")
var ENEMY_SPIKE           = preload("res://entities/enemies/spikes/spikes.tscn")
var ENEMY_CAULIFLOWER     = preload("res://entities/enemies/cauliflower/cauliflower.tscn")
var ENEMY_CORN            = preload("res://entities/enemies/cabbage/cabbage.tscn")
var ENEMY_CABBAGE         = preload("res://entities/enemies/cabbage/cabbage.tscn")
func before_each():
    Globals.inGame = true
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
    var onion      = ENEMY_BIG_ONION.instance()
    var pineapple  = ENEMY_PINEAPPLE.instance()
    var raddish    = ENEMY_RADDISH.instance()
    var spikes     = ENEMY_SPIKE.instance()
    var broccoli   = ENEMY_BROCCOLI.instance()
    var baby_onion = ENEMY_BABY_ONION.instance()
    var potato     = ENEMY_POTATO.instance()
    var carrot     = ENEMY_CARROT.instance()
    var cauliflower = ENEMY_CAULIFLOWER.instance()
    var corn        = ENEMY_CORN.instance()
    var cabbage     =ENEMY_CABBAGE.instance()
    assert_eq(onion.type, EntityTypeEnums.ENEMY_TYPE.BIG_ONION, "Onion type should be set properly")
    assert_eq(pineapple.type, EntityTypeEnums.ENEMY_TYPE.PINEAPPLE, "Pineapple type should be set properly")
    assert_eq(raddish.type, EntityTypeEnums.ENEMY_TYPE.RADDISH, "Raddish type should be set properly")
    assert_eq(spikes.type, EntityTypeEnums.ENEMY_TYPE.SPIKE, "Spike type should be set properly")
    assert_eq(broccoli.type, EntityTypeEnums.ENEMY_TYPE.BROCCOLI, "Broccoli type should be set properly")
    assert_eq(baby_onion.type, EntityTypeEnums.ENEMY_TYPE.BABY_ONION, "Baby Onion type should be set properly")
    assert_eq(potato.type, EntityTypeEnums.ENEMY_TYPE.POTATO, "Potato type should be set properly")
    assert_eq(carrot.type, EntityTypeEnums.ENEMY_TYPE.CARROT, "Carrot type should be set properly")
    assert_eq(cauliflower.type, EntityTypeEnums.ENEMY_TYPE.CAULIFLOWER, "Cauliflower type should be set properly")
    assert_eq(corn.type, EntityTypeEnums.ENEMY_TYPE.CORN, "Corn type should be set properly")
    assert_eq(cabbage.type, EntityTypeEnums.ENEMY_TYPE.CABBAGE, "Cabbage type should be set properly")
    onion.queue_free()
    pineapple.queue_free()
    raddish.queue_free()
    spikes.queue_free()
    broccoli.queue_free()
    baby_onion.queue_free()
    potato.queue_free()
    carrot.queue_free()
    yield(get_tree().create_timer(1), "timeout")

func test_assert_enemies_defaults():
    Globals.inGame = false
    var onion      = ENEMY_BIG_ONION.instance()
    var pineapple  = ENEMY_PINEAPPLE.instance()
    var raddish    = ENEMY_RADDISH.instance()
    var spikes     = ENEMY_SPIKE.instance()
    var broccoli   = ENEMY_BROCCOLI.instance()
    var baby_onion = ENEMY_BABY_ONION.instance()
    var potato     = ENEMY_POTATO.instance()
    var carrot     = ENEMY_CARROT.instance()
    var cauliflower = ENEMY_CAULIFLOWER.instance()
    var corn        = ENEMY_CORN.instance()
    var cabbage     =ENEMY_CABBAGE.instance()
    assert_eq(onion.get_node("Image").get_animation(), onion.IDLE, "Onion should be idle")
    assert_eq(pineapple.get_node("Image").get_animation(), pineapple.IDLE, "Pineapple should be idle")
    assert_eq(raddish.get_node("Image").get_animation(), raddish.IDLE, "Raddish should be idle")
    assert_eq(spikes.get_node("Image").get_animation(), "default", "Spike should be default")
    assert_eq(broccoli.get_node("Image").get_animation(), broccoli.IDLE, "Broccoli should be idle")
    assert_eq(baby_onion.get_node("Image").get_animation(), baby_onion.IDLE, "Baby Onion should be idle")
    assert_eq(potato.get_node("Image").get_animation(), potato.IDLE, "Potato should be idle")
    assert_eq(carrot.get_node("Image").get_animation(), carrot.IDLE, "Carrot should be idle")
    assert_eq(cauliflower.get_node("Image").get_animation(), cauliflower.IDLE, "Cauliflower should be idle")
    assert_eq(corn.get_node("Image").get_animation(), corn.IDLE, "Corn should be idle")
    assert_eq(cabbage.get_node("Image").get_animation(), cabbage.IDLE, "Cabbage should be idle")
    
    assert_eq(onion.get_node("Image").playing, false, "Onion image should not be playing ")
    assert_eq(pineapple.get_node("Image").playing, false, "Pineapple image should not be playing")
    assert_eq(raddish.get_node("Image").playing, false, "Raddish image should not be playing")
    assert_eq(spikes.get_node("Image").playing, false, "Spike image should not be playing")
    assert_eq(broccoli.get_node("Image").playing, false, "Broccoli image should not be playing")
    assert_eq(baby_onion.get_node("Image").playing, false, "Baby Onion image should not be playing")
    assert_eq(potato.get_node("Image").playing, false, "Potato image should not be playing")
    assert_eq(carrot.get_node("Image").playing, false, "Carrot image should not be playing")
    assert_eq(corn.get_node("Image").playing, false, "Corn image should not be playing")
    assert_eq(cabbage.get_node("Image").playing, false, "Cabbage image should not be playing")
    assert_eq(cauliflower.get_node("Image").playing, false, "Cauliflower image should not be playing")
    assert_eq(onion.get_node("Image").get_frame(), 0, "Onion image should be on frame 0")
    assert_eq(pineapple.get_node("Image").get_frame(), 0, "Pineapple image should be on frame 0")
    assert_eq(raddish.get_node("Image").get_frame(), 0, "Raddish image should be on frame 0")
    assert_eq(spikes.get_node("Image").get_frame(), 0, "Spike image should be on frame 0")
    assert_eq(broccoli.get_node("Image").get_frame(), 0, "Broccoli image should be on frame 0")
    assert_eq(baby_onion.get_node("Image").get_frame(), 0, "Baby Onion image should be on frame 0")
    assert_eq(potato.get_node("Image").get_frame(), 0, "Potato image should be on frame 0")
    assert_eq(carrot.get_node("Image").get_frame(), 0, "Carrot image should be on frame 0")
    assert_eq(corn.get_node("Image").get_frame(), 0, "Corn image should be on frame 0")
    assert_eq(cabbage.get_node("Image").get_frame(), 0, "Cabbage image should be on frame 0")
    assert_eq(cauliflower.get_node("Image").get_frame(), 0, "Cauliflower image should be on frame 0")
    onion.queue_free()
    pineapple.queue_free()
    raddish.queue_free()
    spikes.queue_free()
    broccoli.queue_free()
    baby_onion.queue_free()
    potato.queue_free()
    carrot.queue_free()
    corn.queue_free()
    cauliflower.queue_free()
    cabbage.queue_free()
    yield(get_tree().create_timer(1), "timeout")

func test_assert_pause_damage_ignore():
    Globals.inGame = false
    test_assert_onion_take_damage()
    test_assert_pineapple_take_damage()
    test_assert_raddish_take_damage()
    test_assert_broccoli_take_damage()
    test_assert_baby_onion_take_damage()
    test_assert_potato_take_damage()
    test_assert_carrot_take_damage()
    test_assert_spike_take_damage()
    test_assert_corn_take_damage()
    test_assert_cabbage_take_damage()
    test_assert_cauliflower_take_damage()
    

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
    
func test_assert_broccoli_take_damage():
    var broccoli = ENEMY_BROCCOLI.instance()
    add_child(broccoli)
    assert_enemy_take_damage(broccoli, "broccoli")
    yield(get_tree().create_timer(.7), "timeout")
    broccoli.queue_free()

func test_assert_baby_onion_take_damage():
    var baby_onion = ENEMY_BABY_ONION.instance()
    add_child(baby_onion)
    assert_enemy_take_damage(baby_onion, "baby_onion")
    yield(get_tree().create_timer(.7), "timeout")
    baby_onion.queue_free()

func test_assert_potato_take_damage():
    var potato = ENEMY_POTATO.instance()
    add_child(potato)
    assert_enemy_take_damage(potato, "Potato")
    yield(get_tree().create_timer(.7), "timeout")
    potato.queue_free()

func test_assert_carrot_take_damage():
    var carrot = ENEMY_CARROT.instance()
    add_child(carrot)
    assert_enemy_take_damage(carrot, "Carrot")
    yield(get_tree().create_timer(.7), "timeout")
    carrot.queue_free()

func test_assert_corn_take_damage():
    var corn = ENEMY_CORN.instance()
    add_child(corn)
    assert_enemy_take_damage(corn, "corn")
    yield(get_tree().create_timer(.7), "timeout")
    corn.queue_free()
    
func test_assert_cabbage_take_damage():
    var cabbage = ENEMY_CABBAGE.instance()
    add_child(cabbage)
    assert_enemy_take_damage(cabbage, "Cabbage")
    yield(get_tree().create_timer(.7), "timeout")
    cabbage.queue_free()

func test_assert_cauliflower_take_damage():
    var cauliflower = ENEMY_CAULIFLOWER.instance()
    add_child(cauliflower)
    assert_enemy_take_damage(cauliflower,"cauliflower")
    yield(get_tree().create_timer(.7), "timeout")
    cauliflower.queue_free()

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
    if Globals.inGame:
        assert_true(afterHealth < beforeHealth, printName + " should have taken damage")
    else:
        assert_true(afterHealth == beforeHealth, printName + " should not have taken damage in pause")
