extends Node
var current_scene = null
# warning-ignore:unused_class_variable
var inGame = false
#region Filenames and Extension constants
var player_stats_file: String = "user://player_stats_"
var player_save_file: String = "user://player_save_"
var TRES_EXTENSION: String = ".tres"
#endregion

func getPlayerStatsFileName():
    return player_stats_file + str(PlayerData.getSaveSlot()) + TRES_EXTENSION
func getPlayerSaveFileName():
    return player_save_file + str(PlayerData.getSaveSlot()) + TRES_EXTENSION


func _ready() -> void:
    pass

func load_stats() -> void:
    var playerStats = Utils.loadDataFromFile(getPlayerStatsFileName(), 
        PlayerData.getDefaultPlayerStats()
    )
    PlayerData.setPlayerData(playerStats)
        
func save_stats() -> void:
    Utils.saveDataToFile(getPlayerStatsFileName(), PlayerData.playerData)


func load_game() -> void:
    var saveGame = Utils.loadDataFromFile(
        getPlayerSaveFileName(), 
        PlayerData.getDefaultSaveGame(
            PlayerData.DIFFICULTIES.IM_TOO_SQUISHY_TO_DIE
        )
    )
    PlayerData.setSavedGame(saveGame)

func save_game() -> void:
    Utils.saveDataToFile(getPlayerSaveFileName(), PlayerData.savedGame)
    

#Retrieved from: https://docs.godotengine.org/en/3.1/getting_started/step_by_step/singletons_autoload.html#custom-scene-switcher
func goto_scene(path):
    # This function will usually be called from a signal callback,
    # or some other function in the current scene.
    # Deleting the current scene at this point is
    # a bad idea, because it may still be executing code.
    # This will result in a crash or unexpected behavior.

    # The solution is to defer the load to a later time, when
    # we can be sure that no code from the current scene is running:

    call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
    # It is now safe to remove the current scene
    current_scene.free()
    # Load the new scene.
    var s = ResourceLoader.load(path)

    # Instance the new scene.
    current_scene = s.instance()

    # Add it to the active scene, as child of root.
    get_tree().get_root().add_child(current_scene)

    # Optionally, to make it compatible with the SceneTree.change_scene() API.
    get_tree().set_current_scene(current_scene)
