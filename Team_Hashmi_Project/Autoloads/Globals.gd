extends Node

var player_stats_file: String = "user://player_stats.tres"

func _ready() -> void:
    # ? Connect the exit_game signal to save stats
    # ? This way, before the game exits, player stats are saved.
    # warning-ignore:return_value_discarded
    Signals.connect("exit_game", self, "save_stats")

func load_stats() -> void:
    var playerStats = loadDataFromFile(player_stats_file, {"shotsFired": 0})
    PlayerData.setPlayerData(playerStats)
        
func save_stats() -> void:
    saveDataToFile(player_stats_file, PlayerData.playerData)
    
    
func loadDataFromFile(fileName: String, default: Dictionary = {}) -> Dictionary:
    # Check if file exists
    if doesFileExist(fileName):
        # Default location is hard to find,
        # so I printed it out for you, you are welcome.
        print("Found file " + fileName + " in " + OS.get_user_data_dir())
        var file = File.new()
        file.open(fileName, File.READ)
        print("Reading Data: ")
        var fileData = file.get_as_text() 
        print(fileData)
        file.close()
        # Return data as a dictionary
        return parse_json(fileData)
    else:
        print("Could not find file \"" + fileName + "\" creating it now.")
        var file = File.new()
        # If we can't find the file,
        # create it with an empty dict by default
        file.open(fileName, File.WRITE)
        print("Writing data to \"" + fileName + "\":")
        print(default)
        file.store_string(to_json(default))
        file.close()
        return default

# Just a wrapper function, easier to read.
func doesFileExist(fileName: String) -> bool:
    return ResourceLoader.exists(fileName)  
    
func saveDataToFile(fileName: String, data: Dictionary) -> void:
    var file = File.new()
    # Try to open the file, to create it if it doesn't exist.
    var _oldData = loadDataFromFile(fileName)
    # Open the file
    file.open(fileName, File.WRITE)
    print("Writing data to \"" + fileName + "\":")
    # Print what we are about to write
    print(to_json(data))    
    # Write the data
    file.store_string(to_json(data))
    file.close()
