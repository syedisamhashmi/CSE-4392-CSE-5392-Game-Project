extends Node

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
