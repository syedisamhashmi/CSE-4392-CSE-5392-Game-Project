extends KinematicBody2D


var velocity: Vector2 = Vector2.ZERO
var gravity: float = 900.0
var move_speed: Vector2 = Vector2(300.0, 500.0)

func _physics_process(delta: float) -> void:
    var isJumpInterrupted = Input.is_action_just_released("jump") and velocity.y < 0
    var direction: Vector2 = Vector2(
        Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
        -1 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
    )
    velocity.x += (move_speed.x * direction.x) * delta
    if velocity.x > move_speed.x:
        velocity.x = move_speed.x
    
    velocity.y += gravity * delta
    if direction.y == -1:
        velocity.y = move_speed.y * direction.y
        
    if isJumpInterrupted:
        velocity.y = 0
    if (
        (!Input.is_action_pressed("move_left") and
        !Input.is_action_pressed("move_right")) or
        Input.is_action_just_released("move_left") or 
        Input.is_action_just_released("move_right")):
        velocity.x /= 1.1   
    velocity = move_and_slide(velocity, Vector2.UP)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass
