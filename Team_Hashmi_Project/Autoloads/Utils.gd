extends Node

# Loads data from a file. Creates and fills it with data if non-existent
# Requires
# -- fileName - string representing the file that will be accessed 
# Optional
# -- default  - A default object that will be written the file 
func loadDataFromFile(fileName: String, default):
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
        # Return data as instance from the dictionary
        return dict2inst(
            # of the json
            JSON.parse(
                # decoded from the file data
                Marshalls.base64_to_variant(fileData)
            ).result
        )
    else:
        print("Could not find file \"" + fileName + "\" creating it now.")
        var file = File.new()
        # If we can't find the file,
        # create it with an empty dict by default
        file.open(fileName, File.WRITE)
        print("Writing data to \"" + fileName + "\":")
        print(default)
        file.store_string(
            # Store data as base64
            Marshalls.variant_to_base64(
                # of the json
                to_json(
                    # of the class instance as a dictionary 
                    inst2dict(default)
                )
            )
        )
        file.close()
        return default

# Tries to save data to a file.
# Will try to open the file first, and create it if it doesn't exist.
# Requires:
# -- fileName - the file that will be opened
# -- data     - the data that will be written into the file
func saveDataToFile(fileName: String, data) -> void:
    var file = File.new()
    # Try to open the file, to create it if it doesn't exist.
    var _oldData = loadDataFromFile(fileName, null)
    # Open the file
    file.open(fileName, File.WRITE)
    print("Writing data to \"" + fileName + "\":")
    # Print what we are about to write
    print(Marshalls.variant_to_base64(to_json(inst2dict(data))))
    # Write the data
    file.store_string(
        # As base64 encoded
        Marshalls.variant_to_base64(
            #JSON
            to_json(
                # of the class instance as a dictionary 
                inst2dict(data)
            )
        )
    )
    file.close()

# Just a wrapper function, easier to read.
func doesFileExist(fileName: String) -> bool:
    return ResourceLoader.exists(fileName)  

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
