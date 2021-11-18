extends "res://addons/gut/test.gd"

var PLAYER         = preload("res://entities/player/player.tscn")

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


func test_assert_player_throw_ammo_change():
    Globals.inGame = true
    player = PLAYER.instance()
    self.add_child(player)
    player.save.isBananaThrowUnlocked = true
    player.save.bananaThrowAmmo = 10
    
    watch_signals(Signals)
    player.equipNextWeapon()
    assert_signal_emitted_with_parameters(Signals, "player_weapon_changed", [player.Weapons.BANANA_THROW])
    player.equipPreviousWeapon()
    assert_signal_emitted_with_parameters(Signals, "player_weapon_changed", [player.Weapons.MELEE])
    player.equipPreviousWeapon()
    assert_signal_emitted_with_parameters(Signals, "player_weapon_changed", [player.Weapons.BANANA_THROW])
    player.equipNextWeapon()
    assert_signal_emitted_with_parameters(Signals, "player_weapon_changed", [player.Weapons.MELEE])
    player.equipNextWeapon()

    # Simulate pressing keypad enter to fire
    var ev = InputEventKey.new()
    ev.scancode = KEY_KP_ENTER
    ev.pressed = true
    get_tree().input_event(ev)
    assert_signal_emitted_with_parameters(Signals, "player_ammo_changed", [9])
    # Wait until banana is actually thrown.
    yield(get_tree().create_timer(1), "timeout")
    assert_eq(player.stats.bananasThrown, 1, "Player stats should reflect banana thrown")
    
    player.queue_free()
    yield(get_tree().create_timer(1), "timeout")


func test_assert_player_melee_ammo_NOT_changed():
    Globals.inGame = true
    player = PLAYER.instance()
    self.add_child(player)
    # Simulate pressing keypad enter to fire
    var ev = InputEventKey.new()
    ev.scancode = KEY_KP_ENTER
    ev.pressed = true
    get_tree().input_event(ev)
    # Wait until punch is actually thrown.
    yield(get_tree().create_timer(1), "timeout")
    assert_eq(player.stats.punchesThrown, 1, "Player stats should reflect punch thrown")
    player.queue_free()
    yield(get_tree().create_timer(1), "timeout")


func test_assert_player_default_animation_and_collision():
    Globals.inGame = true
    player = PLAYER.instance()
    self.add_child(player)
    assert_eq(player.get_node("BananaImage").get_animation(), player.IDLE, "Player should be idle")
    assert_eq(player.get_node("RightArm").get_animation(), player.IDLE, "Player should be idle")
    assert_eq(player.get_node("LeftArm").get_animation(), player.IDLE, "Player should be idle")
    
    assert_eq(player.get_node("BananaImage").flip_h, false, "Player should be facing right")
    assert_eq(player.get_node("RightArm").flip_h, false, "Player should be facing right")
    assert_eq(player.get_node("LeftArm").flip_h, false, "Player should be facing right")
    
    assert_eq(player.get_node("BananaBoundingBoxRight").disabled, false, "Player right box should be enabled")
    assert_eq(player.get_node("RightPunchArea/Collider").disabled, true, "Player right punch box should be disabled")
    assert_eq(player.get_node("LeftPunchArea/Collider").disabled, true, "Player left punch box should be disabled")
    player.queue_free()
    yield(get_tree().create_timer(1), "timeout")
