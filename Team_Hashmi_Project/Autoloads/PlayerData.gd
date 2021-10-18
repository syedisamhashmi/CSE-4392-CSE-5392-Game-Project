extends Node

var saveSlot: int = 0 setget setSaveSlot, getSaveSlot
func getSaveSlot() -> int:
    return saveSlot
func setSaveSlot(i: int) -> void:
    saveSlot = i

#region PlayerStats
# Various keys in our stat tracker
var BFG9000_SHOTS_FIRED: String = "BFG9000ShotsFired"
var PUNCHES_THROWN: String = "punchesThrown"
var JUMP_COUNT: String = "jumpCount"
var BANANAS_THROWN: String = "bananasThrown"
# Object containing default values for player statistics
var DEFAULT_PLAYER_STATS: Dictionary = {
    PUNCHES_THROWN: 0,
    BANANAS_THROWN: 0,
    BFG9000_SHOTS_FIRED: 0,
    JUMP_COUNT: 0
}
func getDefaultPlayerStats() -> Dictionary:
    return DEFAULT_PLAYER_STATS 

#region jumpCount
func getJumpCount() -> int:
    if !playerData.has(JUMP_COUNT):
        setJumpCount(0)
        return 0
    return playerData[JUMP_COUNT]
func setJumpCount(a) -> void:
    playerData[JUMP_COUNT] = a
#endregion
#region bananasThrown
func getBananasThrown() -> int:
    if !playerData.has(BANANAS_THROWN):
        setBananasThrown(0)
        return 0
    return playerData[BANANAS_THROWN]
func setBananasThrown(a) -> void:
    playerData[BANANAS_THROWN] = a
#endregion
#region bfg9000ShotsFired
func getBFG9000ShotsFired() -> int:
    if !playerData.has(BFG9000_SHOTS_FIRED):
        setBFG9000ShotsFired(0)
        return 0
    return playerData[BFG9000_SHOTS_FIRED]
func setBFG9000ShotsFired(a) -> void:
    playerData[BFG9000_SHOTS_FIRED] = a
#endregion
#region punchesThrown
func getPunchesThrown() -> int:
    if !playerData.has(PUNCHES_THROWN):
        setJumpCount(0)
        return 0
    return playerData[PUNCHES_THROWN]
func setPunchesThrown(a) -> void:
    playerData[PUNCHES_THROWN] = a
#endregion

var playerData: Dictionary = {} setget setPlayerData, getPlayerData
func getPlayerData() -> Dictionary:
    return playerData
func setPlayerData(a) -> void:
    playerData = a
#endregion

#region SaveData

# Likely can use these as multipliers to reduce 
# player damage and increase enemy health
const DIFFICULTIES_I = [1,2,3,4] 
# If you get this throwback, we can be friends :)
const DIFFICULTIES = {
    CAN_I_PLAY_DADDY      = "Can I Play, Daddy?",      # Easy
    IM_TOO_SQUISHY_TO_DIE = "I'm too squishy to die!", # Medium
    BRUISE_ME_PLENTY      = "Bruise Me Plenty",        # Hard
    I_AM_BANANA_INCARNATE = "I Am Banana Incarnate!",  # Nightmare   
}
const DIFFICULTIES_DESCRIPTIONS = [
    """Gameplay for babies. (i.e. Dr. Dalio)
    - Forgiving gameplay
    - Slow and methodical, 
      large damage cooldown after being hit.
    - Lots of health pickups
    - Lots of ammo pickups 
    """,
    """
    If you heard the saying "If you can't handle the heat, get out of the kitchen". 
    You probably left the kitchen...
    - Enemies are not so kind.
    - Smaller damage cooldowns.
    - Lots of health pickups
    - Lots of ammo pickups
    """, # Medium
    
    """So, you think you are worthy... This is a challenge.
    - Enemies are aggresive
    - No rushing, but you might want to be in a hurry.
    - Fewer health pickups
    - Fewer ammo pickups
    """,
    
    """This is a literal nightmare.
    - Enemies are potassium-thirsty and aggressive.
    - Damage cooldown is practically non-existent.
    - Health pickups are rare. Be wise.
    - Ammo pickups are rare. Be wise.
    """   
]

const ExitMessages = [
    "Don't leave yet -- There's a banana around that corner!",
    "Are you sure you want to quit this amazing game?",
    "Look, man. You leave now and you forfeit your stats!",
    "Just leave. When you come back, I'll be waiting with a banana.",
    "You're lucky I don't delete your save game for thinking about leaving.",
    "Get outta here and go back to your boring life."
]


# Various keys that will be in save data
var IS_MELEE_UNLOCKED:        String = "isMeleeUnlocked"
var IS_BANANA_THROW_UNLOCKED: String = "isBananaThrowUnlocked"
var BANANA_THROW_AMMO:        int    = 0
var IS_BFG9000_UNLOCKED:      String = "isBFG9000Unlocked"
var DIFFICULTY:               String = "difficulty"
var PLAYER_HEALTH:            String = "playerHealth"
var PLAYER_MOVE_SPEED:        String = "playerMoveSpeed"
var PLAYER_JUMP_HEIGHT:       String = "playerJumpHeight"
var CURRENT_WEAPON:           String = "currentWeapon"

