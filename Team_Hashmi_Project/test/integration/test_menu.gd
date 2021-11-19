extends "res://addons/gut/test.gd"

var MENU = preload("res://entities/MainMenu.tscn")

func before_each():
    Globals.TESTS = false
    gut.p("ran setup", 2)

func after_each():
    Globals.TESTS = true
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
    gut.file_delete('user://player_save_999.tres')
    gut.file_delete('user://player_stats_999.tres')
    gut.p("ran run teardown", 2)

func test_assert_menu():
    # Empty out old testing save files
    gut.file_delete('user://player_save_999.tres')
    gut.file_delete('user://player_stats_999.tres')
    
    var menu = MENU.instance()
    add_child(menu)
    
    assert_true(menu.get_node("MainMenuSelection").visible, "Main screen in menu should be visible")
    assert_false(menu.get_node("NewGameCreation").visible, "New Game Creation screen in menu should NOT be visible")
    assert_false(menu.get_node("LoadGame").visible, "Load Game screen in menu should NOT be visible")
    
    assert_true(menu.get_node("MainMenuSelection/NewGame").visible, "New Game button in main menu should be visible")
    assert_true(menu.get_node("MainMenuSelection/LoadGame").visible, "Load button in main menu should be visible")
    assert_true(menu.get_node("CreditsBG").visible, "Credits area in main menu should be visible")
    assert_true(menu.get_node("MainMenuSelection/Exit").visible, "Exit button in main menu should be visible")
    
    assert_false(menu.get_node("MainMenuSelection/NewGame").disabled, "New Game button in main menu should be enabled")
    assert_false(menu.get_node("MainMenuSelection/LoadGame").disabled, "Load button in main menu should be enabled")
    assert_false(menu.get_node("CreditsBG/Credits").disabled, "Credits area in main menu should be enabled")
    assert_false(menu.get_node("MainMenuSelection/Exit").disabled, "Exit button in main menu should be enabled")
    
    # Click exit button
    menu._on_Exit_pressed()
    
    assert_true(menu.get_node("MainMenuSelection/NewGame").disabled, "New Game button in main menu should be disabled")
    assert_true(menu.get_node("MainMenuSelection/LoadGame").disabled, "Load button in main menu should be disabled")
    assert_true(menu.get_node("CreditsBG/Credits").disabled, "Credits area in main menu should be disabled")
    assert_true(menu.get_node("MainMenuSelection/Exit").disabled, "Exit button in main menu should be disabled")
    assert_true(menu.get_node("MainMenuSelection/ExitConfirmation").visible, "Quit confirmation should be visible")
    # Cancel exit
    menu._on_ExitConfirmation_hide()
    # All buttons should be re-enabled
    assert_false(menu.get_node("MainMenuSelection/NewGame").disabled, "New Game button in main menu should be enabled")
    assert_false(menu.get_node("MainMenuSelection/LoadGame").disabled, "Load button in main menu should be enabled")
    assert_false(menu.get_node("CreditsBG/Credits").disabled, "Credits area in main menu should be enabled")
    assert_false(menu.get_node("MainMenuSelection/Exit").disabled, "Exit button in main menu should be enabled")
    
    # Click new game
    menu._on_NewGame_pressed()
    assert_false(menu.get_node("MainMenuSelection").visible, "Main screen in menu should NOT be visible")
    assert_true(menu.get_node("NewGameCreation").visible, "New Game Creation screen in menu should be visible")
    assert_false(menu.get_node("LoadGame").visible, "Load Game screen in menu should NOT be visible")
    
    assert_true(menu.get_node("NewGameCreation/Difficulties").visible, "Difficulties dropdown should be visible")
    assert_false(menu.get_node("NewGameCreation/Difficulties").disabled, "Difficulties dropdown should NOT be disabled")
    assert_true(menu.get_node("NewGameCreation/DifficultyDescription").visible, "Difficulties description should be visible")
    assert_true(menu.get_node("NewGameCreation/DifficultyImage").visible, "Difficulties image should be visible")
    
    # Go back
    menu._on_BackToMainMenu_pressed()
    assert_true(menu.get_node("MainMenuSelection").visible, "Main screen in menu should be visible")
    assert_false(menu.get_node("NewGameCreation").visible, "New Game Creation screen in menu should NOT be visible")
    assert_false(menu.get_node("LoadGame").visible, "Load Game screen in menu should NOT be visible")
    
    menu._on_LoadGame_pressed()
    # Should see load game screen
    assert_false(menu.get_node("MainMenuSelection").visible, "Main screen in menu should NOT be visible")
    assert_false(menu.get_node("NewGameCreation").visible, "New Game Creation screen in menu should NOT be visible")
    assert_true(menu.get_node("LoadGame").visible, "Load Game screen in menu should be visible")
    
    assert_true(menu.get_node("LoadGame/Back").visible, "Load game back button should be visible")
    assert_false(menu.get_node("LoadGame/Back").disabled, "Load game back button should NOT be disabled")
    assert_true(menu.get_node("LoadGame/LoadSlots").visible, "Load game load slots should be visible")
    assert_false(menu.get_node("LoadGame/LoadSlots").disabled, "Load game load slots should NOT be disabled")
    
    menu._on_BackToMainMenu_pressed()
    assert_true(menu.get_node("MainMenuSelection").visible, "Main screen in menu should be visible")
    assert_false(menu.get_node("NewGameCreation").visible, "New Game Creation screen in menu should NOT be visible")
    assert_false(menu.get_node("LoadGame").visible, "Load Game screen in menu should NOT be visible")
    
    menu._on_NewGame_pressed()
    PlayerData.saveSlot = 999 # So tests dont interfere with other data
    menu._on_Start_pressed(true)
    if menu != null:
        menu.queue_free()
    yield(get_tree().create_timer(2), "timeout")
    var levelChild = get_tree().get_root().get_children()[get_tree().get_root().get_children().size() - 1]
    assert_true(levelChild.get_path() == "/root/Level", "Level should have spawned in")
    assert_true(levelChild.get_node("Banana") != null, "Banana should exist")
    assert_true(levelChild.get_node("Banana/LevelMusic") != null, "Level music should exist")
    assert_true(levelChild.get_node("HUD") != null, "HUD should exist")
    assert_true(levelChild.get_node("HUD/HUD_BG") != null, "HUD Background should exist")
    assert_true(levelChild.get_node("HUD/HUD_BG").visible, "HUD Background should be visible")
    
    assert_true(levelChild.get_node("HUD/PauseMenu") != null, "HUD PauseMenu should exist")
    assert_false(levelChild.get_node("HUD/PauseMenu").visible, "HUD PauseMenu should NOT be visible")
    # Hide any dialogs
    levelChild.get_node("HUD/Dialog").visible = false
    levelChild.showPauseMenu()
    assert_true(levelChild.get_node("HUD/PauseMenu").visible, "HUD PauseMenu should be visible")
    assert_eq(levelChild.get_node("HUD/PauseMenu/GamePausedLabel").text, "Game Paused", "PauseMenu should say Game Pause")
    assert_false(Globals.inGame, "InGame status should be false")
    
    levelChild.queue_free()
    yield(get_tree().create_timer(2), "timeout")
    get_tree().set_current_scene(self)
