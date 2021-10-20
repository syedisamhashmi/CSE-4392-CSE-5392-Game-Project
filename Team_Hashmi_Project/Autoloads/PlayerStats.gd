extends Node
# State for what player stats should look like.
# This class is serialized and stored in a file.
# To extend it, just add a property access it, call save.
#   the rest should be handled.

# warning-ignore:unused_class_variable
var punchesThrown        : int = 0
# warning-ignore:unused_class_variable
var bananasThrown        : int = 0
# warning-ignore:unused_class_variable
var bfg9000ShotsFired    : int = 0
# warning-ignore:unused_class_variable
var jumpCount            : int = 0
# warning-ignore:unused_class_variable
var playerDamageReceived : float = 0
# warning-ignore:unused_class_variable
var playerDamageDealt    : float = 0

func init():
    return self
