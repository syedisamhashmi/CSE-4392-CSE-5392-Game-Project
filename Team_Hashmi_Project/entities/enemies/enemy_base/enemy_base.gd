extends KinematicBody2D

var hitOnPunchNum: int = 0

var velocity: Vector2 = Vector2.ZERO
var gravity: float = 900.0
var friction: float = .95

func _ready() -> void: 
    # warning-ignore:return_value_discarded
    Signals.connect("player_location_changed", self, "player_location_changed")

func player_location_changed(_position: Vector2):
    pass

func _physics_process(delta: float) -> void:
    velocity.y += gravity * delta
    velocity.x *= friction;
    
    if abs(velocity.x) < 5 and is_on_floor():
        velocity = Vector2.ZERO
    # Godot's built in function to determine final velocity
    velocity = move_and_slide(velocity, Vector2.UP)
    
func damage(knockback, isPunch : bool  = false):
    # Stops one punch from hitting multiple times.
    # If current punch # is the same as the one we were hit on
    if isPunch && PlayerData.getPunchesThrown() == hitOnPunchNum:
        # Don't take damage.
        return
    else:
        # This is a new punch, store current punch num
        hitOnPunchNum = PlayerData.getPunchesThrown()
        
    # Determined that it is a new punch, so take damage 
    damage_flash_effect()
    
    # pushes the enemy away from the player depending on the projectile speed
    # also knocks the enemy slightly up into the air
    velocity.x += knockback
    velocity.y += -abs(knockback)

func damage_flash_effect():
    $damage_sound.play()
    $Image.material.set_shader_param("intensity", 0.75)
    yield(get_tree().create_timer(0.1), "timeout")
    $Image.material.set_shader_param("intensity", 0.0)
  
