extends Node2D

export var speedScale = 1.0
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
    # TODO: thinking to maybe reduce this so it doesnt die
    # TODO: this would make the gas mask useful in a room full of poison gas.
    $Image.speed_scale = speedScale 
    dmgTimeout -= DAMAGE_TIMEOUT_HANDICAP * difficulty
    position.y += velocity.y
    $Image.playing = true
    
func _physics_process(_delta: float) -> void:
    if !Globals.inGame:
        $Image.playing = false
        return
    else:
        $Image.playing = true
    if currBody != null:
        _on_PoisonArea_body_entered(currBody)
    position += velocity

func _on_PoisonArea_body_entered(body: Node) -> void:
    if (
        body.has_method("damage") and 
        OS.get_system_time_msecs() - dmgStart > dmgTimeout
    ):
        if body.save.gasMaskUnlocked:
            return
        dmgStart = OS.get_system_time_msecs()
        currBody = body
        body.damage(1, 1)
        

func _on_PoisonArea_body_exited(_body: Node) -> void:
    currBody = null


func _on_Image_animation_finished() -> void:
    self.queue_free()
