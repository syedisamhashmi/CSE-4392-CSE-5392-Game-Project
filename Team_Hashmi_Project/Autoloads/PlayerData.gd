extends Node

var playerData: Dictionary = {} setget setPlayerData, getPlayerData


var SHOTS_FIRED: String = "shotsFired"
var JUMP_COUNT: String = "jumpCount"

#region jumpCount
func getJumpCount() -> int:
    if !playerData.has(JUMP_COUNT):
        setJumpCount(0)
        return 0
    return playerData[JUMP_COUNT]
func setJumpCount(a) -> void:
    playerData[JUMP_COUNT] = a
#endregion

#region shotsFired
func getShotsFired() -> int:
    if !playerData.has(SHOTS_FIRED):
        setShotsFired(0)
        return 0
    return playerData[SHOTS_FIRED]
func setShotsFired(a) -> void:
    playerData[SHOTS_FIRED] = a
#endregion

func getPlayerData() -> Dictionary:
    return playerData
func setPlayerData(a) -> void:
    playerData = a
