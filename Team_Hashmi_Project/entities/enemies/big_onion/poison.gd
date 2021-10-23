extends Node2D

var currBody

var dmgStart = 0

var difficulty = PlayerData.savedGame.difficulty
var dmgTimeout = 500
var DAMAGE_TIMEOUT_HANDICAP = 50
var velocity: Vector2 = Vector2.UP

func init(_position:Vector2, _velocity: Vector2) -> void:
    self.position = _position
    self.velocity.x = _velocity.x

func _ready() -> void:
    difficulty = PlayerData.savedGame.difficulty
#    $Image.speed_scale /= difficulty 
    dmgTimeout -= DAMAGE_TIMEOUT_HANDICAP * difficulty
    position.y += velocity.y
    $Image.playing = true
    
func _physics_process(_delta: float) -> void:
    if currBody != null:
        _on_PoisonArea_body_entered(currBody)
    position += velocity

func _on_PoisonArea_body_entered(body: Node) -> void:
    if (
        body.has_method("damage") and 
        OS.get_system_time_msecs() - dmgStart > dmgTimeout
    ):
        dmgStart = OS.get_system_time_msecs()
        currBody = body
        body.damage(1, 1)
        

func _on_PoisonArea_body_exited(_body: Node) -> void:
    currBody = null


func _on_Image_animation_finished() -> void:
    self.queue_free()
