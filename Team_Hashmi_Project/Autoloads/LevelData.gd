extends Node

#region Player 
# warning-ignore:unused_class_variable
var playerStartX: float = 0
# warning-ignore:unused_class_variable
var playerStartY: float = 0
#endregion

#region Map
# warning-ignore:unused_class_variable
var backgroundPath: String = ""
# warning-ignore:unused_class_variable
var backgroundMotionScaleX: float = 0
# warning-ignore:unused_class_variable
var backgroundMotionScaleY: float = 0
# warning-ignore:unused_class_variable
var backgroundPosX: float = 0
# warning-ignore:unused_class_variable
var backgroundPosY: float = 0
# warning-ignore:unused_class_variable
var backgroundSizeX: float = 0
# warning-ignore:unused_class_variable
var backgroundSizeY: float = 0

# warning-ignore:unused_class_variable
var layer2MotionScaleX: float = 0
# warning-ignore:unused_class_variable
var layer2MotionScaleY: float = 0
# warning-ignore:unused_class_variable
var layer2: = []
# warning-ignore:unused_class_variable
var layer3MotionScaleX: float = 0
# warning-ignore:unused_class_variable
var layer3MotionScaleY: float = 0
# warning-ignore:unused_class_variable
var layer3: = []


# warning-ignore:unused_class_variable
var tiles:              = []
# warning-ignore:unused_class_variable
var pickups:            = []
# warning-ignore:unused_class_variable
var enemies:            = []
# warning-ignore:unused_class_variable
var triggers:           = []
# warning-ignore:unused_class_variable
var spawners:           = []
#endregion


func init():
    return self
