extends KinematicBody2D

# some of these variables could be exported for easy modification
# in the editor's user interface
var acceleration: Vector2 = Vector2(600, 400)
var topSpeed: Vector2 = Vector2(400.0, 500.0)
var airControlModifier: Vector2 = Vector2(0.95, 0.0)

var friction: float = 0.90

var velocity: Vector2 = Vector2.ZERO
var gravity: float = 900.0

func _physics_process(delta: float) -> void:
    var leftToRightRatio: float =  Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
    # used to allow shorter jumps if jump button is released quickly
    var isJumpInterrupted: bool = Input.is_action_just_released("jump") and velocity.y < 0.0
    
    # want to feel instant and responsive, so don't bother with acceleration
    # i.e. just set their velocity to the jump acceleration.
    if Input.is_action_just_pressed("jump") and is_on_floor():
      velocity.y = -acceleration.y
      
    # checks if jump is interrupted, if so, stop player from moving up
    if isJumpInterrupted :
      velocity.y = 0.0
    
    # increases velocity on the x axis every frame
    velocity.x += (acceleration.x * leftToRightRatio * delta) 
    
    # If player is in the air, make it slower for them to move horizontally.
    if (velocity.y != 0):
        velocity.x *= airControlModifier.x
        
    
    velocity.y += gravity * delta
  
    # clamp velocity
    # Nice call Edward! - Isam
    velocity.x = clamp(velocity.x, -topSpeed.x, topSpeed.x)

    # Only apply friction if they aren't trying to move
    if ((!Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right"))
    # or if they hit both buttons, I know it sounds weird, but it feels right?
    or (Input.is_action_pressed("move_left") and Input.is_action_pressed("move_right"))
    ):
        velocity.x *= friction
    
    # removes jitter when player is slowing down
    # This used to be 10, 3 felt better and works with the numbers.
    if abs(velocity.x) < 3:
      velocity.x = 0
    
    # Godot's built in function to determine final velocity
    velocity = move_and_slide(velocity, Vector2.UP)
    
    
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass
