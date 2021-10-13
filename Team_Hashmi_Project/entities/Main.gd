extends Node

#region Preload
var CAN_I_PLAY_DADDY = preload("res://assets/images/Menu/difficulties/CanIPlayDaddy.png")
var IM_TOO_SQUISHY_TO_DIE = preload("res://assets/images/Menu/difficulties/ImTooSquishyToDie.png")
var BRUISE_ME_PLENTY = preload("res://assets/images/Menu/difficulties/BruiseMePlenty.png")
var I_AM_BANANA_INCARNATE = preload("res://assets/images/Menu/difficulties/IAmBananaIncarnate.png")
#endregion

var rng = RandomNumberGenerator.new()

func _ready() -> void:
    var root = get_tree().get_root()
    Globals.current_scene = root.get_child(root.get_child_count() - 1)
    PlayerData.saveSlot = 0
    PlayerData.setSavedGame(PlayerData.getDefaultSaveGame(0))
    
    $NewGameCreation/Difficulties.add_item(PlayerData.DIFFICULTIES.CAN_I_PLAY_DADDY, 0)
    $NewGameCreation/DifficultyDescription.set_text(PlayerData.DIFFICULTIES_DESCRIPTIONS[0])
    $NewGameCreation/Difficulties.add_item(PlayerData.DIFFICULTIES.IM_TOO_SQUISHY_TO_DIE, 1)
    $NewGameCreation/Difficulties.add_item(PlayerData.DIFFICULTIES.BRUISE_ME_PLENTY, 2)
    $NewGameCreation/Difficulties.add_item(PlayerData.DIFFICULTIES.I_AM_BANANA_INCARNATE, 3)
    
    rng.randomize()
    $MainMenuSelection.set_visible(true)
    $NewGameCreation.set_visible(false)
    $NewGameCreation/SaveSlots.add_item("Save Slot 1", 0)
    $NewGameCreation/SaveSlots.add_item("Save Slot 2", 1)
    $NewGameCreation/SaveSlots.add_item("Save Slot 3", 2)
    $NewGameCreation/SaveSlots.add_item("Save Slot 4", 3)


func _on_Difficulties_item_selected(index: int) -> void:
    $NewGameCreation/DifficultyDescription.set_text(PlayerData.DIFFICULTIES_DESCRIPTIONS[index])
    PlayerData.setSavedGame(PlayerData.getDefaultSaveGame(index))
    match index:
        0: $NewGameCreation/DifficultyImage.set_texture(CAN_I_PLAY_DADDY)
        1: $NewGameCreation/DifficultyImage.set_texture(IM_TOO_SQUISHY_TO_DIE)
        2: $NewGameCreation/DifficultyImage.set_texture(BRUISE_ME_PLENTY)
        3: $NewGameCreation/DifficultyImage.set_texture(I_AM_BANANA_INCARNATE)

func _on_Exit_pressed() -> void:
    $MainMenuSelection/NewGame.set_disabled(true)
    $MainMenuSelection/LoadGame.set_disabled(true)
    $MainMenuSelection/Exit.set_disabled(true)
    $MainMenuSelection/ExitConfirmation.get_cancel().set_text("Take me back to the carnage!")
    $MainMenuSelection/ExitConfirmation.get_ok().set_text("Yeah, I'm a wimp!")
    $MainMenuSelection/ExitConfirmation.set_text(PlayerData.ExitMessages[rng.randi_range(0, PlayerData.ExitMessages.size() - 1)])
    $MainMenuSelection/ExitConfirmation.set_visible(true)

func _on_NewGame_pressed() -> void:
    $MainMenuSelection.set_visible(false)
    $NewGameCreation.set_visible(true)

func _on_BackToMainMenu_pressed() -> void:
    $MainMenuSelection.set_visible(true)
    $NewGameCreation.set_visible(false)

func _on_ExitConfirmation_confirmed() -> void:
    Signals.emit_signal("exit_game")
    # Exit program
    get_tree().quit(0)

func _on_ExitConfirmation_hide() -> void:
    $MainMenuSelection/NewGame.set_disabled(false)
    $MainMenuSelection/LoadGame.set_disabled(false)
    $MainMenuSelection/Exit.set_disabled(false)

func _on_SaveSlots_item_selected(index: int) -> void:
    PlayerData.saveSlot = index


func _on_Start_pressed() -> void:
    Globals.inGame = true 
    $NewGameCreation/Start.set_disabled(true)
    $NewGameCreation/BackToMainMenu.set_disabled(true)
    $NewGameCreation/Difficulties.set_disabled(true)
    $NewGameCreation/SaveSlots.set_disabled(true)
    if (Utils.doesFileExist(Globals.getPlayerSaveFileName())):
        $NewGameCreation/OverwriteGame.get_cancel().set_text("No!")
        $NewGameCreation/OverwriteGame.get_ok().set_text("Yes")
        $NewGameCreation/OverwriteGame.set_visible(true)
    else:
        _on_OverwriteGame_confirmed()


func _on_OverwriteGame_confirmed() -> void:
    Globals.save_game()
    Globals.goto_scene("res://entities/Main.tscn")


func _on_OverwriteGame_hide() -> void:
    $NewGameCreation/Start.set_disabled(false)
    $NewGameCreation/BackToMainMenu.set_disabled(false)
    $NewGameCreation/Difficulties.set_disabled(false)
    $NewGameCreation/SaveSlots.set_disabled(false)
