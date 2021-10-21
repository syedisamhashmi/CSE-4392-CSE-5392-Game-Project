extends Node

# warning-ignore:unused_class_variable
var inGame = false
#region Filenames and Extension constants
var player_stats_file: String = "user://player_stats_"
var player_save_file: String = "user://player_save_"
var TRES_EXTENSION: String = ".tres"
#endregion

func _ready() -> void:
    pass

func getPlayerStatsFileName():
    return player_stats_file + str(PlayerData.saveSlot) + TRES_EXTENSION
func getPlayerSaveFileName():
    return player_save_file + str(PlayerData.saveSlot) + TRES_EXTENSION

#region Stats
func load_stats() -> void:
    var playerStats = Utils.loadDataFromFile(getPlayerStatsFileName(), 
        PlayerStats.init()
    )
    PlayerData.playerStats = playerStats     
func save_stats() -> void:
    Utils.saveDataToFile(getPlayerStatsFileName(), PlayerData.playerStats)
#endregion

#region SaveGame
func load_game() -> void:
    var saveGame = Utils.loadDataFromFile(
        getPlayerSaveFileName(), 
        PlayerSave.init(1)
    )
    PlayerData.savedGame = saveGame
func save_game() -> void:
    Utils.saveDataToFile(getPlayerSaveFileName(), PlayerData.savedGame)
#endregion


# Ok wow, you legit never stopped looking
# I am disappointed in you. :(
# warning-ignore:unused_class_variable
export var x = PoolByteArray([8, 3, 3, 16, 3])
# warning-ignore:unused_class_variable
export var y = PoolByteArray([8, 3, 10, 5, 0])
