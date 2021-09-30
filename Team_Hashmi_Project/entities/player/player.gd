extends KinematicBody2D

#REGION PRELOAD
var PLAYER_PROJECTILE = preload("res://entities/player_projectile/player_projectile.tscn")
#ENDREGION

# Half of the players width, determines where the projectile is spawned horizontally
var halfWidth = 24 
# Half of the players height, determines where the projectile is spawned vertically
var halfHeight = 40 

# These are very sensitive, change with care
var projectile_speed: Vector2 = Vector2(4, -4)

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
    
func _input(event: InputEvent) -> void:
    if (event.is_action_pressed("fire_projectile")):
        spawnPlayerProjectile()
        pass

func spawnPlayerProjectile() -> void:
    var projectile_instance = PLAYER_PROJECTILE.instance()
    
    var projectile_speed_to_use = projectile_speed
    if velocity.x < 0:
        projectile_speed_to_use.x *= -1
     
    # Add some of the players velocity to the projectile
    # horizontally so that it doesn't exactly go behind the player
    # NOT vertically, feels off to do that.
    projectile_speed_to_use.x = (projectile_speed_to_use.x + (velocity.x / 60))
    projectile_instance.init(
        # Add projectile halfway up the player so that it
        # spawns in a good place.
        Vector2(self.position.x + halfWidth, self.position.y - halfHeight), 
        projectile_speed_to_use)
    $Projectiles.add_child(projectile_instance)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass
