extends Node

# Loads data from a file. Creates and fills it with data if non-existent
# Requires
# -- fileName - string representing the file that will be accessed 
# Optional
# -- default  - A default object that will be written the file 
# -- isInst   - To allow for raw JSON, false
# -- encode   - whether the data is encoded and must be decoded 
func loadDataFromFile(fileName: String, default = null, isInst = true, encode = true):
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
        if encode:
            fileData = Marshalls.base64_to_variant(fileData)
        fileData = JSON.parse(fileData).result
        if isInst:
            fileData = dict2inst(fileData)
        # Return data as instance from the dictionary
        return fileData
    else:
        print("Could not find file \"" + fileName + "\" creating it now.")
        var file = File.new()
        # If we can't find the file,
        # create it with an empty dict by default
        file.open(fileName, File.WRITE)
        print("Writing data to \"" + fileName + "\":")
        print(default)
        var toStore = null
        if isInst:
            toStore = inst2dict(default)
        toStore = to_json(toStore)
        if encode:
            toStore = Marshalls.variant_to_base64(default)
        file.store_string(toStore)
        file.close()
        return default

# Tries to save data to a file.
# Will try to open the file first, and create it if it doesn't exist.
# Requires:
# -- fileName - the file that will be opened
# -- data     - the data that will be written into the file
# -- isInst   - if the stored data is an instance of a class
# -- encode   - whether to encode the data when saving
func saveDataToFile(fileName: String, data, var isInst=true, encode = true) -> void:
    var file = File.new()
    # Try to open the file, to create it if it doesn't exist.
    var _oldData = loadDataFromFile(fileName, null, isInst, encode)
    # Open the file
    file.open(fileName, File.WRITE)
    print("Writing data to \"" + fileName + "\":")
    # Print what we are about to write
    var toStore = data
    if isInst:
        toStore = inst2dict(data)
    toStore = to_json(toStore)
    print(toStore)
    
    if encode:
        toStore = Marshalls.variant_to_base64(toStore)
    # Write the data
    file.store_string(
        str(toStore)
    )
    file.close()

# Just a wrapper function, easier to read.
func doesFileExist(fileName: String) -> bool:
    if Globals.TESTS:
        return false
    return File.new().file_exists(fileName)  

var current_scene = null
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

# You seem a little lost...
func n(h):
    # You could only get here by trying to investigate some code...
    # Is it perhaps the code I told you to avoid?
    # If you didn't stop by now, I hoped you enjoyed my
    # lecture on CodeMinification101.
    # Thanks for coming to my TedTalk
    return h.get_string_from_utf8()