# ? Object containing default values for game save data
# Should be called when creating a new save game
# Returns the default state with the difficulty
func getDefaultSaveGame(difficulty: int) -> Dictionary:
    return {
        PLAYER_HEALTH           : PlayerDefaults.DEFAULT_PLAYER_HEALTH,
        CURRENT_WEAPON          : PlayerDefaults.DEFAULT_WEAPON,   # Melee
        IS_MELEE_UNLOCKED       : PlayerDefaults.IS_MELEE_UNLOCKED,
        IS_BANANA_THROW_UNLOCKED: PlayerDefaults.IS_BANANA_THROW_UNLOCKED,
        BANANA_THROW_AMMO       : 0,
        # Banana Flinging Gun 9000 ;)
        IS_BFG9000_UNLOCKED     : PlayerDefaults.IS_BFG9000_UNLOCKED,
        DIFFICULTY              : difficulty,
        PLAYER_MOVE_SPEED       : PlayerDefaults.PLAYER_MOVE_SPEED,
        PLAYER_JUMP_HEIGHT      : PlayerDefaults.PLAYER_JUMP_HEIGHT,
    }
#region Difficulty
func getDifficulty() -> int:
    if !savedGame.has(DIFFICULTY):
        setDifficulty(PlayerDefaults.DEFAULT_DIFFICULTY)
        return PlayerDefaults.DEFAULT_DIFFICULTY
    return savedGame[DIFFICULTY]
func setDifficulty(a) -> void:
    savedGame[DIFFICULTY] = a
#endregion
#region PlayerHealth
func getPlayerHealth() -> int:
    if !savedGame.has(PLAYER_HEALTH):
        setCurrentWeapon(PlayerDefaults.DEFAULT_PLAYER_HEALTH)
        return PlayerDefaults.DEFAULT_PLAYER_HEALTH
    return savedGame[PLAYER_HEALTH]
func setPlayerHealth(a) -> void:
    savedGame[PLAYER_HEALTH] = a
#endregion
#region CurrentWeapon
func getCurrentWeapon() -> int:
    if !savedGame.has(CURRENT_WEAPON):
        setCurrentWeapon(PlayerDefaults.CURRENT_WEAPON)
        return PlayerDefaults.DEFAULT_WEAPON
    return savedGame[CURRENT_WEAPON]
func setCurrentWeapon(a) -> void:
    savedGame[CURRENT_WEAPON] = a
#endregion
#region IsMeleeUnlocked
func getIsMeleeUnlocked() -> bool:
    if !savedGame.has(IS_MELEE_UNLOCKED):
        setIsMeleeUnlocked(PlayerDefaults.IS_MELEE_UNLOCKED)
        return PlayerDefaults.IS_MELEE_UNLOCKED
    return savedGame[IS_MELEE_UNLOCKED]
func setIsMeleeUnlocked(a) -> void:
    savedGame[IS_MELEE_UNLOCKED] = a
#endregion
#region IsBFG9000Unlocked
func getIsBFG9000Unlocked() -> bool:
    if !savedGame.has(IS_BFG9000_UNLOCKED):
        setIsBFG9000Unlocked(PlayerDefaults.IS_BFG9000_UNLOCKED)
        return PlayerDefaults.IS_BFG9000_UNLOCKED
    return savedGame[IS_BFG9000_UNLOCKED]
func setIsBFG9000Unlocked(a) -> void:
    savedGame[IS_BFG9000_UNLOCKED] = a
#endregion
#region IsBananaThrowUnlocked
func getIsBananaThrowUnlocked() -> bool:
    if !savedGame.has(IS_BANANA_THROW_UNLOCKED):
        setIsBananaThrowUnlocked(PlayerDefaults.IS_BANANA_THROW_UNLOCKED)
        return PlayerDefaults.IS_BANANA_THROW_UNLOCKED
    return savedGame[IS_BANANA_THROW_UNLOCKED]
func setIsBananaThrowUnlocked(a) -> void:
    savedGame[IS_BANANA_THROW_UNLOCKED] = a
#endregion

#region BananaThrowAmmo
func getBananaThrowAmmo() -> int:
    if !savedGame.has(BANANA_THROW_AMMO):
        setBananaThrowAmmo(PlayerDefaults.BANANA_THROW_AMMO)
        return PlayerDefaults.BANANA_THROW_AMMO
    return savedGame[BANANA_THROW_AMMO]
func setBananaThrowAmmo(a) -> void:
    savedGame[BANANA_THROW_AMMO] = a
#endregion

#region PlayerMoveSpeed
func getPlayerMoveSpeed() -> float:
    if !savedGame.has(PLAYER_MOVE_SPEED):
        setIsMeleeUnlocked(PlayerDefaults.PLAYER_MOVE_SPEED)
        return PlayerDefaults.PLAYER_MOVE_SPEED
    return savedGame[PLAYER_MOVE_SPEED]
func setPlayerMoveSpeed(a) -> void:
    savedGame[PLAYER_MOVE_SPEED] = a
#endregion
#region PlayerJumpHeight
func getPlayerJumpHeight() -> float:
    if !savedGame.has(PLAYER_JUMP_HEIGHT):
        setIsMeleeUnlocked(PlayerDefaults.PLAYER_JUMP_HEIGHT)
        return PlayerDefaults.PLAYER_JUMP_HEIGHT
    return savedGame[PLAYER_JUMP_HEIGHT]
func setPlayerJumpHeight(a) -> void:
    savedGame[PLAYER_JUMP_HEIGHT] = a
#endregion

var savedGame: Dictionary = {} setget setSavedGame, getSavedGame
func getSavedGame() -> Dictionary:
    return savedGame
func setSavedGame(a) -> void:
    savedGame = a
#endregion
