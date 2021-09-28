extends KinematicBody2D

# some of these variables could be exported for easy modification
# in the editor's user interface
var topSpeed: float = 1000.0
var acceleration: float = 0.0
var friction: float = 0.05
var velocity: Vector2 = Vector2.ZERO
var gravity: float = 900.0

func _physics_process(delta: float) -> void:
    # control player through acceleration to give good sense of momentum
    if Input.is_action_pressed("move_right"):
      acceleration = 2500
    elif Input.is_action_pressed("move_left"):
      acceleration = -2500
    else:
      acceleration = 0
    
    # used to allow shorter jumps if jump button is released quickly
    var isJumpInterrupted : = Input.is_action_just_released("jump") and velocity.y < 0.0
    
    # want to feel instan and responsivet, so don't bother with acceleration
    if Input.is_action_just_pressed("jump") and is_on_floor():
      velocity.y = -400
      
    # checks if jump is interrupted
    if isJumpInterrupted :
      velocity.y = 0.0
    
    # increases velocity on the x axis every frame
    # friction slows the player down over time
    velocity.x += acceleration * delta
    velocity.x *= (1 - friction)
    
    velocity.y += gravity * delta
    
    # clamp velocity
    velocity.x = clamp(velocity.x, -1 * topSpeed, topSpeed)
    
    # removes jitter when player is slowing down
    if abs(velocity.x) < 10:
      velocity.x = 0
    
    # Godot's built in function to determine final velocity
    velocity = move_and_slide(velocity, Vector2.UP)
    
    
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass
