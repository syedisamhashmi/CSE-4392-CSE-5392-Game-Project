extends Node

# State for what a player save should look like.
# This class is serialized and stored in a file.
# To extend it, just add a property access it, call save.
#   the rest should be handled.

var playerHealth            : float = PlayerDefaults.DEFAULT_PLAYER_HEALTH
var currentWeapon           : int   = PlayerDefaults.DEFAULT_WEAPON  # Melee
var isMeleeUnlocked         : bool  = PlayerDefaults.IS_MELEE_UNLOCKED
var isBananaThrowUnlocked   : bool  = PlayerDefaults.IS_BANANA_THROW_UNLOCKED
var bananaThrowAmmo         : int   = 0
# Banana Flinging Gun 9000 ;)
var isBFG9000Unlocked       : bool  = PlayerDefaults.IS_BFG9000_UNLOCKED
var BFG9000Ammo             : int   = 0
var isBananaBlasterUnlocked : bool  = PlayerDefaults.IS_BANANA_BLASTER_UNLOCKED
var bananaBlasterAmmo       : int   = 0
var difficulty              : int   = PlayerDefaults.DEFAULT_DIFFICULTY
var playerMoveSpeed         : float = PlayerDefaults.PLAYER_MOVE_SPEED
var playerJumpHeight        : float = PlayerDefaults.PLAYER_JUMP_HEIGHT
var gasMaskUnlocked         : bool  = false
var spikeArmorUnlocked      : bool  = false
var levelNum                : int   = 0
var retrievedPickups        : Array = []
var completedTriggers       : Array = []
var enemiesData             : Dictionary = {}
var playerPosX              : float = -9999
var playerPosY              : float = -9999
var currSong                : String = ""

func init(_difficulty: int = -1):
    if difficulty == -1:
        difficulty              = PlayerDefaults.DEFAULT_DIFFICULTY
    else:
        self.difficulty = _difficulty
    playerHealth            = PlayerDefaults.DEFAULT_PLAYER_HEALTH
    currentWeapon           = PlayerDefaults.DEFAULT_WEAPON  # Melee
    isMeleeUnlocked         = PlayerDefaults.IS_MELEE_UNLOCKED
    isBananaThrowUnlocked   = PlayerDefaults.IS_BANANA_THROW_UNLOCKED
    bananaThrowAmmo         = 0
    # Banana Flinging Gun 9000 ;)
    isBFG9000Unlocked       = PlayerDefaults.IS_BFG9000_UNLOCKED
    BFG9000Ammo             = 0
    isBananaBlasterUnlocked = PlayerDefaults.IS_BANANA_BLASTER_UNLOCKED
    bananaBlasterAmmo       = 0
    playerMoveSpeed         = PlayerDefaults.PLAYER_MOVE_SPEED
    playerJumpHeight        = PlayerDefaults.PLAYER_JUMP_HEIGHT
    gasMaskUnlocked         = false
    spikeArmorUnlocked      = false
    levelNum                = 0
    retrievedPickups        = []
    completedTriggers       = []
    enemiesData             = {}
    playerPosX              = -9999
    playerPosY              = -9999
    currSong                = ""
    return self

