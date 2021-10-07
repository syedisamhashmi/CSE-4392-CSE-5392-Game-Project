extends Node

# Loads data from a file. Creates and fills it with data if non-existent
# Requires
# -- fileName - string representing the file that will be accessed 
# Optional
# -- default  - A default dictionary (JSON) object that will be written the file 
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

# Tries to save data to a file.
# Will try to open the file first, and create it if it doesn't exist.
# Requires:
# -- fileName - the file that will be opened
# -- data     - the data that will be written into the file
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

# Just a wrapper function, easier to read.
func doesFileExist(fileName: String) -> bool:
    return ResourceLoader.exists(fileName)  
