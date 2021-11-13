extends "res://entities/enemies/enemy_base/enemy_base.gd"

# Highway to the....
var DANGER_ZONE = 50
var SPIKE_DAMAGE = 5
var currBody
var SPIKE_DAMAGE_HANDICAP = 2
var difficulty = PlayerDefaults.DEFAULT_DIFFICULTY
export var deployed = false
func _ready() -> void:
    usePhys = false
    difficulty = PlayerData.savedGame.difficulty
    SPIKE_DAMAGE += (SPIKE_DAMAGE_HANDICAP * difficulty)
    if deployed:
        $Image.playing = true

func _physics_process(_delta):
    if currBody != null:
        _on_SpikeArea_body_entered(currBody)

func player_location_changed(_position: Vector2):
    if !Globals.inGame:
        return
    
    var dist = self.position.distance_to(_position)
    # If player is close to the spike
    if (abs(dist) < DANGER_ZONE):
        $Image.playing = true
        
func damage(_damage: float, knockback, isPunch : bool  = false, punchNum = 0) -> bool:
    var _x = knockback
    var _y = isPunch
    var _z = punchNum
    return false


func _on_Image_animation_finished() -> void:
    $SpikeArea/SpikeAreaCollider.set_deferred("disabled", false)
    deployed = true
    updateEnemyDetails(id)

func _on_SpikeArea_body_entered(body: Node) -> void:
    if !body.save.spikeArmorUnlocked and body.has_method("damage"):
        currBody = body
        body.damage(SPIKE_DAMAGE * body.velocity.sign().x , -body.velocity.sign().x)


func _on_SpikeArea_body_exited(_body: Node) -> void:
    currBody = null
