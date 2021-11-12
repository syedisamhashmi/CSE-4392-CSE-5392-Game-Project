extends Node

# State for what a player save should look like.
# This class is serialized and stored in a file.
# To extend it, just add a property access it, call save.
#   the rest should be handled.

# warning-ignore:unused_class_variable
var playerHealth            : float = PlayerDefaults.DEFAULT_PLAYER_HEALTH
# warning-ignore:unused_class_variable
var currentWeapon           : int   = PlayerDefaults.DEFAULT_WEAPON  # Melee
# warning-ignore:unused_class_variable
var isMeleeUnlocked         : bool  = PlayerDefaults.IS_MELEE_UNLOCKED
# warning-ignore:unused_class_variable
var isBananaThrowUnlocked   : bool  = PlayerDefaults.IS_BANANA_THROW_UNLOCKED
# warning-ignore:unused_class_variable
var bananaThrowAmmo         : int   = 0
# Banana Flinging Gun 9000 ;)
# warning-ignore:unused_class_variable
var isBFG9000Unlocked       : bool  = PlayerDefaults.IS_BFG9000_UNLOCKED
# warning-ignore:unused_class_variable
var BFG9000Ammo             : int = 0
# warning-ignore:unused_class_variable
var isBananaBlasterUnlocked  : bool  = PlayerDefaults.IS_BANANA_BLASTER_UNLOCKED
# warning-ignore:unused_class_variable
var bananaBlasterAmmo       : int = 0
# warning-ignore:unused_class_variable
var difficulty              : int   = PlayerDefaults.DEFAULT_DIFFICULTY
# warning-ignore:unused_class_variable
var playerMoveSpeed         : float = PlayerDefaults.PLAYER_MOVE_SPEED
# warning-ignore:unused_class_variable
var playerJumpHeight        : float = PlayerDefaults.PLAYER_JUMP_HEIGHT
# warning-ignore:unused_class_variable
var gasMaskUnlocked         : bool  = false
# warning-ignore:unused_class_variable
var levelNum                : int   = 0
var retrievedPickups        : Array = []
# warning-ignore:unused_class_variable
var completedTriggers       : Array = []
# warning-ignore:unused_class_variable
var enemiesData             : Dictionary = {}
# warning-ignore:unused_class_variable
var playerPosX              : float = -9999
# warning-ignore:unused_class_variable
var playerPosY              : float = -9999

func init(_difficulty: int):
    self.difficulty = _difficulty
    return self

