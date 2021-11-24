extends Node
# State for what player stats should look like.
# This class is serialized and stored in a file.
# To extend it, just add a property access it, call save.
#   the rest should be handled.

var punchesThrown           : int   = 0
var bananasThrown           : int   = 0
var bfg9000ShotsFired       : int   = 0
var bananaBlasterShotsFired : int   = 0
var jumpCount               : int   = 0
var playerDamageReceived    : float = 0
var playerDamageDealt       : float = 0
var playerDeathCount        : int   = 0
var gameTime                : float = 0


func init():
    punchesThrown           = 0
    bananasThrown           = 0
    bfg9000ShotsFired       = 0
    bananaBlasterShotsFired = 0
    jumpCount               = 0
    playerDamageReceived    = 0
    playerDamageDealt       = 0
    playerDeathCount        = 0
    gameTime                = 0
    return self
