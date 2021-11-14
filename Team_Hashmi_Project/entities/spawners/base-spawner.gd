extends Node2D

# warning-ignore:unused_class_variable
export var id: String = "update-me"
# warning-ignore:unused_class_variable
export(EntityTypeEnums.SPAWNER_TYPE) var type = EntityTypeEnums.SPAWNER_TYPE.NONE
export(PackedScene) var typeToSpawn: PackedScene
export var randomTimeDelay: float = 5000
export var spawnDelayMs: float = 0
var spawnStart = OS.get_system_time_msecs()

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var calcdRandom
func _ready() -> void:
    rng.randomize()
    calcdRandom = randomTimeDelay

func _process(_delta: float) -> void:
    if typeToSpawn == null:
        pass
    if OS.get_system_time_msecs() - spawnStart > (spawnDelayMs + calcdRandom):
        calcdRandom = rng.randf_range(-1, 1) * randomTimeDelay
        spawnStart = OS.get_system_time_msecs()
        var newObj = typeToSpawn.instance()
        newObj = setUpObj(newObj)
        call_deferred("add_child", newObj)

func setUpObj(newObj):
    return newObj
