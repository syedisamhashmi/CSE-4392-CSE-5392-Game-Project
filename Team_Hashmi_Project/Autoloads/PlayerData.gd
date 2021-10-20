extends Node

# General player related data.
# - Saved game slot in use
# - Player stats for that slot
# - Current save game state 
# ! - THIS IS STORED ON THE PLAYER OBJ
# ! - for future multiplayer to keep state separate
# !   (may be dirty, caller has to call Globals.save_game)

# warning-ignore:unused_class_variable
var saveSlot: int = 0 
# warning-ignore:unused_class_variable
var playerStats: PlayerStats = PlayerStats.init() 
# warning-ignore:unused_class_variable
var savedGame: PlayerSave = PlayerSave.init(1) 
